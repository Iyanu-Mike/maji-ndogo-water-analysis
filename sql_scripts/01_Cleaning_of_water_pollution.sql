USE md_water_services; -- select our table md_water_services

-- select the first five rows of water_quality
SELECT * FROM water_quality limit 5;

-- select the first five rows of water_source
SELECT * FROM water_source limit 5;

-- select the first five rows of well_pollution
SELECT * FROM well_pollution limit 5;

-- SQL query to find all the unique types of water sources
SELECT distinct type_of_water_source FROM water_source;

-- records where time in queue in greater than 500 min
select * from visits
where time_in_queue > 500;

-- checking water souce with 500+ min
select * from water_source
where source_id = "SoRu35083224" or  source_id = "HaRu19601224" or source_id = "AkLu02523224";

-- checking water souce with 0 min
select * from water_source
where source_id = "KiRu28935224" or  source_id = "AmDa12214224" or source_id = "AkHa00070224";

-- acessing the quality of water sources
select * from water_quality
where subjective_quality_score = 10 and visit_count = 2; -- Quality score =  10 and was visited only 2 times

-- investigate popullation issues
select * from well_pollution Limit 5;

-- confirming pollution integrity 
select * from well_pollution
where results = 'Clean' and biological > 0.01;

-- Cleaning our pollution data 
select * from well_pollution
WHERE description LIKE "Clean_%"; --  selecting our descriptioon with celan attached to it 

-- updating the pollution table 
set SQL_SAFE_UPDATES = 0;
UPDATE
well_pollution
SET
description = 'Bacteria: E. coli' -- removing the "Clean"
WHERE
description = 'Clean Bacteria: E. coli';
UPDATE
well_pollution
SET
description = 'Bacteria: Giardia Lamblia'
WHERE
description = 'Clean Bacteria: Giardia Lamblia';
UPDATE
well_pollution
SET
results = 'Contaminated: Biological'  -- updating the clean to 'Contaminated: Biological'
WHERE
biological > 0.01 AND results = 'Clean';

drop table 
	`md_water_services`.`well_pollution_copy`