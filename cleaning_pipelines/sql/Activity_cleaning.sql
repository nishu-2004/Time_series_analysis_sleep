CREATE TABLE activity (
    `date` date,
    `steps` int,
    `distance` int,
    `calories` int
);

Insert into activity
WITH cte AS (
    SELECT `date`, SUM(calories) AS total_calories
    FROM activity_stage
    GROUP BY `date`
)
SELECT a.`date`, a.steps, a.distance, b.total_calories
FROM activity1 AS a
JOIN cte AS b ON a.`date` = b.`date`
;

Update activity_total
SET total_calories = total_calories + 1340; 
-- 1340 because for me the amount of calories burnt without doing anything is that much