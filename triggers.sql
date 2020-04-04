/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\triggers.sql
-- @/Users/Laura/csy2038/DB-AS2/triggers.sql
-- CSY2038_152@student/18408400

SET SERVEROUTPUT ON

-- USEFUL 
-- ALTER TRIGGER trigger_name DISABLE | ENABLE;
-- ALTER TABLE table name DISABLE ALL TRIGGERS;


ALTER SESSION SET nls_date_format='dd-MON-yyyy';
-- SELECT SYSDATE FROM DUAL;


-----------------------------------------------------------


-- trig_loc_insert_success -- prints success message upon insert
CREATE OR REPLACE TRIGGER trig_loc_insert_success
AFTER INSERT 
ON locations
FOR EACH ROW
WHEN (NEW.location_id IS NOT NULL)

BEGIN

DBMS_OUTPUT.PUT_LINE('The insert of a new location of ID '|| :NEW.location_id || ' was successful!' || CHR(10));

END trig_loc_insert_success;
/
SHOW ERRORS

-- testing - test_script_31
INSERT INTO locations(location_id, description, address)
SELECT seq_locations.nextval, 'LOCATION HAS WINE CELLAR, BAR WITH MULTIPLE SPIRITS AND SNACKS', REF(a)
FROM addresses a
WHERE a.street = 'ELMWOOD STREET';
-- The insert of a new location of ID 7 was successful!
-----------------------------------------------------------



-- trig_xp_predicates - prints message on INSERT and does not allow PK update
-- Using predicates
CREATE OR REPLACE TRIGGER trig_xp_predicates
BEFORE INSERT OR UPDATE OF experience_id
ON experiences
FOR EACH ROW
WHEN (NEW.experience_id IS NOT NULL)

BEGIN

IF INSERTING THEN 
DBMS_OUTPUT.PUT_LINE('You are now inserting');
ELSIF UPDATING THEN
RAISE_APPLICATION_ERROR(-20000, 'PK CANNOT BE ALTERED!');
END IF;

END trig_xp_predicates;
/
SHOW ERRORS

-- testing test_script_32
 UPDATE experiences
        SET experience_id = 345
        WHERE experience_id = 6;

SELECT *
FROM experiences 
WHERE experience_id = 345;

INSERT INTO experiences (experience_id, experience_nature_id, experience_name, season, location_id, description, activities)
VALUES(seq_experiences.nextval, 5, 'DUMMY', 'SUMMER', 2, 'DUMMY', 
activity_table_type(
                    activity_type('INDUCTION', 6, date_varray_type('01-JUL-2020', '01-JUL-2020')),
					activity_type('BATH IN BATH', 2, date_varray_type('02-JUL-2020', '02-JUL-2020')),
					activity_type('PHYSICAL TRAINING', 5, date_varray_type('03-JUL-2020', '05-JUL-2020')),
					activity_type('NUTRITION COURSE', 4, date_varray_type('06-JUL-2020', '06-JUL-2020')),
					activity_type('SPA DAY', 0, date_varray_type('03-JUL-2020', '05-JUL-2020')))
	  );
-- PK CANNOT BE ALTERED!
-- no rows selected
-- You are now inserting
-----------------------------------------------------------


-- trig_pk_sponsor_no_update - does not permit PK updates
CREATE OR REPLACE TRIGGER trig_pk_sponsor_no_update
BEFORE UPDATE
OF sponsor_id 
ON sponsors
FOR EACH ROW
WHEN (NEW.sponsor_id IS NOT NULL)

BEGIN
RAISE_APPLICATION_ERROR(-20000, 'PK CANNOT BE ALTERED!');

END trig_pk_sponsor_no_update;
/
SHOW ERRORS
-- testing - test_script_33
 UPDATE sponsors
        SET sponsor_id = 345
        WHERE sponsor_id = 1;

SELECT *
FROM sponsors 
WHERE sponsor_id = 345;
--  PK CANNOT BE ALTERED!
-----------------------------------------------------------


