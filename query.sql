/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\query.sql
-- @/Users/Laura/csy2038/DB-AS2/query.sql


-- QUERIES 
-- Object table: addresses
SELECT * FROM addresses WHERE street = 'ANDERSON STREET';
-- 17 ALPHA HOUSE (...)

SELECT REF(a) FROM addresses a WHERE street = 'BENJAMIN STREET';
-- 0000280209CD5D6F6CBB9A474F926BF53A1FBEF5900526C1B0293C4BBEACC7A3461368029A018086160001




-- Object column: address in sponsor
SELECT deref(address) FROM locations;
--returns ADDRESS_TYPE(...)

SELECT address FROM sponsors;
-- returns ADDRESS_TYPE(...)

SELECT s.address.house_no, s.address.street, s.address.city, s.address.county, s.address.postcode, s.address.country
FROM sponsors s 
WHERE sponsor_id = 1;
-- 34 COPPER STREET  CAMBRIDGE (...)




-- Nested Table
-- Column Formatting
COLUMN experience_id HEADING ID
COLUMN experience_id FORMAT 999999
COLUMN experience_name HEADING xp|name
COLUMN experience_name FORMAT A20 WORD_WRAPPED
COLUMN no_staff_needed HEADING staff
COLUMN no_staff_needed FORMAT 999999
COLUMN cost HEADING cost
COLUMN cost FORMAT 999999
COLUMN activity_name FORMAT A25
COLUMN activity_date LIKE experience_name HEADING date
-- BREAK ON experience_id, or:
BREAK ON activity_name

-- multiple object query: simple varray and nested table
SELECT e.experience_id, e.experience_name, a.activity_name, a.no_staff_needed, d.*
FROM experiences e, TABLE (e.activities) a, TABLE(a.activity_date) d
WHERE experience_id = 2; 
-- Gives all activities under COMEDY NIGHT and their dates


SELECT e.experience_id,  a.activity_name 
FROM experiences e, TABLE (e.activities) a 
WHERE a.activity_name LIKE '%DRINK%';
-- gives all experiences that include the string 'DRINK'

SELECT e.experience_id, COUNT(a.activity_name) 
FROM experiences e, TABLE (e.activities) a
GROUP BY experience_id;
-- gives the number of activities per experience




-- Simple VARRAY
BREAK ON experience_id
SELECT experience_id, d.*
FROM experiences e, TABLE (e.experience_date) d
WHERE experience_id = 1;
-- gives start and end date for experience of ID 1
--  1 16-NOV-19
--    17-NOV-19


-- Varray 
-- Column formatting
-- CLEAR COLUMNS 
COLUMN sponsor_id FORMAT 999999
COLUMN postcode FORMAT A7 
COLUMN country FORMAT A10 
COLUMN firstname FORMAT A10 
COLUMN contact_form FORMAT A10 
COLUMN details FORMAT A10 WORD_WRAPPED
COLUMN comments FORMAT A10 WORD_WRAPPED
BREAK ON sponsor_id


SELECT sponsor_id, sponsor_firstname, s.address.postcode, s.address.country, c.contact_form, c.details, c.comments
FROM sponsors s, TABLE (s.contact) c
WHERE sponsor_id = 1;
-- prints address and contacts


SELECT sponsor_id, sponsor_firstname, c.*
FROM sponsors s, TABLE (s.contact) c
WHERE sponsor_id = 1;
-- prints all contacts




--------------------------------------------------			 
-- JOINS

--2 Table Join
BREAK ON sponsor_id
SELECT l.location_id, l.address.street, e.experience_name, e.season
FROM locations l
JOIN experiences e
ON l.location_id = e.location_id
WHERE e.location_id = 1;
--Returns 1 row

--3 Table Join
SELECT sponsors.sponsor_id, sponsors.sponsor_surname, experiences.experience_name
FROM sponsors
JOIN tickets
ON sponsors.sponsor_id = tickets.sponsor_id
JOIN experiences
ON experiences.experience_id = tickets.experience_id;
--Returns 9 rows

--Full Outer Join
SELECT experience_nature.experience_nature_id, experience_nature.experience_nature_name, experiences.experience_name, locations.location_id
FROM experience_nature
FULL OUTER JOIN experiences
ON experience_nature.experience_nature_id = experiences.experience_nature_id
FULL OUTER JOIN locations
ON experiences.location_id = locations.location_id
ORDER BY location_id;
--Returns 7 rows

