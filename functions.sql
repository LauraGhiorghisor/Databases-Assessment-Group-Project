/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\functions.sql
-- @/Users/Laura/csy2038/DB-AS2/functions.sql
-- @C:\Users\Daiana\Desktop\functions.txt



SET SERVEROUTPUT ON


-- func_xp_name - Retrieve experience name based on experience id.
CREATE OR REPLACE FUNCTION func_xp_name (in_xp_id IN experiences.experience_id%TYPE) RETURN VARCHAR2 IS
	vc_experience_name experiences.experience_name%TYPE;
BEGIN
    SELECT experience_name
    INTO vc_experience_name
    FROM experiences
    WHERE experience_id = in_xp_id;

	RETURN vc_experience_name;
END func_xp_name;
/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE proc_xp_name (in_xp_id IN experiences.experience_id%TYPE) IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('The experience name is "' || func_xp_name(in_xp_id) || '".');
END proc_xp_name;
/
SHOW ERRORS;

-- Testing "test_script_6'
EXECUTE proc_xp_name(1);
-- The experience name is "LUXURY DINNER FOR 4".




-- func_staff_total
CREATE OR REPLACE FUNCTION func_staff_total (in_xp_id IN experiences.experience_id%TYPE) RETURN NUMBER IS

vn_staff_no NUMBER(3);

BEGIN

SELECT SUM(a.no_staff_needed)
INTO vn_staff_no
FROM experiences e, TABLE (e.activities) a
WHERE experience_id = in_xp_id;


RETURN vn_staff_no;

END func_staff_total;
/
SHOW ERRORS;

-- procedure to test func_staff_total
CREATE OR REPLACE PROCEDURE proc_staff_total IS

BEGIN 

	DBMS_OUTPUT.PUT_LINE ('The total number of staff required for experience of ID 1 is ' || func_staff_total(1));

END proc_staff_total;
/
SHOW ERRORS
-- Testing "test_script_7"
EXECUTE proc_staff_total
-- The total number of staff required for experience of ID 1 is 6




-- func_duration
CREATE OR REPLACE FUNCTION func_duration (in_start_date DATE, in_end_date DATE) RETURN NUMBER IS
	vn_days NUMBER(4);
BEGIN
	vn_days := in_end_date - in_start_date;
	RETURN vn_days;
END func_duration;
/
SHOW ERRORS;

-- procedure to test func_duration
CREATE OR REPLACE PROCEDURE proc_test_duration IS

BEGIN 

	DBMS_OUTPUT.PUT_LINE ('Duration is ' || func_duration('01-JAN-1991', '30-JAN-1991'));

END proc_test_duration;
/
SHOW ERRORS
-- Testing "test_script_8"
EXECUTE proc_test_duration
-- Duration is 29



-- func_xp_price_avg
CREATE OR REPLACE FUNCTION func_xp_price_avg (in_xp_id IN experiences.experience_id%TYPE)
RETURN NUMBER IS 

      vn_price_avg NUMBER(9,2);
	
	  BEGIN
	       SELECT AVG(price)
		   INTO vn_price_avg
		   FROM tickets
		   WHERE experience_id = in_xp_id;

		   RETURN vn_price_avg;

	  END func_xp_price_avg;
/	   
SHOW ERRORS;

--Procedure to test function func_xp_price_avg
CREATE OR REPLACE PROCEDURE proc_xp_price_avg (in_xp_id IN experiences.experience_id%TYPE) IS

    vn_avg_price NUMBER(9,2);
	vv_xp_name experiences.experience_name%TYPE;

BEGIN
    vn_avg_price := func_xp_price_avg(in_xp_id);

	DBMS_OUTPUT.PUT_LINE ('Average ticket price for ' || func_xp_name(in_xp_id) || ' is ' || vn_avg_price);
END proc_xp_price_avg;
/
SHOW ERRORS

-- Testing "test_script_9"
EXECUTE proc_xp_price_avg(1);
-- Average ticket price for LUXURY DINNER FOR 4 is 1066.67



-- func_takings_total - Total of tickets takings per experience
CREATE OR REPLACE FUNCTION func_takings_total (in_xp_id IN experiences.experience_id%TYPE) RETURN NUMBER IS
	vn_takings_total NUMBER(20);	  
