
-- Netflix case study--

drop table if exists netflix;
create table netflix

(
		show_id		varchar(7),
		type		varchar(10),
		title		varchar(150),
		director	varchar(210),
		casts		varchar(1000),
		country		varchar(150),
		date_added	varchar(50),
		release_year	int,
		rating			varchar(10),
		duration		varchar(15),
		listed_in		varchar(100),
		description		varchar(250)

)


select * from netflix;


select count(*) as total_content 
from netflix;


select distinct type 
from netflix;


-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows;

select * from netflix;

select 
		type,
		count(*) as total_content

from netflix
group by 1;


-- 2. Find the most common rating for movies and TV shows --


select * from netflix;

	select 
			type,
			rating
	from
	(
	select  
			type,
			rating,
			count(*),
			rank() over (partition by type order by count(*) desc ) as ranking_by_rating
	from Netflix
	group by 1,2
	) as t1
	where ranking_by_rating = 1;



-- 3. List all movies released in a specific year (e.g., 2020)--

	select * from netflix;

	select *
	from netflix
	where 
		type = 'Movie'
		and
		release_year = 2020;
	


-- 4. Find the top 5 countries with the most content on Netflix--

		 select * from netflix;

		select 
				unnest(string_to_array(country,',')) as Country,
				count(show_id) as total_content_released
		
		from netflix
		group by 1
		order by 2 desc
		limit 5;


		-- unnest --
		select 
				unnest(string_to_array(country,',')) as Country
		from netflix

-- 5. Identify the longest movie--

select * from netflix;


select 
		type,
		duration
from netflix
where type = 'Movie'
and 
duration = (select max(duration) from netflix);


-- 6. Find content added in the last 5 years--


select * from netflix;

SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';



-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

  select * from netflix;

select
		*
from
(
select  *,
		unnest(string_to_array (director, ',')) as Director_name
from netflix
) 
where director_name = 'Rajiv Chilaka';

  



-- 8. List all TV shows with more than 5 seasons

select * from netflix;


select 
		* 
from netflix
where
	type ='TV Show'
	and
	SPLIT_PART(duration, ' ', 1):: numeric > 5;



-- 9. Count the number of content items in each genre

select * from netflix;

select 
		unnest(string_to_array(listed_in, ',')) as genre,
		count(*)
from netflix
group by 1;









-- 10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!


select * from netflix;

select 
		extract (year from TO_DATE(date_added, 'MONTH DD, YYYY')) as date,
		country,
		count(*)
from netflix
where country ='India'
group by 1,2
order by 3 desc;


SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5;




-- 11. List all movies that are documentaries

select * from netflix;

select  
		*
from netflix
where listed_in ilike '%Documentaries%';



--12. Find all content without a director

select * from netflix;

select * 
from netflix
where director is null
;


--13. Find in how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix;

select * 
from netflix
where 
		casts ilike '%Salman Khan%'
		and
		release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select * from netflix;


select  
		--show_id,
		--casts,
		unnest(string_to_array(casts, ',')) as actors,
		count(*) as appeared_in_movies
from netflix
where country = 'India'
group by 1
order by 2 desc
limit 10
;




15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

select * from netflix;



select * 

from netflix
where
		description ilike '%kill%'
		or
		description ilike '%violence%';

-- --

with new_table
as
(
select 
*,
		case 
		when description ilike '%kill%'
		or
		description ilike '%violence%' then 'Violent_content'
		else 'good_content'
		end as category
from netflix
) 

select 
		category,
		count(*) as total_content
from new_table
group by 1 





