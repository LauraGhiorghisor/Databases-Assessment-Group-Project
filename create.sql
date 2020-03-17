/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (), Laura Ghiorghisor ()
*/

-- @C:\DB-AS2\create.sql

SET SERVEROUTPUT ON;

-- CREATE TYPES
-- contact_type
CREATE OR REPLACE TYPE contact_type AS OBJECT (
    source VARCHAR2(20),
    description VARCHAR2(100),
    additional_details VARCHAR2(100));
/

-- contact_varray_type
CREATE OR REPLACE TYPE contact_varray_type AS VARRAY(4) OF contact_type;
/

-- activity_type
CREATE OR REPLACE TYPE activity_type AS OBJECT (
    activity_name VARCHAR2(30),
    cost NUMBER(6,2),
    staff_needed VARCHAR2(200),
    start_date DATE,
    end_date DATE);
/
SHOW ERRORS;

CREATE OR REPLACE TYPE activity_table_type AS TABLE OF activity_type;
/
SHOW ERRORS;

-- address_type
CREATE OR REPLACE TYPE address_type AS OBJECT (
    line1 VARCHAR2(50),
    line2 VARCHAR2(70),
    street VARCHAR2(30),
    city VARCHAR2(25),
    county VARCHAR2(30),
    postcode VARCHAR2(8),
    country VARCHAR2(20));
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
    registration_date DATE,
    description VARCHAR2(200));

CREATE TABLE locations (
    location_id NUMBER(6),
    address address_type NOT NULL,
    additional_notes VARCHAR2(200));

CREATE TABLE experience_nature (
    experience_nature_id NUMBER(6),
    experience_nature_name VARCHAR2(30) NOT NULL,
    comments VARCHAR2(200));

CREATE TABLE experiences (
    experience_id NUMBER(6),
    experience_nature_id NUMBER(6) NOT NULL,
    experience_name VARCHAR2(30) NOT NULL,
    season VARCHAR2(20),
    experience_date DATE,
    location_id NUMBER(6) NOT NULL,
    description VARCHAR2(200),
    activites activity_table_type)
    NESTED TABLE activites STORE AS activity_table;

CREATE TABLE tickets (
    ticket_id NUMBER(6),
    experience_id NUMBER(6) NOT NULL,
    sponsor_id NUMBER(6) NOT NULL,
    start_date DATE,
    end_date DATE,
    price NUMBER(6,2));

-- CREATE SEQUENCES
-- seq_sponsors
CREATE SEQUENCE seq_sponsors
INCREMENT BY 1
START WITH 000001;

-- seq_location
CREATE SEQUENCE seq_locations
INCREMENT BY 1
START WITH 000001;

-- seq_experience_nature
CREATE SEQUENCE seq_experience_nature
INCREMENT BY 1
START WITH 000001;

-- seq_experiences
CREATE SEQUENCE seq_experiences
INCREMENT BY 1
START WITH 000001;

-- seq_tickets
CREATE SEQUENCE seq_tickets
INCREMENT BY 1
START WITH 000001;

-- COMMIT CHANGES
COMMIT;