import mysql.connector

conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='',
    database='workout_sleep'
)
cursor = conn.cursor()

# Step 1: Create the `activity` table
cursor.execute("""
CREATE TABLE IF NOT EXISTS activity (
    `date` DATE,
    `steps` INT,
    `distance` INT,
    `calories` INT
);
""")
conn.commit()

# Step 2: Insert values using CTE-like logic (emulated in Python)
cursor.execute("""
INSERT INTO activity (`date`, steps, distance, calories)
SELECT a.`date`, a.steps, a.distance, b.total_calories
FROM activity1 AS a
JOIN (
    SELECT `date`, SUM(calories) AS total_calories
    FROM activity_stage
    GROUP BY `date`
) AS b
ON a.`date` = b.`date`;
""")
conn.commit()

# Step 3: Add 1340 resting calories
cursor.execute("""
UPDATE activity
SET calories = calories + 1340;
""")
conn.commit()

# Cleanup
cursor.close()
conn.close()
