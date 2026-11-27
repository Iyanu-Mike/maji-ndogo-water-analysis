use md_water_services;

-- adding employee email adress

SELECT
Lower(REPLACE(employee_name, ' ','.')) -- Replace the space with a full stop and add make it lower case
FROM
employee;

SELECT 
concat(Lower(REPLACE(employee_name, ' ','.')), '@ndogowater.gov') as new_email -- add it all together 
from employee;

set SQL_SAFE_UPDATES = 0;

update employee
SET email = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')),
'@ndogowater.gov'); -- add the email to the employee table

-- cleaning phone number
update employee
set phone_number = trim(phone_number);

-- count number of employees in each town

select town_name, count(*) as employee_count
from employee
group by town_name;

-- gettig the top 3 surveyors but number of visits
select assigned_employee_id, count(assigned_employee_id) as number_of_location_visited
from visits
group by assigned_employee_id
order by count(assigned_employee_id) desc limit 3;

-- fetching info of the top 3 surveyors
select * from employee
where assigned_employee_id = 1 or assigned_employee_id = 30 or assigned_employee_id = 34;

-- counting number of records per town
select town_name, count(town_name) as records_per_town
from location
group by town_name
order by count(town_name) desc;

-- records per province
select province_name, count(province_name) as records_per_province
from location
group by province_name
order by count(province_name) desc;

-- documentation of town and province
select province_name, town_name, count(town_name) as records_per_town
from location
group by province_name, town_name
order by province_name, count(town_name) desc;

-- documentation by location type
select location_type, count(location_type) as num_source
from location 
group by location_type
order by count(location_type);

-- getting the percentage of rural water supply
select 23740 / (15910 + 23740) * 100;   -- 60% of our water are in rural sources 

-- number of the diffrent water sources 
select type_of_water_source, count(type_of_water_source) as num_sources
from water_source
group by type_of_water_source
order by count(type_of_water_source) desc;

-- average users per water source
select type_of_water_source, round(avg(number_of_people_served), 0) as num_sources
from water_source
group by type_of_water_source
order by round(avg(number_of_people_served), 0) desc;

-- percentange of users per sourse of water 
select type_of_water_source, round((sum(number_of_people_served)/27000000) * 100, 0) as percentage_ppl_per_source
from water_source
group by type_of_water_source
order by round((sum(number_of_people_served)/27000000) * 100, 0) desc;

-- rank of total ppl serverd 
select type_of_water_source, sum(number_of_people_served) as number_of_people,
	RANK() over(order by sum(number_of_people_served) desc) as rank_by_population
from water_source
group by type_of_water_source;

-- priotirizing repairs
select *, dense_rank() over(order by number_of_people_served desc) as priority_rank
from water_source;


-- analyzing time taken for the survey
select 
min(time_of_record) as MINIMUM,
max(time_of_record) as maximum,
datediff(max(time_of_record), min(time_of_record)) as no_of_days
from visits;

-- average time in queue
select round(avg(nullif(time_in_queue, 0)), 0) as average_time_in_queue
from visits;

-- average time for each day of the week
select dayname(time_of_record), round(avg(nullif(time_in_queue, 0)), 0) as average_time_in_queue
from visits
group by dayname(time_of_record);

--  average time in queue for each hour of the day 
select  TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
round(avg(nullif(time_in_queue, 0)), 0) as average_time_in_queue		
from visits
group by TIME_FORMAT(TIME(time_of_record), '%H:00');

-- Pivot table
SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
-- Sunday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END
),0) AS Sunday,
-- Monday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
ELSE NULL
END
),0) AS Monday,
-- Tuesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
ELSE NULL
END
),0) AS Tuesday,
-- Wednesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = "Wednesday" THEN time_in_queue
ELSE NULL
END
),0) AS Wednesday,
-- Thursday 
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = "Thursday" THEN time_in_queue
ELSE NULL
END
),0) AS Thursday,
-- Friday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = "Friday" THEN time_in_queue
ELSE NULL
END
),0) AS Friday,
-- saturday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = "Saturday" THEN time_in_queue
ELSE NULL
END
),0) AS Saturday
FROM
visits
WHERE
time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
hour_of_day
ORDER BY
hour_of_day;