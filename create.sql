/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (), Laura Ghiorghisor ()
*/

-- @C:\DB-AS2\create.sql

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
-- date_type
CREATE OR REPLACE TYPE date_varray_type AS VARRAY(5) OF DATE;
/
SHOW ERRORS;

-- activity_type
CREATE OR REPLACE TYPE activity_type AS OBJECT (
    activity_name VARCHAR2(30),
    cost NUMBER(20,2),
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
    activites activity_table_type)
    NESTED TABLE activites STORE AS activities_table;

CREATE TABLE tickets (
<<<<<<< HEAD
    ticket_id NUMBER(6),
    experience_id NUMBER(6),
    sponsor_id NUMBER(6),
    ticket_date date_varray_type,
=======
    experience_id NUMBER(6),
    sponsor_id NUMBER(6),
    ticket_number NUMBER(6),
    start_date DATE,
    end_date DATE,
>>>>>>> 1951ea120e1b34af77ad50e8ddce64c47fc853a9
    price NUMBER(6,2));



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


-- COMMIT CHANGES
COMMIT;
