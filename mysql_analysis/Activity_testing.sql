CREATE TABLE activity (
    `date` date,
    `steps` int,
    `distance` int,
    `runDistance` int,
    `calories` int
);

select * from activity;

alter table activity 
drop column runDistance;

select * from activity;

select * 
from activity 
where calories =0;

CREATE TABLE activity1 (
    `date` date,
    `steps` int,
    `distance` int,
    `runDistance` int
);

insert into activity1 (
	`date`,
	`steps`,
    `distance`,
    `runDistance`
)
select `date`,
	`steps`,
    `distance`,
    `runDistance`
from activity;

select * from activity1;

alter table activity1
drop column runDistance;

select * from activity1;

select *
from activity1 as a
join sleep_data_alter4 as b
	on a.`date`=b.`date`
;

select * from sleep_data_alter4;

Create table activity_minutes
(
`date` date,
`time` time,
`steps` int
);

with cte as(
select `date`,sum(steps) as total_steps
from  activity_minutes
group by `date`
order by `date`
)
select count(*)
from cte;


with cte as(
select `date`,sum(steps) as total_steps
from  activity_minutes
group by `date`
order by `date`
)
select * 
from activity1 
join cte 
on cte.`date`=activity1.`date`;


Create table activity_stage(
`date` Date,
`start` time,
`stop` time,
distance int,
calories int,
steps int
);

with cte1 as(
select `date`,sum(steps) as total_steps
from  activity_stage
group by `date`
order by `date`
)
select count(*) from cte1;

with cte as(
select `date`,sum(steps) as total_steps
from  activity_minutes
group by `date`
order by `date`
),
cte1 as(
select `date`,sum(steps) as total_steps
from  activity_stage
group by `date`
order by `date`
)
select * 
from activity1 
join cte 
on cte.`date`=activity1.`date`
join cte1
on cte.`date`=cte1.`date`;

select * from activity_stage;
select * from activity_minutes;

with cte as(
select `date`,sum(calories) as total_calories
from activity_stage
group by `date`
order by `date`
)
select a.`date`,a.steps,a.distance,b.total_calories
from activity1 as a
join cte as b
on a.`date`=b.`date`;

Create table activity_total(
`date` date,
steps int,
distance int,
total_calories int);

Insert into activity_total
WITH cte AS (
    SELECT `date`, SUM(calories) AS total_calories
    FROM activity_stage
    GROUP BY `date`
)
SELECT a.`date`, a.steps, a.distance, b.total_calories
FROM activity1 AS a
JOIN cte AS b ON a.`date` = b.`date`;


select count(*) from activity_total;

select * from activity_total;

select total_calories,total_calories+1340 as total
from activity_total;

Update activity_total
SET total_calories = total_calories + 1340; 


select * from activity_total;


select * from activity_total
join sleep_data_alter4
where deepSleepTime is NUll;

SELECT 
  AVG(CASE WHEN deepSleepTime > 0 THEN deepSleepTime END) AS avg_deep,
  AVG(CASE WHEN shallowSleepTime > 0 THEN shallowSleepTime END) AS avg_shallow,
  AVG(CASE WHEN REMTime > 0 THEN REMTime END) AS avg_rem
FROM sleep_data_alter4;

select count(*) from sleep_data_alter4;
select count(*) from activity_total;

select * from sleep_data_alter4 where deepSleepTime=0;

select avg(deepSleepTime),avg(shallowSleepTime),avg(REMTime) from sleep_data_alter4;


UPDATE sleep_data_alter4
SET deepSleepTime =65
WHERE deepSleepTime = 0;

UPDATE sleep_data_alter4
SET shallowSleepTime = 285
WHERE shallowSleepTime = 0;

UPDATE sleep_data_alter4
SET REMTime = 72
WHERE REMTime = 0;


select * from sleep_data_alter4;

SELECT sleep_time_ist 
FROM sleep_data_alter4 
LIMIT 5;

select * from sleep_data_alter4
where
deepSleepTime =65;


select * from sleep_data_alter4
where sleep_time_ist = '00:00:00';


SELECT *
FROM sleep_data_alter4
WHERE TIME(sleep_time_ist) > '01:30:00' and TIME(sleep_time_ist)< '10:00:00';

select * from sleep_data_alter4
where wake_time_ist='00:00:00';

UPDATE sleep_data_alter4
SET wake_time_ist = '07:02:00'
WHERE wake_time_ist = '00:00:00';

select * from sleep_data_alter4;

select count(*) 
from sleep_data_alter4
where wakeTime>0;


CREATE TABLE `sleep_and_activity` (
  `date` date DEFAULT NULL,
  `deepSleepTime` int DEFAULT NULL,
  `shallowSleepTime` int DEFAULT NULL,
  `wakeTime` int DEFAULT NULL,
  `REMTime` int DEFAULT NULL,
  `sleep_day` date DEFAULT NULL,
  `sleep_time_ist` time DEFAULT NULL,
  `wake_time_ist` time DEFAULT NULL,
  `steps` int DEFAULT NULL,
  `distance` int DEFAULT NULL,
  `total_calories` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO sleep_and_activity (
  date, deepSleepTime, shallowSleepTime, wakeTime, REMTime,
  sleep_day, sleep_time_ist, wake_time_ist,
  steps, distance, total_calories
)
SELECT 
  s.date,
  s.deepSleepTime,
  s.shallowSleepTime,
  s.wakeTime,
  s.REMTime,
  s.sleep_day,
  s.sleep_time_ist,
  s.wake_time_ist,
  a.steps,
  a.distance,
  a.total_calories
FROM sleep_data_alter4 s
JOIN activity_total a ON s.date = a.date;

select * from sleep_and_activity;

select count(*)
from sleep_and_activity;
SELECT 
  *
FROM sleep_data_alter4 s
LEFT JOIN activity_total a ON s.date = a.date
WHERE a.date IS NULL;

select * from activity_total
where `date`='2025-02-12';

SELECT 
  *
FROM  activity_total a
LEFT JOIN sleep_data_alter4 s ON s.date = a.date
WHERE s.date IS NULL;


select * from sleep_and_activity;