BEGIN
	SELECT SUM(price)
	INTO vn_takings_total
	FROM tickets
	WHERE experience_id = in_xp_id;
			
	RETURN vn_takings_total;
END func_takings_total;
/	  
SHOW ERRORS;

--Procedure to test function func_takings_total
CREATE OR REPLACE PROCEDURE proc_xp_takings_total IS
BEGIN
	DBMS_OUTPUT.PUT_LINE ('The current takings are ' || func_takings_total(1) || ' for the given experience.');
END proc_xp_takings_total;
/
SHOW ERRORS;


-- Testing "test_script_10"
EXECUTE proc_xp_takings_total
-- The current takings are 3200 for the given experience.



-- func_annual_takings_total - Annual takings per experience
CREATE OR REPLACE FUNCTION func_annual_takings_total (in_xp_id IN experiences.experience_id%TYPE, in_year VARCHAR2) RETURN NUMBER IS
	vn_takings_total NUMBER(20);	  
BEGIN
	SELECT SUM(price)
	INTO vn_takings_total
	FROM tickets
	WHERE experience_id = in_xp_id AND date_sold BETWEEN '01-JAN-' || in_year AND '31-DEC-' || in_year;
			
	RETURN vn_takings_total;
END func_annual_takings_total;
/	  
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE proc_xp_annual_takings_total IS
BEGIN
	DBMS_OUTPUT.PUT_LINE ('The annual takings are  ' || func_annual_takings_total(1, '2020') || ' for the given experience.');
END proc_xp_annual_takings_total;
/
SHOW ERRORS;


-- Testing "test_script_11"
EXECUTE proc_xp_annual_takings_total
-- The annual takings are	3200 for the given experience.





-- func_season - Get season based on date
CREATE OR REPLACE FUNCTION func_season(in_date DATE)
RETURN VARCHAR2 IS
      vv_season experiences.season%TYPE;
	  BEGIN

	    IF EXTRACT(MONTH from in_date) IN (12,1,2) 
		THEN vv_season := 'WINTER';
		ELSIF EXTRACT(MONTH from in_date) IN (3,4,5) 
		THEN vv_season := 'SPRING';
		ELSIF EXTRACT(MONTH from in_date) IN (6,7,8) 
		THEN vv_season := 'WINTER';
		ELSE  vv_season := 'AUTUMN';
		END IF;

	RETURN vv_season;

END func_season;
/
SHOW ERRORS;

-- procedure to test func_season
CREATE OR REPLACE PROCEDURE proc_test_season(in_date DATE) IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('The season for ' || in_date || ' is ' || func_season(in_date));
END proc_test_season;
/
SHOW ERRORS;

-- Testing "test_script_12"
EXECUTE proc_test_season('22-MAR-2020');
-- The season for 22-MAR-20 is SPRING



-- func_sponsor_name - Retrieve sponsor name based on sponsor id.
CREATE OR REPLACE FUNCTION func_sponsor_name (in_sponsor_id sponsors.sponsor_id%TYPE) RETURN VARCHAR2 IS
	vc_sponsor_firstname sponsors.sponsor_firstname%TYPE;
	vc_sponsor_surname sponsors.sponsor_surname%TYPE;
	vc_sponsor_name VARCHAR2(61);
BEGIN
	SELECT sponsor_firstname
	INTO vc_sponsor_firstname
	FROM sponsors
	WHERE sponsor_id = in_sponsor_id;

	SELECT sponsor_surname
	INTO vc_sponsor_surname
	FROM sponsors
	WHERE sponsor_id = in_sponsor_id;

	RETURN vc_sponsor_firstname || ' ' || vc_sponsor_surname;
END func_sponsor_name;
/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE proc_sponsor_name (in_sponsor_id sponsors.sponsor_id%TYPE) IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('The sponsor name is "' || func_sponsor_name(in_sponsor_id) || '".');
END proc_sponsor_name;
/
SHOW ERRORS;


-- Testing "test_script_13"
EXECUTE proc_sponsor_name(1);
-- The sponsor name is "ANDREW ADAMS".