-- trig_upper_firstname - automates uppercase on firstname
CREATE OR REPLACE TRIGGER trig_upper_firstname
BEFORE INSERT
ON sponsors
FOR EACH ROW
WHEN (NEW.sponsor_firstname IS NOT NULL )

BEGIN
     :NEW.sponsor_firstname := func_make_upper(:NEW.sponsor_firstname);

    DBMS_OUTPUT.PUT_LINE('Firstname has been converted to uppercase.');

END trig_upper_firstname;
/
SHOW ERRORS

--testing - test_script_34
INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname, company_name, address, contact, registration_date)
VALUES(seq_sponsors.nextval, 'michael', 'MCCAN', UPPER('MM LTD'), 
       address_type('34', 'COPPER STREET', 'CAMBRIDGE', 'CAMBRIDGESHIRE', 'CB2 5EE', 'UK'),
	   contact_varray_type(
	                      (contact_type('FACEBOOK', 'APPLEWOOD LTD CAMBRIDGE', 'MESSAGE ONLY M-F 8-5')),
                          (contact_type('COMPANY PHONE', '01604786332', 'ONLY M-F 8-5')),
						  (contact_type('EMAIL', 'CONTACT@APPLEWOOD.CO.UK', NULL))), '20-MAY-1997');

SELECT sponsor_id, sponsor_firstname FROM sponsors WHERE sponsor_surname = 'MCCAN';
	--  9 MICHAEL
-----------------------------------------------------------


-- trig_sponsors_reg_date - automates registration date entries
CREATE OR REPLACE TRIGGER trig_sponsors_reg_date
BEFORE INSERT
ON sponsors
FOR EACH ROW
WHEN (NEW.registration_date IS NULL)

BEGIN
:NEW.registration_date := SYSDATE;

  DBMS_OUTPUT.PUT_LINE('Registration date initialized.');

END trig_sponsors_reg_date;
/
SHOW ERRORS
-- Testing - test_script_35
-- In order to successfully test, the DEFAULT constraint should be suspended.

ALTER TABLE sponsors
MODIFY registration_date DEFAULT NULL;

INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname)
VALUES (seq_sponsors.nextval, 'TEST', 'TEST');

SELECT registration_date FROM sponsors WHERE sponsor_firstname = 'TEST';

-----------------------------------------------------------


-- trig_security - only allows schema updates during working days and between working hours
-- https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/triggers.htm#LNPLS752
CREATE OR REPLACE TRIGGER trig_security
BEFORE INSERT OR UPDATE OR DELETE 
ON experiences

DECLARE
    no_weekends EXCEPTION;
    outside_hours EXCEPTION;
    PRAGMA exception_init(no_weekends, -20111);
    PRAGMA exception_init(outside_hours, -20112);
BEGIN

 DBMS_OUTPUT.PUT_LINE('deleting secutiry thing');

IF (INSTR(TO_CHAR(SYSDATE, 'DAY'),'SATURDAY')>0 OR INSTR(TO_CHAR(SYSDATE, 'DAY'),'SUNDAY')>0) THEN  
    RAISE no_weekends;
END IF;

IF (TO_CHAR(SYSDATE, 'HH24') < 9 OR TO_CHAR(Sysdate, 'HH24') > 16) THEN
    RAISE outside_hours;
END IF;

EXCEPTION
WHEN no_weekends THEN
    RAISE_APPLICATION_ERROR(-20111, 'CANNOT ALTER DATA DURING WEEKENDS!');
WHEN outside_hours THEN
    RAISE_APPLICATION_ERROR(-20112, 'CANNOT ALTER DATA OUTSIDE WORKING HOURS');

END trig_security;
/
SHOW ERRORS

-- Testing test_script_36
DELETE FROM experiences WHERE experience_id = 40;
SELECT experience_id FROM experiences;
-- CANNOT ALTER DATA OUTSIDE WORKING HOURS

