/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\create.sql
-- @/Users/Laura/csy2038/DB-AS2/create.sql

-- CREATE TYPES
-- contact_type
CREATE OR REPLACE TYPE contact_type AS OBJECT (
    contact_form VARCHAR2(20),
    details VARCHAR2(100),
    comments VARCHAR2(100));
/
SHOW ERRORS;

-- contact_varray_type
CREATE OR REPLACE TYPE contact_varray_type AS VARRAY(10) OF contact_type;
/

-- date_varray_type
CREATE OR REPLACE TYPE date_varray_type AS VARRAY(2) OF DATE;
/
SHOW ERRORS;

-- activity_type
CREATE OR REPLACE TYPE activity_type AS OBJECT (
    activity_name VARCHAR2(30),
    no_staff_needed NUMBER(6),
    activity_date date_varray_type);
/
SHOW ERRORS;

CREATE OR REPLACE TYPE activity_table_type AS TABLE OF activity_type;
/
SHOW ERRORS;

-- address_type
CREATE OR REPLACE TYPE address_type AS OBJECT (
    house_no VARCHAR2(30),
    street VARCHAR2(30),
    city VARCHAR2(30),
    county VARCHAR2(30),
    postcode VARCHAR2(10),
    country VARCHAR2(30));
/
SHOW ERRORS;

-- CREATE TABLES
CREATE TABLE sponsors (
    sponsor_id NUMBER(6),
    sponsor_firstname VARCHAR2(30),
    sponsor_surname VARCHAR2(30) NOT NULL,
    company_name VARCHAR2(60),
    address address_type,
    contact contact_varray_type,
    registration_date DATE);

CREATE TABLE addresses OF address_type;

CREATE TABLE locations (
    location_id NUMBER(6),
    address REF address_type SCOPE IS addresses,
    description VARCHAR2(200));

CREATE TABLE experience_nature (
    experience_nature_id NUMBER(6),
    experience_nature_name VARCHAR2(30) NOT NULL,
    description VARCHAR2(200));

CREATE TABLE experiences (
    experience_id NUMBER(6),
    experience_nature_id NUMBER(6) NOT NULL,
    experience_name VARCHAR2(30) NOT NULL,
    season VARCHAR2(20),
    experience_date date_varray_type,
    location_id NUMBER(6) NOT NULL,
    description VARCHAR2(200),
    activities activity_table_type)
    NESTED TABLE activities STORE AS activities_table;

CREATE TABLE tickets (
    ticket_number NUMBER(6),
    experience_id NUMBER(6),
    sponsor_id NUMBER(6),
    price NUMBER(9,2),
    date_sold DATE);



CREATE TABLE userlog (
    entry_id NUMBER (10),
    reg_date DATE);


-- CREATE SEQUENCES
-- seq_sponsors
CREATE SEQUENCE seq_sponsors
INCREMENT BY 1
START WITH 1;

-- seq_location
CREATE SEQUENCE seq_locations
INCREMENT BY 1
START WITH 1;

-- seq_experience_nature
CREATE SEQUENCE seq_experience_nature
INCREMENT BY 1
START WITH 1;

-- seq_experiences
CREATE SEQUENCE seq_experiences
INCREMENT BY 1
START WITH 1;

-- seq_tickets
CREATE SEQUENCE seq_tickets
INCREMENT BY 1
START WITH 1;

-- seq_userlog
CREATE SEQUENCE seq_userlog
INCREMENT BY 1
START WITH 1;


-- COMMIT CHANGES
COMMIT;


-- Testing "test_script_1"
SELECT OBJECT_NAME, OBJECT_TYPE 
    FROM USER_OBJECTS;
-- returns all created objects

SELECT sequence_name FROM user_sequences;
-- returns 6 sequences

SELECT table_name from user_tables;
-- returns 6 tables

DESC tickets;
DESC sponsors;
DESC locations;
DESC addresses;
DESC experiences;
DESC experience_nature;
-- describe all tables;


DESC contact_type;
DESC contact_varray_type;
DESC date_varray_type;
DESC activity_type;
DESC activity_table_type;
DESC address_type;
-- describe all types