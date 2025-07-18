CREATE TABLE sleep_data (
    date text,
    deepSleepTime INT,
    shallowSleepTime INT,
    wakeTime INT,
    start text,
    stop text,
    REMTime INT,
    naps INT
);


select *
from sleep_data;

ALTER TABLE sleep_data DROP COLUMN sleep_day;

CREATE TABLE sleep_data_alter1 (
    date Date,
    deepSleepTime INT,
    shallowSleepTime INT,
    wakeTime INT,
    start text,
    stop text,
    REMTime INT,
    naps INT
);


with duplicates as(
SELECT *,
         ROW_NUMBER() OVER(PARTITION BY `date`, deepSleepTime, shallowSleepTime, wakeTime, start, stop, REMTime,naps) AS row_num
FROM sleep_data
)
select *
from duplicates
where row_num>1;

-- no duplicates

select *
from sleep_data;

INSERT INTO sleep_data_alter1 (
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

alter table sleep_data_alter1
drop column naps;

select *
from sleep_data_alter1;

ALTER TABLE sleep_data_alter1
ADD COLUMN sleep_day DATE,
ADD COLUMN sleep_time_ist TIME,
ADD COLUMN wake_time_ist TIME;

select *
from sleep_data_alter1;

UPDATE sleep_data_alter1
SET sleep_time_ist = TIME(
  CONVERT_TZ(
    STR_TO_DATE(SUBSTRING(start, 1, 19), '%Y-%m-%d %H:%i:%s'),
    '+00:00',
    '+05:30'
  )
);
UPDATE sleep_data_alter1
SET wake_time_ist = TIME(
  CONVERT_TZ(
    STR_TO_DATE(SUBSTRING(stop, 1, 19), '%Y-%m-%d %H:%i:%s'),
    '+00:00',
    '+05:30'
  )
);

select *
from sleep_data_alter1;

UPDATE sleep_data_alter1
SET sleep_day = CASE
    WHEN sleep_time_ist >= '12:00:00' THEN DATE_SUB(date, INTERVAL 1 DAY)
    ELSE date
END
WHERE sleep_day IS NULL;


SELECT
  SUM(CASE WHEN sleep_day = `date` THEN 1 ELSE 0 END) AS days_equal,
  SUM(CASE WHEN sleep_day <> `date` THEN 1 ELSE 0 END) AS days_not_equal
FROM sleep_data_alter1;

alter table sleep_data_alter1
drop column start,
drop column stop;


select wakeTime,count(wakeTime)
from sleep_data_alter1
group by wakeTime
order by wakeTime asc
;
with cte as(
select *,(deepSleepTime+shallowSleepTime+REMTime) as total
from sleep_data_alter1
)
select avg(total) from cte
group by total
and total>0
;

select count(*) from sleep_data_alter1
where deepSleepTime=0 and shallowSleepTime=0 and REMTime=0;

select * from sleep_data_alter1;

select `date`,REMTime
from sleep_data_alter1
where deepSleepTime>0 and shallowSleepTime>0 and REMTime>0;


with cte as 
(
select REMTime as rem,
		deepSleepTime as deepsleep,
        shallowSleepTime as normal
from sleep_data_alter1
where shallowSleepTime>0
)
select avg(rem)/60 as hour_rem,avg(deepsleep)/60 as hour_deep,avg(normal)/60 as hour_shallow,avg(rem+deepsleep+normal)/60 as hour_total 
from cte
;

select * from sleep_data_alter1;

CREATE TABLE `sleep_data_alter2` (
  `date` date DEFAULT NULL,
  `deepSleepTime` int DEFAULT NULL,
  `shallowSleepTime` int DEFAULT NULL,
  `wakeTime` int DEFAULT NULL,
  `REMTime` int DEFAULT NULL,
  `sleep_day` date DEFAULT NULL,
  `sleep_time_ist` time DEFAULT NULL,
  `wake_time_ist` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into sleep_data_alter2
select * from sleep_data_alter1
where shallowSleepTime>0;

select * from sleep_data_alter2;

select count(*) from sleep_data_alter2;


select 
	SUM(CASE WHEN sleep_day = `date` THEN 1 ELSE 0 END) AS days_equal,
    SUM(CASE WHEN sleep_day <> `date` THEN 1 ELSE 0 END) AS days_not_equal
FROM sleep_data_alter2;


SELECT 
	DAYNAME(sleep_day) AS day_of_week,
    AVG(deepSleepTime + shallowSleepTime + REMTime) AS avg_sleep_time
FROM sleep_data_alter2
GROUP BY day_of_week
order by avg_sleep_time desc;

with cte as(
select 
	dayname(sleep_day) as day_of_week,
    ((REMTime/(deepSleepTime + shallowSleepTime + REMTime))*100) as percentage_rem,
    ((deepSleepTime/(deepSleepTime + shallowSleepTime + REMTime))*100) as percentage_deep,
    ((shallowSleepTime/(deepSleepTime + shallowSleepTime + REMTime))*100) as percentage_shallow
from sleep_data_alter2
WHERE (deepSleepTime + shallowSleepTime + REMTime) > 0
)
select 
	day_of_week,
    AVG(percentage_rem) AS avg_rem_percentage,
    AVG(percentage_deep) AS avg_deep_percentage,
    AVG(percentage_shallow) AS avg_shallow_percentage
from cte
group by day_of_week;

with cte as(
select 
	dayname(sleep_day) as day_of_week,
	sum(case when `sleep_time_ist`<'22:00:00' then 1 else 0 end) as before_10,
    sum(case when `sleep_time_ist`>='22:00:00' then 1 else 0 end) as after_10
from sleep_data_alter2
group by dayname(sleep_day)
)
select *
from cte
;


select * 
from sleep_data_alter2;


select * from sleep_data_alter4
where shallowSleepTime=0 and deepSleepTime=0 and REMTime =0 ;

SELECT 
    AVG(shallowSleepTime) AS avg_shallow,
    AVG(deepSleepTime) AS avg_deep,
    AVG(REMTime) AS avg_rem
FROM sleep_data_alter4
WHERE NOT (shallowSleepTime = 0 AND deepSleepTime = 0 AND REMTime = 0);


WITH avg_values AS (
    SELECT 
        AVG(shallowSleepTime) AS avg_shallow,
        AVG(deepSleepTime) AS avg_deep,
        AVG(REMTime) AS avg_rem
    FROM sleep_data_alter4
    WHERE NOT (shallowSleepTime = 0 AND deepSleepTime = 0 AND REMTime = 0)
)
UPDATE sleep_data_alter4
SET 
    shallowSleepTime = (SELECT avg_shallow FROM avg_values),
    deepSleepTime = (SELECT avg_deep FROM avg_values),
    REMTime = (SELECT avg_rem FROM avg_values)
WHERE shallowSleepTime = 0 AND deepSleepTime = 0 AND REMTime = 0;
ALTER TABLE sleep_data_alter4
MODIFY shallowSleepTime FLOAT,
MODIFY deepSleepTime FLOAT,
MODIFY REMTime FLOAT;

select count(*) from sleep_data_alter4;

select * from sleep_data_alter4;

select * from sleep_data_alter4
where shallowSleepTime =0;

