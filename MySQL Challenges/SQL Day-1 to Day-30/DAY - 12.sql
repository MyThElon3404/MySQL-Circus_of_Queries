-- QUESTION : 1
-- 1. Write a query to find no of gold model per swimmer, swimmer who only own gold model

drop table if exists events;
CREATE TABLE events (
	ID int,
	event varchar(255),
	YEAR INt,
	GOLD varchar(255),
	SILVER varchar(255),
	BRONZE varchar(255)
);

INSERT INTO events 
VALUES 
	(1,'100m',2016, 'Amthhew Mcgarray','donald','barbara'),
	(2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith'),
	(3,'500m',2016, 'Charles','Nichole','Susana'),
	(4,'100m',2016, 'Ronald','maria','paula'),
	(5,'200m',2016, 'Alfred','carol','Steven'),
	(6,'500m',2016, 'Nichole','Alfred','Brandon'),
	(7,'100m',2016, 'Charles','Dennis','Susana'),
	(8,'200m',2016, 'Thomas','Dawn','catherine'),
	(9,'500m',2016, 'Thomas','Dennis','paula'),
	(10,'100m',2016, 'Charles','Dennis','Susana'),
	(11,'200m',2016, 'jessica','Donald','Stefeney'),
	(12,'500m',2016,'Thomas','Steven','Catherine');

select * from events;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with only_gold_winnners_cte as (
	select distinct gold as swimmer
	from events
	where gold is not null
		and gold not in (
			select distinct silver from events
			where silver is not null
		)
		and gold not in (
			select distinct bronze from events
			where bronze is not null
		)
)
select og.swimmer as swimmer,
	count(id) as gold_model_count
from only_gold_winnners_cte as og
inner join events as e
	on og.swimmer = e.gold
group by og.swimmer;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------


-- ==================================================================================================================================
