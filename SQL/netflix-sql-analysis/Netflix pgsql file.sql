
--Netflix Project--
Drop table if exists Netflix;
create table Netflix(
show_id varchar(6),
type	varchar(10),
title varchar(150),	
director varchar(250),	
casts varchar(1000),
country	varchar(150),
date_added varchar(50),	
release_year int,	
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
);

select * from Netflix;

select count(*) as total_content from Netflix;

select distinct type from Netflix;

--15 Business Problems--
1. Count the number of Movies vs TV Shows

select type, count(*) as total_content from Netflix group by type;

2. Find the most common rating for movies and TV shows

select type, rating, count(*) as total, rank() over(partition by type order by count(*) desc) as ranking from Netflix group by type, rating order by total desc ;

3. List all movies released in a specific year (e.g., 2020)
select * from Netflix;

select * from Netflix where type = 'Movie' and release_year='2020';

4. Find the top 5 countries with the most content on Netflix
select unnest(string_to_array(country,','))as new_country, count(show_id)as total_content from Netflix group by 1 order by 2 desc limit 5

5.Identify the longest movie duration.

select * from netflix where type='Movie' and duration=(select max(duration) from netflix);

6. Find content added in the last 5 years

select count(*) from netflix where release_year in (2021,2020,2019,2018,2017);

7.Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix where director Ilike '%Rajiv Chilaka%';

8.List all TV shows with more than 5 seasons

SELECT * FROM netflix WHERE type = 'TV Show' AND split_part(duration, ' ', 1)::INT>5;

9.Count the number of content items in each genre

select unnest(string_to_array(listed_in,','))as genre, count(show_id)from netflix group by 1;

10.Find each year and the average number of content release in India on netflix, return top 5 year with highest avg content release!

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS total_content,
    ROUND(
        COUNT(*)::NUMERIC
        / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::NUMERIC
        * 100,
        2
    ) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 1;

11. List all movies that are documentaries

select * from netflix where listed_in ilike '%documentaries%';

12. Find all content without a director

select * from netflix where director is null;

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix where casts ilike '%salman Khan%' and release_year > extract(year from current_date)-10;

14. Find the top 10 actors who have appeared in the highest number of movies produced

select unnest(string_to_array(casts,',')) as actrors, count(*) as total_content from netflix where country ilike '%india' group by 1 order by 2 desc limit 10;

15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

with new_table 
as(
select *, 
       case 
	   when
	        description ilike '%killer%' or 
			description ilike '%violence%' then 'Bad_content'
			else 'Good_content'
		end category 
from netflix 
)
select category, 
       count(*)as total_content
from new_table 
group by 1;
