
CREATE TABLE sleep_data_alter4 (
    date Date,
    deepSleepTime INT,
    shallowSleepTime INT,
    wakeTime INT,
    start text,
    stop text,
    REMTime INT
);

INSERT INTO sleep_data_alter4 (
  date,
  deepSleepTime,
  shallowSleepTime,
  wakeTime,
  start,
  stop,
  REMTime
)
SELECT
  date,
  deepSleepTime,
  shallowSleepTime,
  wakeTime,
  start,
  stop,
  REMTime
FROM sleep_data;

ALTER TABLE sleep_data_alter4
ADD COLUMN sleep_day DATE,
ADD COLUMN sleep_time_ist TIME,
ADD COLUMN wake_time_ist TIME;


UPDATE sleep_data_alter4
SET sleep_time_ist = TIME(
  CONVERT_TZ(
    STR_TO_DATE(SUBSTRING(start, 1, 19), '%Y-%m-%d %H:%i:%s'),
    '+00:00',
    '+05:30'
  )
);
UPDATE sleep_data_alter4
SET wake_time_ist = TIME(
  CONVERT_TZ(
    STR_TO_DATE(SUBSTRING(stop, 1, 19), '%Y-%m-%d %H:%i:%s'),
    '+00:00',
    '+05:30'
  )
);

UPDATE sleep_data_alter4
SET sleep_day = CASE
    WHEN sleep_time_ist >= '12:00:00' THEN DATE_SUB(date, INTERVAL 1 DAY)
    ELSE date
END
WHERE sleep_day IS NULL;

alter table sleep_data_alter4
drop column start,
drop column stop
;
UPDATE sleep_data_alter4
SET deepSleepTime =65
WHERE deepSleepTime = 0;

UPDATE sleep_data_alter4
SET shallowSleepTime = 285
WHERE shallowSleepTime = 0;

UPDATE sleep_data_alter4
SET REMTime = 72
WHERE REMTime = 0;


UPDATE sleep_data_alter4
SET wake_time_ist = '07:02:00'
WHERE wake_time_ist = '00:00:00';