-- func_print_location_address - Prints location address in postal format
CREATE OR REPLACE FUNCTION func_print_location_address (in_location_id IN locations.location_id%TYPE) 
RETURN VARCHAR2 IS
 	vn_number VARCHAR2(30);
  	vc_street VARCHAR2(30);
   	vc_city VARCHAR2(30);
	vc_county VARCHAR2(30);
    vc_country VARCHAR2(30);
	vc_postcode VARCHAR2(10);
	vc_location VARCHAR2(500);
	  BEGIN
           SELECT l.address.house_no
	       INTO vn_number
	       FROM locations l
	       WHERE location_id = in_location_id;

		   SELECT l.address.street
	       INTO vc_street
	       FROM locations l
	       WHERE location_id = in_location_id;

		   SELECT l.address.city
	       INTO vc_city
	       FROM locations l
	       WHERE location_id = in_location_id;

		   SELECT l.address.county
	       INTO vc_county
	       FROM locations l
	       WHERE location_id = in_location_id;

		   SELECT l.address.country
	       INTO vc_country
	       FROM locations l
	       WHERE location_id = in_location_id;

		   SELECT l.address.postcode
	       INTO vc_postcode
	       FROM locations l
	       WHERE location_id = in_location_id;

			vc_location := CHR(10) || vn_number || ' ' || vc_street || CHR(10) || vc_city || CHR(10) || vc_county || CHR(10) || vc_country || CHR(10) || vc_postcode;
	       RETURN vc_location;
	  END func_print_location_address;
/
SHOW ERRORS;

--Procedure to test function func_print_location_address
CREATE OR REPLACE PROCEDURE proc_print_location_address (in_location_id IN locations.location_id%TYPE) IS
vc_location VARCHAR2(500);
	
BEGIN
    vc_location := func_print_location_address(in_location_id);
	DBMS_OUTPUT.PUT_LINE (vc_location);
END proc_print_location_address;
/
SHOW ERRORS; 

-- Testing "test_script_14"
EXEC proc_print_location_address(2)
/*
26 ALWOOD BUILDING BENJAMIN STREET
BATH
SOMERSET
UK
BA3 7TY
*/


--Return number of activities in an experience
CREATE OR REPLACE FUNCTION func_get_no_activities(in_experience_id IN experiences.experience_id%TYPE)
RETURN NUMBER IS
      vn_no_activities NUMBER(2);
      BEGIN
	     SELECT COUNT(a.activity_name)
	     INTO vn_no_activities
	     FROM experiences e,
	     TABLE (e.activities) a
	     WHERE e.experience_id = in_experience_id;

	     RETURN vn_no_activities;
	  END;
/

SHOW ERRORS;
 
--Procedure to test function func_get_no_activities 
CREATE OR REPLACE PROCEDURE proc_get_no_activities(in_experience_id IN experiences.experience_id%TYPE) IS
vn_activities_no NUMBER(2);
vv_xp_name VARCHAR2(50);
BEGIN
    vn_activities_no := func_get_no_activities(in_experience_id);
	vv_xp_name := func_xp_name(in_experience_id);

	DBMS_OUTPUT.PUT_LINE ('There are ' || vn_activities_no || ' activities in the experience ' || vv_xp_name);

END proc_get_no_activities;
/
SHOW ERRORS; 

-- Testing "test_script_15"
EXEC proc_get_no_activities(1);
-- There are 2 activities in the experience LUXURY DINNER FOR 4




-- Make string uppercase
CREATE OR REPLACE FUNCTION func_make_upper(in_string VARCHAR2) 
RETURN VARCHAR2 IS

	  BEGIN
	       RETURN UPPER(in_string);
	  END func_make_upper;
/
SHOW ERRORS;

-- Procedure to test func_make_upper: proc_upper
CREATE OR REPLACE PROCEDURE proc_upper(in_string VARCHAR2) IS
	
BEGIN
	DBMS_OUTPUT.PUT_LINE (func_make_upper(in_string));
END proc_upper;
/
SHOW ERRORS;

-- Testing "test_script_16"
EXEC proc_upper('anna');
-- ANNA


-- COMMIT CHANGES
COMMIT;



-- Testing "test_script_17"
-- 11 Functions in total
SELECT object_name FROM user_procedures WHERE object_name LIKE 'FUNC_%';
-- returns 11 rows


-- At this point there should also be 11 stored testing procedures
SELECT object_name FROM user_procedures WHERE object_name LIKE 'PROC_%';
-- returns 11 rows