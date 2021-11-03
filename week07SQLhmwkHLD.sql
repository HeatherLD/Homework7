{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fswiss\fcharset0 Helvetica-Bold;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww16500\viewh9060\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs36 \cf0 Week 7 Homework\
Heather Leighton-Dick
\fs24 \
\

\f1\b\fs28 1. Create a new column called \'93status\'94 in the rental table that uses a case statement to indicate if a film was returned late, early, or on time.
\f0\b0\fs24 \
\
ALTER TABLE rental ADD COLUMN "status" varchar(15);\
UPDATE rental SET "status" =\
	CASE WHEN EXTRACT(epoch FROM (r.return_date - r.rental_date)/(60*60*24)) < f.rental_duration THEN 'early'\
		WHEN EXTRACT(epoch FROM (r.return_date - r.rental_date)/(60*60*24)) = f.rental_duration THEN 'on time'\
		WHEN EXTRACT(epoch FROM (r.return_date - r.rental_date)/(60*60*24)) > f.rental_duration THEN 'late'\
		ELSE 'never returned' END\
FROM rental AS r\
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id\
INNER JOIN film AS f ON i.film_id = f.film_id;\
\
I wrote a case statement which turned the difference between the return date and the rental date into an interval, then compared it with rental duration and assigned a status based on that comparison. I was able to pull the requisite columns from the film and rental tables by joining them via the inventory table. Finally, I altered the rental table by adding a column called \'93status.\'94\
\

\f1\b\fs28 2. Show the total payment amounts for people who live in Kansas City or Saint Louis.
\f0\b0\fs24 \
\
SELECT a.city_id, city.city, SUM(amount)\
FROM payment AS p\
INNER JOIN customer AS c\
ON p.customer_id = c.customer_id\
INNER JOIN address as a\
ON c.address_id = a.address_id\
INNER JOIN city\
ON a.city_id = city.city_id\
WHERE a.city_id = 262 OR a.city_id = 441\
GROUP BY a.city_id, city.city;\
\
Kansas City: $81.81\
Saint Louis: $78.79\
\
I joined four tables to get the payment information for people whose address is either in the city of Kansas City or the city of Saint Louis. Then I added up the amounts they paid and grouped by city to get the total per city.\
\

\f1\b\fs28 3. How many films are in each category? Why is there a table for category and a table for film category?
\f0\b0 \

\fs24 \
SELECT COUNT(film_id)\
FROM film_category\
GROUP BY category_id;\
\
There could be a separate table for category in case there are other types of media to categorize, which would in turn have their own table. For example, if the rental company also rented DVDs of TV shows, they could also be categorized by genre but might be stored in a separate table with extra information about seasons/series/episodes.\
\

\f1\b\fs28 4. Show a roster for the staff that includes their email, address, city, and country (not ids).
\f0\b0\fs24 \
\
SELECT last_name, first_name, address, country, email\
FROM staff AS s\
INNER JOIN address AS ad\
ON s.address_id = ad.address_id\
INNER JOIN city\
ON ad.city_id = city.city_id\
INNER JOIN country as ct\
ON city.country_id = ct.country_id\
ORDER BY last_name;\
\
I joined four tables (staff, address, city, country) to be able to access the right information (email, address, city, country). In addition, I selected first and last names, then grouped alphabetically by last name to form the roster.\
\

\f1\b\fs28 5. Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005.
\f0\b0\fs24 \
\
SELECT f.film_id, f.title, f.length\
FROM film AS f\
INNER JOIN inventory AS i\
ON f.film_id = i.film_id\
INNER JOIN rental AS r\
ON i.inventory_id = r.inventory_id\
WHERE return_date\
BETWEEN '2005-05-15 00:00:01'::timestamp AND '2005-05-31 11:59:59'::timestamp\
ORDER BY title;\
\
I joined three tables (film, inventory, and rental) to get the film_id, title, and length information and the return dates from the rental table. Then I selected based on a return date in the range of May 15 to 31, 2005, and ordered by title.\
\

\f1\b\fs28 6. Write a subquery to show which movies are rented below the average price for all movies.
\f0\b0\fs24 \
\
SELECT title, rental_rate\
FROM film\
WHERE rental_rate <\
	(SELECT AVG(rental_rate)\
	FROM film);\
\
I used the subquery to pull the average rental rate from the film table, and then compared that result to each rental rate.\
\

\f1\b\fs28 7. Write a join statement to show which movies are rented below the average price for all movies.
\f0\b0\fs24 \
\
SELECT f.title, rental_rate, avg_rental_rate \
FROM film AS f\
CROSS JOIN (SELECT AVG(rental_rate)::numeric(4,2) AS avg_rental_rate\
	FROM film) AS avg_rate\
WHERE f.rental_rate < avg_rental_rate;\
\
I used the CROSS JOIN to create a table derived from the rental table data with only the average rental price as its value. Then I compared that table to the film table\'92s rental_rate column and selected for those movies which are rented below the average price.\
\

\f1\b\fs28 8. Perform an explain plan on 6 and 7, and describe what you\'92re seeing and important ways they differ.
\f0\b0\fs24 \
\
Explain Analyze Plan, #6:\
"Seq Scan on film  (cost=66.51..133.01 rows=333 width=21) (actual time=0.712..1.277 rows=341 loops=1)"\
"  Filter: (rental_rate < $0)"\
"  Rows Removed by Filter: 659"\
"  InitPlan 1 (returns $0)"\
"    ->  Aggregate  (cost=66.50..66.51 rows=1 width=32) (actual time=0.690..0.691 rows=1 loops=1)"\
"          ->  Seq Scan on film film_1  (cost=0.00..64.00 rows=1000 width=6) (actual time=0.011..0.270 rows=1000 loops=1)"\
"Planning Time: 0.205 ms"\
"Execution Time: 1.486 ms"\
\
Explain Analyze Plan, #7:\
"Nested Loop  (cost=66.50..143.03 rows=333 width=33) (actual time=7.096..7.781 rows=341 loops=1)"\
"  Join Filter: (f.rental_rate < ((avg(film.rental_rate))::numeric(4,2)))"\
"  Rows Removed by Join Filter: 659"\
"  ->  Aggregate  (cost=66.50..66.52 rows=1 width=12) (actual time=7.070..7.071 rows=1 loops=1)"\
"        ->  Seq Scan on film  (cost=0.00..64.00 rows=1000 width=6) (actual time=0.047..6.711 rows=1000 loops=1)"\
"  ->  Seq Scan on film f  (cost=0.00..64.00 rows=1000 width=21) (actual time=0.015..0.270 rows=1000 loops=1)"\
"Planning Time: 0.422 ms"\
"Execution Time: 9.378 ms"\
\
The EXPLAIN ANALYZE plans show what is happening in the background behind the code: #6 is a relatively simple scan in sequence which is then filtered through a condition (rental_rate < $0), and then compared with the result of the aggregate function AVG on the rental_rate column. In contrast, #7 has the same sequence scan at the center of a nested loop while the conditional filter is in a JOIN (f.rental_rate < ((avg(film.rental_rate))::numeric(4,2))). The code for #7 takes about twice as long in Planning Time, and about 6 times as long in Execution Time. The majority of the extra time in #7 appears to be happening in the Nested Loop (\'85actual time=7.096 [ms]). \
\

\f1\b\fs28 9. With a window function, write a query that shows the film, the film\'92s duration, and what percentile the duration fits into.
\f0\b0\fs24 \
\
SELECT title, length,\
	NTILE(100) OVER (ORDER BY length)\
	AS percentile\
FROM film\
ORDER BY percentile;\
\
From the film table, I selected the film title and film length, then added a percentile column using length (ORDER BY length).\
\

\f1\b\fs28 10. In under 100 words, explain what the difference is between set-based and procedural programming. Be sure to specify which SQL and Python are.
\f0\b0\fs24 \
\
Procedural programming, of which Python is an example, proceeds line by line through a series of commands and parameters and works filtering and manipulating one set of data. In contrast, set-based programming, like SQL, works among groups of data by creating interactions and pulling combined sets of data to analyze.\
}