--LEFT JOIN
SELECT e.experience_id, e.experience_name, t.price
FROM experiences e
LEFT JOIN tickets t
ON e.experience_id = t.experience_id
WHERE price > 100.00
AND e.experience_name LIKE 'H%';
--Returns 1 row

--Right Join
SELECT en.experience_nature_name, e.experience_id, e.experience_name
FROM experiences e
RIGHT JOIN experience_nature en
ON e.experience_nature_id = en.experience_nature_id
WHERE e.experience_id = 4;
--Returns 1 row

--UNION
SELECT e.experience_id, e.location_id
FROM experiences e
UNION
SELECT t.ticket_number, t.price
FROM tickets t
WHERE t.price < 300 AND t.price > 40;
--8 rows returned

SELECT sponsor_id
FROM sponsors
WHERE sponsor_surname LIKE 'D_'
UNION
SELECT ticket_number
FROM tickets
WHERE experience_id > 2
AND price > 20;
--Returns 4 rows

SELECT house_no, postcode, country
FROM addresses
MINUS(
      SELECT s.address.street, s.address.city, s.address.county
	  FROM sponsors s
	  WHERE s.address.county != 'CAMBRIDGESHIRE'
	  UNION 
	  SELECT l.address.street, l.address.city, l.address.county
	  FROM locations l
	  WHERE L.address.county != 'CAMBRIDGESHIRE');
--Returns 5 rows

SELECT house_no, street, postcode
FROM addresses
INTERSECT(
          SELECT l.address.street, l.address.city, l.address.county
		  FROM locations l 
		  WHERE l.address.street = 'DOLBY STREET'
		  UNION
		  SELECT s.address.street, s.address.city, s.address.county
	      FROM sponsors s);
--No rows returned



--------------------------------------------------	
-- NESTED QUERIES

--Union based on address
SELECT a.city, a.country
FROM addresses a
WHERE country NOT IN(
     SELECT l.address.city
	 FROM locations l
	 UNION
	 SELECT s.address.city
	 FROM sponsors s
	 WHERE country = 'UK');
--5 rows returned

--Exists value from a Join	 
SELECT e.experience_id, e.activities
FROM experiences e
WHERE EXISTS(
             SELECT t.ticket_number, t.price, s.sponsor_surname
			 FROM sponsors s
			 JOIN tickets t
			 ON s.sponsor_id = t.sponsor_id
			 WHERE t.price > 150
			 AND s.sponsor_firstname IS NOT NULL);
-- 6 rows returned

--Sponsors not in Addresses		 
SELECT s.sponsor_id, s.sponsor_surname, s.contact	
FROM sponsors s
WHERE s.address.city NOT IN(
			         SELECT l.address.street
                     FROM locations l
					 WHERE l.address.country = 'UK')
ORDER BY s.sponsor_id;
--Returns 6 rows

--Nested Varray query					 
SELECT t.ticket_number, t.price
FROM tickets t
WHERE EXISTS(
             SELECT s.sponsor_id, c.contact_form, c.details
             FROM sponsors s,
             TABLE (s.contact) c
             WHERE s.sponsor_id = 3);	
--Returned 9 rows			 
					 
SELECT VALUE (e)
FROM THE(
         SELECT activities
		 FROM experiences
		 WHERE experience_id = 1) e;
--Returns 2 activity types
	 


--------------------------------------------------	
-- Queries with STATISTICAL functions
SELECT COUNT(*) FROM tickets 
WHERE sponsor_id = 1 AND experience_id = 1;
-- 3

SELECT MAX (price)
FROM tickets;
-- 2000

SELECT MIN (price)
FROM tickets
WHERE experience_id = 4;
-- 45

SELECT AVG(a.no_staff_needed)
FROM experiences e, TABLE(e.activities) a
WHERE experience_id = 1;
-- 3

SELECT SUM(a.no_staff_needed)
FROM experiences e, TABLE(e.activities) a
WHERE experience_id = 4;
-- 4

			 
-- Testing - "test_script_5"
/*
For Testing purposes, all the commands and outputs 
in this script will be referenced as 
"test_script_5". 

The results presented above assume that no 
additional inserts have been made other than 
the ones executed by running the script file in order.
*/
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 