-- ALTER TRIGGER trig_security DISABLE;
-- ALTER TRIGGER trig_security ENABLE;
-----------------------------------------------------------


-- trig_delete_sponsor -- prints message on delete
CREATE OR REPLACE TRIGGER trig_delete_sponsor
BEFORE DELETE 
ON sponsors
FOR EACH ROW

DECLARE

vn_sp_instance NUMBER(10);

BEGIN

SELECT sponsor_id
INTO vn_sp_instance
FROM tickets
WHERE sponsor_id = :OLD.sponsor_id;

IF (vn_sp_instance IS NOT NULL) THEN
    RAISE_APPLICATION_ERROR(-20001, 'You cannot delete this sponsor as it has dependencies.');
END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('The entry you''re trying to delete has no dependencies and is safe to delete.');
END;
/
SHOW ERRORS
-- Testing - test_script_37
INSERT INTO sponsors
VALUES(seq_sponsors.nextval, 'TEST5', 'TESTY', 'ECOMMERCE UK', 
       address_type('75', 'EASTER ROAD', 'KETTERING', 'NORTHAMPTONSHIRE', 'NN7 5EF', 'UK'),
	   contact_varray_type(
	                      (contact_type('FACEBOOK', 'ECOMMERCE UK', NULL)),
                          (contact_type('PERSONAL PHONE', '07534672889', 'CAN CALL EVEN AFTER 6 PM')),
						  (contact_type('EMAIL', 'ELY@ECOMMERCE.CO.UK', 'FASTER REPLIES'))), 
		'20-MAR-2020');	   
SELECT sponsor_id FROM sponsors WHERE sponsor_firstname = 'TEST5';

DELETE FROM sponsors WHERE sponsor_id = 12; 
-- safe to delete: 1 row deleted.
DELETE FROM sponsors WHERE sponsor_id = 2; 
-- cannot delete: You cannot delete this sponsor as it has dependencies.
SELECT sponsor_id FROM sponsors;
-- displays all, including 2, as it has not been deleted.
-----------------------------------------------------------



-- trig_schema_delete - prints message on user drops
-- To find the schema
-- SELECT username AS schema_name
-- FROM sys.all_users
-- ORDER BY username;


CREATE OR REPLACE TRIGGER trig_schema_delete
AFTER DROP 
ON CSY2038_152.SCHEMA

BEGIN


  DBMS_OUTPUT.PUT_LINE('DROP COMPLETED!');
END trig_schema_delete;
/
SHOW ERRORS

-- Testing test_script_38
CREATE TABLE test_trig_drops (td_id NUMBER(10));
DROP TABLE test_trig_drops;

-----------------------------------------------------------


-- trig_db_hello - prints messages to user upon login, database level
CREATE OR REPLACE TRIGGER trig_db_hello
AFTER LOGON 
ON DATABASE

BEGIN
  DBMS_OUTPUT.PUT_LINE('HELLO, STUDENT!');
END trig_db_hello;
/
SHOW ERRORS
-- Testing - test_script_39
-- insufficient privileges
SELECT * FROM global_name; -- STUDENT.NENE.AC.UK

-----------------------------------------------------------


-- trig_user_log - records user log in date
CREATE OR REPLACE TRIGGER trig_user_log
AFTER LOGON
ON CSY2038_152.SCHEMA 

BEGIN
    INSERT INTO userlog
    VALUES (seq_userlog.nextval, SYSDATE);

END trig_db_hello;
/
SHOW ERRORS
-- Testing - test_script_40
-- Log out and log in
DISCONNECT
CONNECT
CSY2038_152@student/18408400
SELECT * FROM userlog ORDER BY entry_id ASC;
-- 03-APR-20
-----------------------------------------------------------



-- COMMIT CHANGES
COMMIT;




-- Testing - test_script_41
-- 10 triggers -- only 9 displayed, as one is db level example
-- SELECT trigger_name, trigger_type FROM user_triggers;
SELECT trigger_name FROM user_triggers;

