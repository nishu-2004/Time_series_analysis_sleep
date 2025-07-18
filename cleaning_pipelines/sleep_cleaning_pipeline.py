import mysql.connector

conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='Kashyap@123!',
    database='workout_sleep'
)
cursor = conn.cursor()

# Function to safely add a column if it doesn't already exist
def add_column_if_not_exists(cursor, table, column, col_type):
    cursor.execute(f"""
        SELECT COUNT(*)
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE table_schema = 'workout_sleep'
        AND table_name = '{table}' 
        AND column_name = '{column}';
    """)
    if cursor.fetchone()[0] == 0:
        cursor.execute(f"ALTER TABLE {table} ADD COLUMN {column} {col_type};")
        conn.commit()

# Step 1: Create table if not exists
cursor.execute("""
CREATE TABLE IF NOT EXISTS sleep_data_alter4 (
    date DATE,
    deepSleepTime INT,
    shallowSleepTime INT,
    wakeTime INT,
    start TEXT,
    stop TEXT,
    REMTime INT
);
""")
conn.commit()

# Step 2: Copy data from original table
cursor.execute("""
INSERT INTO sleep_data_alter4 (date, deepSleepTime, shallowSleepTime, wakeTime, start, stop, REMTime)
SELECT date, deepSleepTime, shallowSleepTime, wakeTime, start, stop, REMTime
FROM sleep_data;
""")
conn.commit()

# Step 3: Add new columns safely
add_column_if_not_exists(cursor, 'sleep_data_alter4', 'sleep_day', 'DATE')
add_column_if_not_exists(cursor, 'sleep_data_alter4', 'sleep_time_ist', 'TIME')
add_column_if_not_exists(cursor, 'sleep_data_alter4', 'wake_time_ist', 'TIME')

# Step 4: Update new columns with converted timezone data
cursor.execute("""
UPDATE sleep_data_alter4
SET sleep_time_ist = TIME(
  CONVERT_TZ(STR_TO_DATE(SUBSTRING(start, 1, 19), '%Y-%m-%d %H:%i:%s'), '+00:00', '+05:30')
);
""")
conn.commit()

cursor.execute("""
UPDATE sleep_data_alter4
SET wake_time_ist = TIME(
  CONVERT_TZ(STR_TO_DATE(SUBSTRING(stop, 1, 19), '%Y-%m-%d %H:%i:%s'), '+00:00', '+05:30')
);
""")
conn.commit()

# Step 5: Set correct sleep_day based on sleep_time_ist
cursor.execute("""
UPDATE sleep_data_alter4
SET sleep_day = CASE
    WHEN sleep_time_ist >= '12:00:00' THEN DATE_SUB(date, INTERVAL 1 DAY)
    ELSE date
END
WHERE sleep_day IS NULL;
""")
conn.commit()

# Step 6: Drop original 'start' and 'stop' columns
cursor.execute("ALTER TABLE sleep_data_alter4 DROP COLUMN start, DROP COLUMN stop;")
conn.commit()

# Step 7: Update values for zero deepSleepTime, shallowSleepTime, REMTime
cursor.execute("""
UPDATE sleep_data_alter4
SET deepSleepTime = 65
WHERE deepSleepTime = 0;
""")
conn.commit()

cursor.execute("""
UPDATE sleep_data_alter4
SET shallowSleepTime = 285
WHERE shallowSleepTime = 0;
""")
conn.commit()

cursor.execute("""
UPDATE sleep_data_alter4
SET REMTime = 72
WHERE REMTime = 0;
""")
conn.commit()

# Step 8: Replace default wake_time_ist with actual value
cursor.execute("""
UPDATE sleep_data_alter4
SET wake_time_ist = '07:02:00'
WHERE wake_time_ist = '00:00:00';
""")
conn.commit()

# Cleanup
cursor.close()
conn.close()
