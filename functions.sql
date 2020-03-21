/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\functions.sql
-- @/Users/Laura/csy2038/DB-AS2/functions.sql


SET SERVEROUTPUT ON



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


-- func_duration
CREATE OR REPLACE FUNCTION func_duration (in_start_date DATE, in_end_date DATE) RETURN NUMBER IS

vn_months NUMBER(5);

BEGIN

vn_months := MONTHS_BETWEEN(in_start_date, in_end_date);
DBMS_OUTPUT.PUT_LINE(vn_months);
RETURN FLOOR(vn_months/24);

END func_duration;
/
SHOW ERRORS;





CREATE OR REPLACE FUNCTION func_start_end_date (in_xp_id IN experiences.experience_id%TYPE, out_varray_date date_varray_type) RETURN NUMBER IS

vn_months NUMBER(5);

BEGIN




vn_months := MONTHS_BETWEEN(in_start_date, in_end_date);

DBMS_OUTPUT.PUT_LINE(vn_months);
RETURN FLOOR(vn_months/24);

END func_start_end_date;
/
SHOW ERRORS;

-- 