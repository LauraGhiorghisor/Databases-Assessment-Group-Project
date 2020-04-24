/*
* CSY2038 Databases 2 - Assignment 2 - CREATE.SQL
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\create.sql
-- @/Users/Laura/csy2038/DB-AS2/create.sql
-- @C:\Users\Daiana\DB-AS2\create.txt

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
SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS;
SELECT OBJECT_NAME FROM USER_OBJECTS;
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






/*
* CSY2038 Databases 2 - Assignment 2 - ALTER.SQL
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\alter.sql
-- @/Users/Laura/csy2038/DB-AS2/alter.sql
-- @C:\Users\Daiana\DB-AS2\alter.txt


-- PRIMARY KEYS
-- pk_sponsors
ALTER TABLE sponsors
ADD CONSTRAINT pk_sponsors
PRIMARY KEY (sponsor_id);

-- pk_location
ALTER TABLE locations
ADD CONSTRAINT pk_locations
PRIMARY KEY (location_id);

-- pk_experience_nature
ALTER TABLE experience_nature
ADD CONSTRAINT pk_experience_nature
PRIMARY KEY (experience_nature_id);

-- pk_experiences
ALTER TABLE experiences
ADD CONSTRAINT pk_experiences
PRIMARY KEY (experience_id);

-- pk_tickets
ALTER TABLE tickets
ADD CONSTRAINT pk_tickets
PRIMARY KEY (ticket_number, sponsor_id, experience_id);

--pk_userlog
ALTER TABLE userlog
ADD CONSTRAINT pk_userlog
PRIMARY KEY (entry_id);


-- FOREIGN KEYS
-- fk_e_experience_nature
ALTER TABLE experiences
ADD CONSTRAINT fk_e_experience_nature
FOREIGN KEY (experience_nature_id)
REFERENCES experience_nature(experience_nature_id);

-- fk_e_location
ALTER TABLE experiences
ADD CONSTRAINT fk_e_locations
FOREIGN KEY (location_id)
REFERENCES locations(location_id);

-- fk_t_experiences
ALTER TABLE tickets
ADD CONSTRAINT fk_t_experiences
FOREIGN KEY (experience_id)
REFERENCES experiences(experience_id);

-- fk_t_sponsors
ALTER TABLE tickets
ADD CONSTRAINT fk_t_sponsors
FOREIGN KEY (sponsor_id)
REFERENCES sponsors(sponsor_id);

-- CHECK, UNIQUE and DEFAULT CONSTRAINTS
-- sponsors

ALTER TABLE sponsors
ADD CONSTRAINT ck_sponsor_surname
CHECK (sponsor_surname = UPPER(sponsor_surname));

ALTER TABLE sponsors
ADD CONSTRAINT ck_company_name
CHECK (company_name = UPPER(company_name));

ALTER TABLE experiences
ADD CONSTRAINT ck_season
CHECK (season IN ('WINTER', 'SPRING', 'SUMMER', 'AUTUMN'));

ALTER TABLE tickets
ADD CONSTRAINT ck_price
CHECK (price BETWEEN 0 AND 9999999.00);

ALTER TABLE sponsors
MODIFY registration_date DEFAULT SYSDATE;

ALTER TABLE addresses
MODIFY country DEFAULT 'UK';

ALTER TABLE experience_nature
ADD CONSTRAINT uq_xp_nature_name
UNIQUE (experience_nature_name);


-- COMMIT CHANGES
COMMIT;

-- Testing "test_script_2"
-- DESC user_constraints;
-- SELECT constraint_name NAME, constraint_type T FROM user_constraints;
DESC user_constraints;
SELECT constraint_name NAME FROM user_constraints;
-- Displays all constraints: 22 rows

SELECT constraint_name FROM user_constraints WHERE constraint_name LIKE 'PK%';
-- displays all primary key constraints: 6 rows

SELECT constraint_name FROM user_constraints WHERE constraint_name LIKE 'FK%';
-- displays all foreign key constraints: 4 rows

SELECT constraint_name FROM user_constraints WHERE constraint_name LIKE 'CK%';
-- displays all check constraints: 4 rows

SELECT constraint_name FROM user_constraints WHERE constraint_name LIKE 'UQ%';
-- displays all check constraints: 1 row

SELECT constraint_name FROM user_constraints WHERE constraint_name LIKE 'UQ%' OR constraint_name LIKE 'CK%' OR constraint_name LIKE 'PK%' OR constraint_name LIKE 'FK%';
-- displays all constraints defined in the alter script: 15 rows







/*
* CSY2038 Databases 2 - Assignment 2 - INSERT.SQL
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\insert.sql
-- @/Users/Laura/csy2038/DB-AS2/insert.sql
-- @C:\Users\Daiana\DB-AS2\insert.txt


-- Inserts

--Addresses TABLE
INSERT INTO addresses(house_no, street, city, county, postcode, country)
VALUES('17 ALPHA HOUSE', 'ANDERSON STREET', 'ABERDEEN', 'ABERDEENSHIRE', 'AB33 7LG', 'SCOTLAND');

INSERT INTO addresses(house_no, street, city, county, postcode, country)
VALUES('26 ALWOOD BUILDING', 'BENJAMIN STREET', 'BATH', 'SOMERSET', 'BA3 7TY', 'UK');

INSERT INTO addresses(house_no, street, city, county, postcode, country)
VALUES('33', 'CECIL STREET', 'CAMBRIDGE', 'CAMBRIDGESHIRE', 'CB5 7YH', 'UK');

-- Default country
INSERT INTO addresses(house_no, street, city, county, postcode)
VALUES('48 DARBY HOUSE', 'DOLBY STREET', 'DERBY', 'DERBYSHIRE', 'DE1 2AW');

-- No column specification
INSERT INTO addresses
VALUES('52', 'ELMWOOD STREET', 'ELY', 'CAMBRIDGESHIRE', 'CB6 7JK', 'UK');


--Experience_nature TABLE
INSERT INTO experience_nature(experience_nature_id, experience_nature_name, description)
VALUES(seq_experience_nature.nextval, 'ADVENTURE', 'INCLUDES SKY-DIVING, HELICOPTER RIDES, F1, MOUNTAIN CLIMBING');

INSERT INTO experience_nature(experience_nature_id, experience_nature_name, description)
VALUES(seq_experience_nature.nextval, 'RELAXING', 'INCLUDES YOGA, MEDITATION SESSIONS, FOREST MOVIE NIGHTS, POOL');

INSERT INTO experience_nature(experience_nature_id, experience_nature_name, description)
VALUES(seq_experience_nature.nextval, 'FOOD', 'FINE DINING - 200 SEATS, FOOD STALLS - 24 - ASIAN, BRITISH, INDIAN FOOD, WAFFLES, CANDY');

INSERT INTO experience_nature(experience_nature_id, experience_nature_name, description)
VALUES(seq_experience_nature.nextval, 'DRINK', 'HELICOPTER RIDE WITH CHAMPAGNE (MULTIPLE CHOICES), POOL HIRE WITH CANDLES AND PROSECCO, WINE AND PAINT');

-- No column specification
INSERT INTO experience_nature
VALUES(seq_experience_nature.nextval, 'KIDS-WORLD', 'THEMED PARK, CLOWNS, FANTASY CHARACTERS, DISCOUNT FOR MEALS');


--Sponsors TABLE
INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname, company_name, address, contact, registration_date)
VALUES(seq_sponsors.nextval, UPPER('ANDREW'), UPPER('ADAMS'), UPPER('APPLEWOOD LTD'), 
       address_type('34', 'COPPER STREET', 'CAMBRIDGE', 'CAMBRIDGESHIRE', 'CB2 5EE', 'UK'),
	   contact_varray_type(
	                      (contact_type('FACEBOOK', 'APPLEWOOD LTD CAMBRIDGE', 'MESSAGE ONLY M-F 8-5')),
                          (contact_type('COMPANY PHONE', '01604786332', 'ONLY M-F 8-5')),
						  (contact_type('EMAIL', 'CONTACT@APPLEWOOD.CO.UK', NULL))), '20-MAY-1997');
-- Same address
INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname, company_name, address, contact, registration_date)
VALUES(seq_sponsors.nextval, UPPER('John'), UPPER('Wood'), UPPER('WOODY LTD'), 
       address_type('34', 'COPPER STREET', 'CAMBRIDGE', 'CAMBRIDGESHIRE', 'CB2 5EE', 'UK'),
	   contact_varray_type(
	                      (contact_type('FACEBOOK', 'WOODY LTD CAMBRIDGE', 'MESSAGE ONLY M-F 8-5')),
                          (contact_type('COMPANY PHONE', '01604336332', 'ONLY M-F 8-5')),
						  (contact_type('EMAIL', 'CONTACT@WOODY.CO.UK', NULL))), '20-MAY-1999');
	   
INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname, company_name, address, contact, registration_date)
VALUES(seq_sponsors.nextval, 'BENJAMIN', 'BROOKLYN', 'BONFIT LTD', 
       address_type('88', 'BOND STREET', 'BATH', 'SOMERSET', 'BA6 7RE', 'UK'),
	   contact_varray_type(
	                      (contact_type('FACEBOOK', 'BONFIT LTD UK', NULL)),
                          (contact_type('INSTAGRAM', 'BONFITUK', 'NOT USED MUCH')),
						  (contact_type('EMAIL', 'CONTACT@APPLEWOOD.CO.UK', 'FASTER REPLIES'))), '10-DEC-1984');
	   
INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname, company_name, address, contact, registration_date)
VALUES(seq_sponsors.nextval, 'CHAD', 'CROWLEY', 'CHIMNEY SWEEP', 
       address_type('887 CLAYTON HOUSE', 'CLAYTON STREET', 'CRANFIELD', 'BEDFORDSHIRE', 'BE15 7EG', 'UK'),
	   contact_varray_type(
	                      (contact_type('FACEBOOK', 'CHIMNEY SWEEP BEDFORD', NULL)),
                          (contact_type('INSTAGRAM', 'CHIMSWEEPUK', NULL)),
						  (contact_type('TWITTER', 'CHIMSWEEPBED', 'MANY POSTS'))), '15-DEC-2001');	

-- Inserts default registration_date as SYSDATE
INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname, company_name, address, contact)
VALUES(seq_sponsors.nextval, 'DARREN', 'DOOLEY', 'DD', 
       address_type('828', 'DELAPRE STREET', 'DAVENTRY', 'NORTHAMPTONSHIRE', 'NN11 5TS', 'UK'),
	   contact_varray_type(
	                      (contact_type('FACEBOOK', 'DD IN DAVENTRY', NULL)),
                          (contact_type('INSTAGRAM', 'DDDAVENTRY', 'DAILY POSTS')),
						  (contact_type('EMAIL', 'DARREN@DDDAVENTRY.CO.UK', 'FASTER REPLIES IN THE EVENING'))));	  

-- No column specification: must provide registration_date
INSERT INTO sponsors
VALUES(seq_sponsors.nextval, 'ELY', 'EXETER', 'ECOMMERCE UK', 
       address_type('75', 'EASTER ROAD', 'KETTERING', 'NORTHAMPTONSHIRE', 'NN7 5EF', 'UK'),
	   contact_varray_type(
	                      (contact_type('FACEBOOK', 'ECOMMERCE UK', NULL)),
                          (contact_type('PERSONAL PHONE', '07534672889', 'CAN CALL EVEN AFTER 6 PM')),
						  (contact_type('EMAIL', 'ELY@ECOMMERCE.CO.UK', 'FASTER REPLIES'))), 
		'20-MAR-2020');	   



--Locations TABLE

-- using update
INSERT INTO locations(location_id, description)
VALUES(seq_locations.nextval, 'IDEAL FOR CHILDREN AGED 1-16, PLENTY OF WATER FOUNTAINS, GAMES, RESTAURANTS');

UPDATE locations SET address = 
(SELECT REF(a) FROM addresses a
WHERE a.street = 'ANDERSON STREET')
WHERE location_id = 1;

INSERT INTO locations(location_id, description)
VALUES(seq_locations.nextval, 'HELICOPTER AND SKY DIVING LEAVING POINT');

UPDATE locations SET address = 
(SELECT REF(a) FROM addresses a
WHERE a.street = 'BENJAMIN STREET')
WHERE location_id = 2;


-- using regular insert
INSERT INTO locations(location_id, description, address)
SELECT seq_locations.nextval, 'HOTEL WITH SPA, POOL, SAUNA, 5 STARS', REF(a)
FROM addresses a
WHERE a.street = 'CECIL STREET';

-- Same city
INSERT INTO locations(location_id, description, address)
SELECT seq_locations.nextval, 'HOTEL WITH SPA, POOL, SAUNA AND BEAUTY CENTER, 5 STARS', REF(a)
FROM addresses a
WHERE a.city = 'BATH';

INSERT INTO locations(location_id, description, address)
SELECT seq_locations.nextval, 'A LA CARTE RESTAURANT, VARIOUS CHOICES. PLENTY OF PARKING', REF(a)
FROM addresses a
WHERE a.street = 'DOLBY STREET';

INSERT INTO locations(location_id, description, address)
SELECT seq_locations.nextval, 'LOCATION HAS WINE CELLAR, BAR WITH MULTIPLE SPIRITS AND SNACKS', REF(a)
FROM addresses a
WHERE a.street = 'ELMWOOD STREET';



--Experiences Table
INSERT INTO experiences(experience_id, experience_nature_id, experience_name, season, experience_date, location_id, description, activities)
VALUES(seq_experiences.nextval, 1, 'LUXURY DINNER FOR 4', 'AUTUMN', date_varray_type('16-NOV-2019', '17-NOV-2019'), 1, 'OFFER DISCOUNT FOR PURCHASES ON OVER 500 POUNDS', 
activity_table_type(
                    activity_type('ROMANTIC DINNER', 3, date_varray_type('16-NOV-2020', '16-NOV-2020')),
					activity_type('AFTERNOON TEA', 3, date_varray_type('17-NOV-2020', '17-NOV-2020')))
	  );
	  
INSERT INTO experiences(experience_id, experience_nature_id, experience_name, season, experience_date, location_id, description, activities)
VALUES(seq_experiences.nextval, 2, 'COMEDY NIGHT', 'WINTER', date_varray_type('01-NOV-2019', '01-NOV-2019'), 2, NULL, 
activity_table_type(
					activity_type('COMEDY SHOW', 0, date_varray_type('01-NOV-2019', '01-NOV-2019')),
                    activity_type('PHOTOS WITH THE ARTIST', 3, date_varray_type('01-NOV-2019', '01-NOV-2019')),
					activity_type('MEAL AND DRINKS', 3, date_varray_type('01-NOV-2019', '01-NOV-2019')))
	  );	  
	  
INSERT INTO experiences(experience_id, experience_nature_id, experience_name, season, experience_date, location_id, description, activities)
VALUES(seq_experiences.nextval, 3, 'HELICOPTER RIDE', 'SPRING', date_varray_type('01-MAY-2020', '02-MAY-2020'), 3, 'MAX OF 2 PEOPLE PLUS STAFF,  PHOTOS INCLUDED', 
activity_table_type(
                    activity_type('PHOTOSHOOT', 1, date_varray_type('01-MAY-2020', '01-MAY-2020')),
					activity_type('RIDE', 1, date_varray_type('02-MAY-2020', '02-MAY-2020')))
	  );

INSERT INTO experiences(experience_id, experience_nature_id, experience_name, season, experience_date, location_id, description, activities)
VALUES(seq_experiences.nextval, 4, 'AFTERNOON TEA', 'WINTER', date_varray_type('01-JAN-2020', '01-JAN-2020'), 4, 'GLUTEN FREE, VEGAN, SUGAR FREE ALSO', 
activity_table_type(
                    activity_type('DRINKS', 1, date_varray_type('01-JAN-2020', '01-JAN-2020')),
					activity_type('MEALS', 3, date_varray_type('01-JAN-2020', '01-JAN-2020')))
	  );
-- No column specification.
INSERT INTO experiences
VALUES(seq_experiences.nextval, 5, 'BAKING', 'SPRING', date_varray_type('01-MAR-2020', '13-MAR-2020'), 5, 'GLUTEN FREE, VEGAN, SUGAR FREE ALSO. HEALTH AND SAFETY TRAINING', 
activity_table_type(
                    activity_type('TRAINING', 1, date_varray_type('01-MAR-2020', '10-MAR-2020')),
					activity_type('BRING A FRIEND', 0, date_varray_type('11-MAR-2020', '12-MAR-2020')),
					activity_type('FINAL BAKEOFF', 0, date_varray_type('13-MAR-2020', '13-MAR-2020')))
	  );
-- Same location
-- No column specification.
INSERT INTO experiences
VALUES(seq_experiences.nextval, 5, 'GIRLS'' DETOX WEEK', 'SUMMER', date_varray_type('01-JUL-2020', '08-JUL-2020'), 2, 'FULL GIRL''S WEEK OF DETOX', 
activity_table_type(
                    activity_type('INDUCTION', 6, date_varray_type('01-JUL-2020', '01-JUL-2020')),
					activity_type('BATH IN BATH', 2, date_varray_type('02-JUL-2020', '02-JUL-2020')),
					activity_type('PHYSICAL TRAINING', 5, date_varray_type('03-JUL-2020', '05-JUL-2020')),
					activity_type('NUTRITION COURSE', 4, date_varray_type('06-JUL-2020', '06-JUL-2020')),
					activity_type('SPA DAY', 0, date_varray_type('03-JUL-2020', '05-JUL-2020')))
	  );
	  
--Tickets TABLE

/* The assumption is that tickets may be sold with different tier prices, 
not specified in the current schema. The ticket_number distinguishes between such entries.
*/
INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 1, 1, 1000.00, '23-MAR-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 1, 1, 1000.00, '23-MAR-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 1, 1, 1200.00, '23-MAR-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 2, 2, 550.00, '13-FEB-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 3, 3, 2000.00, '06-JAN-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 3, 3, 2000.00, '27-FEB-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 4, 4, 45.00, '14-FEB-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 5, 5, 80.00, '16-JAN-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 2, 1, 550.00, '13-FEB-2020');



-- Testing inserts "test_script_3"
SELECT * FROM addresses;
SELECT * FROM experience_nature;
SELECT * FROM sponsors;
SELECT * FROM locations;
SELECT * FROM experiences;
SELECT * FROM tickets;



-- Testing constraints "test_script_4"

-- PK constraint
INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price)
VALUES(1, 1, 1, 160.00);
-- unique constraint (CSY2038_152.PK_TICKETS) violated

-- PK constraint
INSERT INTO experience_nature(experience_nature_id, experience_nature_name, description)
VALUES(1, 'ADVENTURE', 'INCLUDES SKY-DIVING, HELICOPTER RIDES, F1, MOUNTAIN CLIMBING');
-- unique constraint (CSY2038_152.PK_EXPERIENCE_NATURE) violated

-- CK constraint
INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname, company_name)
VALUES(seq_sponsors.nextval, 'ANDREW', 'adams', 'APPLEWOOD LTD');
-- check constraint (CSY2038_152.CK_SPONSOR_SURNAME) violated

-- CK constraint
INSERT INTO sponsors(sponsor_id, sponsor_firstname, sponsor_surname, company_name)
VALUES(seq_sponsors.nextval, 'ANDREW', 'ADAMS', 'applewood LTD');
-- check constraint (CSY2038_152.CK_COMPANY_NAME) violated

-- DEFAULT constraint
SELECT sponsor_id, registration_date FROM sponsors WHERE sponsor_id = 5;
--  20-MAR-20 (at the time of testing) / current date


-- Must disable trigger to insert (to allow for testing at any hour), if testing done at a later stage
ALTER TRIGGER trig_security DISABLE;
-- NOT NULL
INSERT INTO experiences (experience_id, experience_nature_id, experience_name, season)
VALUES(seq_experiences.nextval, 5, 'BAKING', 'NOT A SEASON');
--  cannot insert NULL into ("CSY2038_152"."EXPERIENCES"."LOCATION_ID")

-- IN - season
INSERT INTO experiences(experience_id, experience_nature_id, experience_name, season, experience_date, location_id, description, activities)
VALUES(seq_experiences.nextval, 1, 'LUXURY DINNER FOR 4', 'NOT A SEASON', date_varray_type('16-NOV-2019', '17-NOV-2019'), 1, 'OFFER DISCOUNT FOR PURCHASES ON OVER 500 POUNDS', 
activity_table_type(
                    activity_type('ROMANTIC DINNER', 3, date_varray_type('16-NOV-2020', '16-NOV-2020')),
					activity_type('AFTERNOON TEA', 3, date_varray_type('17-NOV-2020', '17-NOV-2020')))
	  );
--  check constraint (CSY2038_152.CK_SEASON) violated

-- re-enable trigger
ALTER TRIGGER trig_security ENABLE;


-- BETWEEN - price
INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price)
VALUES(seq_tickets.nextval, 4, 4, -45.00);
--  check constraint (CSY2038_152.CK_PRICE) violated
INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price)
VALUES(seq_tickets.nextval, 4, 4, 9999999.01);
-- check constraint (CSY2038_152.CK_PRICE) violated

-- COMMIT CHANGES
COMMIT;





/*
* CSY2038 Databases 2 - Assignment 2 - QUERY.SQL
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\query.sql
-- @/Users/Laura/csy2038/DB-AS2/query.sql
-- @C:\Users\Daiana\DB-AS2\query.txt

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
			 





			 
/*
* CSY2038 Databases 2 - Assignment 2 - FUNCTIONS.SQL
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\functions.sql
-- @/Users/Laura/csy2038/DB-AS2/functions.sql
-- @C:\Users\Daiana\Desktop\functions.txt
-- @C:\Users\Daiana\DB-AS2\functions.txt


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

	DBMS_OUTPUT.PUT_LINE ('Duration is ' || func_duration('01-JAN-1991', '02-JAN-1991'));

END proc_test_duration;
/
SHOW ERRORS
-- Testing "test_script_8"
EXECUTE proc_test_duration
-- Duration is 1



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
			 
			 





/*
* CSY2038 Databases 2 - Assignment 2 - PROCEDURES.SQL
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\procedures.sql
-- @/Users/Laura/csy2038/DB-AS2/procedures.sql
-- @C:\Users\Daiana\DB-AS2\procedures.txt

SET SERVEROUTPUT ON;


-- proc_print_sponsor_address - prints address in post format
CREATE OR REPLACE PROCEDURE proc_print_sponsor_address (in_sponsor_id sponsors.sponsor_id%TYPE) IS
    CURSOR cur_address IS
    SELECT sponsor_firstname, sponsor_surname, address
    FROM sponsors
    WHERE sponsor_id = in_sponsor_id;

    vc_sponsor_name VARCHAR2(61);

   rec_cur_address cur_address%ROWTYPE;
BEGIN
    -- Fetch the sponsor name and store it in vc_sponsor_name.
    vc_sponsor_name := func_sponsor_name(in_sponsor_id);

    OPEN cur_address;
    FETCH cur_address INTO rec_cur_address;

    -- Print the address in standard address format.
    DBMS_OUTPUT.PUT_LINE(INITCAP(vc_sponsor_name));
    DBMS_OUTPUT.PUT_LINE(INITCAP(rec_cur_address.address.house_no || ' ' ||rec_cur_address.address.street));
    DBMS_OUTPUT.PUT_LINE(INITCAP(rec_cur_address.address.city));
    DBMS_OUTPUT.PUT_LINE(INITCAP(rec_cur_address.address.county));
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.postcode);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.country || chr(10));

    CLOSE cur_address;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('A sponsor with an ID of ' || in_sponsor_id || ' does not exist.');    
END proc_print_sponsor_address;
/
SHOW ERRORS;


-- Run test_script_18
EXECUTE proc_print_sponsor_address(1);
/*
Andrew Adams
34 Copper Street
Cambridge
Cambridgeshire
CB2 5EE
UK

*/


-- proc_xp_sponsors - prints all sponsors for a given experience
CREATE OR REPLACE PROCEDURE proc_xp_sponsors (in_xp_id experiences.experience_id%TYPE) IS
    CURSOR cur_sponsors IS
    SELECT e.experience_id, s.sponsor_id, s.sponsor_surname, s.sponsor_firstname
    FROM experiences e
    JOIN tickets t
    ON e.experience_id = t.experience_id
    JOIN sponsors s
    ON s.sponsor_id = t.sponsor_id
    WHERE e.experience_id = in_xp_id;

    vc_experience_name experiences.experience_name%TYPE;
    vc_sponsor_name VARCHAR2(60);
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- List all sponsors for the given experience.
    DBMS_OUTPUT.PUT_LINE('=== SPONSORS FOR EXPERIENCE: "' || vc_experience_name || '" ===');
    FOR rec_cur_sponsors IN cur_sponsors LOOP   
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_cur_sponsors.sponsor_id || ' | NAME: ' ||  rec_cur_sponsors.sponsor_surname || ', ' || rec_cur_sponsors.sponsor_firstname);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_xp_sponsors;
/
SHOW ERRORS;
-- Run test_script_19
EXECUTE proc_xp_sponsors(2);
/*
=== SPONSORS FOR EXPERIENCE: "COMEDY NIGHT" ===
ID: 2 | NAME: WOOD, JOHN
ID: 1 | NAME: ADAMS, ANDREW
*/




-- proc_find_sponsor_by_address - returns all sponsors whose address includes the given string
CREATE OR REPLACE PROCEDURE proc_find_sponsor_by_address (in_search_string VARCHAR2) IS
    CURSOR cur_sponsor_addresses IS
    SELECT sponsor_id, address
    FROM sponsors;

    vc_current_address VARCHAR2(200);

    rec_cur_sponsor_addresses cur_sponsor_addresses%ROWTYPE;
BEGIN
    -- List all sponsors with their address based off the search string provided.
    DBMS_OUTPUT.PUT_LINE('=== Sponsors with an address containing the string "' || in_search_string || '" ===');
    OPEN cur_sponsor_addresses;
    FETCH cur_sponsor_addresses INTO rec_cur_sponsor_addresses;

    -- Loop through all sponsors.
    WHILE cur_sponsor_addresses%FOUND LOOP
        vc_current_address := rec_cur_sponsor_addresses.address.house_no || ' ' || rec_cur_sponsor_addresses.address.street || ', ' || rec_cur_sponsor_addresses.address.city || ', ' || rec_cur_sponsor_addresses.address.county || ', ' || rec_cur_sponsor_addresses.address.postcode || ', ' || rec_cur_sponsor_addresses.address.country;

        -- Check if the string in vc_current_address contains the search string as a substring.
        IF INSTR(LOWER(vc_current_address), LOWER(TRIM(in_search_string))) > 0 THEN

             DBMS_OUTPUT.PUT_LINE('Sponsor ID ' || rec_cur_sponsor_addresses.sponsor_id );
             proc_print_sponsor_address(rec_cur_sponsor_addresses.sponsor_id);
        END IF;

        FETCH cur_sponsor_addresses INTO rec_cur_sponsor_addresses;
    END LOOP;

    CLOSE cur_sponsor_addresses;
END proc_find_sponsor_by_address;
/
SHOW ERRORS;

-- Run test_script_20
EXECUTE proc_find_sponsor_by_address('COPPER');
/*
=== Sponsors with an address containing the string "COPPER" ===
Sponsor ID 1
Andrew Adams
34 Copper Street
Cambridge
Cambridgeshire
CB2 5EE
UK

Sponsor ID 2
John Wood
34 Copper Street
Cambridge
Cambridgeshire
CB2 5EE
UK
*/






-- proc_list_xp_activities - list all activities in a given experience
CREATE OR REPLACE PROCEDURE proc_list_xp_activities (in_xp_id experiences.experience_id%TYPE) IS
    CURSOR cur_experiences IS
    SELECT e.experience_name, a.activity_name, a.no_staff_needed
    FROM experiences e, TABLE(e.activities) a
    WHERE e.experience_id = in_xp_id;

    CURSOR cur_activities IS
    SELECT a.activity_name, d.column_value
    FROM experiences e, TABLE(e.activities) a, TABLE(a.activity_date) d
    WHERE e.experience_id = in_xp_id;

    TYPE datearray IS VARRAY(2) OF DATE;
    dates datearray;

    vc_experience_name experiences.experience_name%TYPE;
    vc_output_string VARCHAR2(200);
    vn_total NUMBER(3);
    rec_cur_activities cur_activities%ROWTYPE;
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);
    -- Fetch the number of activities for output.
    vn_total := func_get_no_activities(in_xp_id);

    -- Initialise array and set size to 2.
    dates := datearray();
    dates.extend(2);

    OPEN cur_activities;

    -- Display all activities belonging to the specified experience.
    DBMS_OUTPUT.PUT_LINE('=== There are ' || vn_total || ' activities in experience "' || vc_experience_name || '" ===');
    FOR rec_cur_experiences IN cur_experiences LOOP
        vc_output_string := CONCAT('Activity Name: ' || rec_cur_experiences.activity_name || ' | ', 'No. of Staff: ' || rec_cur_experiences.no_staff_needed);
        
        FETCH cur_activities INTO rec_cur_activities;
        vc_output_string := CONCAT(vc_output_string || ' | ', 'Start Date: ' || rec_cur_activities.column_value);
        FETCH cur_activities INTO rec_cur_activities;
        vc_output_string := CONCAT(vc_output_string || ' | ', 'End Date: ' || rec_cur_activities.column_value);
        
        DBMS_OUTPUT.PUT_LINE(vc_output_string);
    END LOOP;

    CLOSE cur_activities;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_list_xp_activities;
/
SHOW ERRORS;
--Run test_script_21
EXECUTE proc_list_xp_activities(1);
/*
=== There are 2 activities in experience "LUXURY DINNER FOR 4" ===
Activity Name: ROMANTIC DINNER | No. of Staff: 3 | Start Date: 16-NOV-20 | End
Date: 16-NOV-20
Activity Name: AFTERNOON TEA | No. of Staff: 3 | Start Date: 17-NOV-20 | End
Date: 17-NOV-20
*/




-- proc_calc_annual_takings - calculates takings per year, for a given experience
CREATE OR REPLACE PROCEDURE proc_calc_annual_takings (in_xp_id experiences.experience_id%TYPE, in_year VARCHAR2) IS
    vc_experience_name experiences.experience_name%TYPE;
    vd_date_sold DATE;
    vn_total NUMBER(6,2);

    no_tickets EXCEPTION;
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Calculate the annual takings and store it in vn_total.
    vn_total := func_annual_takings_total(in_xp_id, in_year);

    -- Display the amount made in the given year.
    IF vn_total IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Between 1st January ' || in_year || ' and 31st December ' || in_year || ', the experience "' || vc_experience_name || '" made GBP ' || vn_total || ' in sales.');
    ELSE
        RAISE no_tickets;
    END IF;
EXCEPTION
    WHEN no_tickets THEN
        DBMS_OUTPUT.PUT_LINE('No tickets were sold for experience "' || vc_experience_name || '" in ' || in_year || '.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_calc_annual_takings;
/
SHOW ERRORS;
-- Run test_script_22
EXECUTE proc_calc_annual_takings(1, '2020');
/*
Between 1st January 2020 and 31st December 2020, the experience "LUXURY DINNER
FOR 4" made GBP 3200 in sales.
*/




-- proc_lowest_price - calculates lowest average ticket price out of all experiences
CREATE OR REPLACE PROCEDURE proc_lowest_avg_price IS
    CURSOR cur_experiences IS
    SELECT e.experience_id, e.experience_name, t.price
    FROM experiences e
    JOIN tickets t
    ON e.experience_id = t.experience_id;

    no_tickets EXCEPTION;

    vn_experience_id experiences.experience_id%TYPE;
    vc_experience_name experiences.experience_name%TYPE;
    vn_avg NUMBER(20);
    vn_lowest_avg NUMBER(20);
BEGIN
    vn_avg := 0;
    vn_lowest_avg := 10000000;

    -- Loop through the tickets table and store the highest grossing total in vn_highest_total.
    FOR rec_cur_experiences IN cur_experiences LOOP
        vn_avg := func_xp_price_avg(rec_cur_experiences.experience_id);
        IF vn_avg < vn_lowest_avg THEN
            vn_experience_id := rec_cur_experiences.experience_id;
            vc_experience_name := rec_cur_experiences.experience_name;
            vn_lowest_avg := vn_avg;
        END IF;
    END LOOP;

    -- Display the highest grossing experience.
    IF vc_experience_name IS NOT NULL AND vn_lowest_avg != 10000000 THEN
        DBMS_OUTPUT.PUT_LINE('The lowest ticket price average was recorded for "' || vc_experience_name || '" and has made GBP ' || vn_lowest_avg || '.');
    ELSE
        RAISE no_tickets;
    END IF;
EXCEPTION
    WHEN no_tickets THEN
        DBMS_OUTPUT.PUT_LINE('No tickets have been sold.');
END proc_lowest_avg_price;
/
SHOW ERRORS;
-- Run test_script_23
EXECUTE proc_lowest_avg_price;
/*
The lowest ticket price average was recorded for "AFTERNOON TEA" and has made
GBP 45.
*/




-- proc_highest_grossing - calculates highest grossing experience overall
CREATE OR REPLACE PROCEDURE proc_highest_grossing IS
    CURSOR cur_experiences IS
    SELECT e.experience_id, e.experience_name, t.price
    FROM experiences e
    JOIN tickets t
    ON e.experience_id = t.experience_id;

    no_tickets EXCEPTION;

    vn_experience_id experiences.experience_id%TYPE;
    vc_experience_name experiences.experience_name%TYPE;
    vn_total NUMBER(20);
    vn_highest_total NUMBER(20);
BEGIN
    vn_total := 0;
    vn_highest_total := 0;

    -- Loop through the tickets table and store the highest grossing total in vn_highest_total.
    FOR rec_cur_experiences IN cur_experiences LOOP
        vn_total := func_takings_total(rec_cur_experiences.experience_id);
        IF vn_total > vn_highest_total THEN
            vn_experience_id := rec_cur_experiences.experience_id;
            vc_experience_name := rec_cur_experiences.experience_name;
            vn_highest_total := vn_total;
        END IF;
    END LOOP;

    -- Display the highest grossing experience.
    IF vc_experience_name IS NOT NULL AND vn_highest_total != 0 THEN
        DBMS_OUTPUT.PUT_LINE('The highest grossing experience is "' || vc_experience_name || '" and has made GBP ' || vn_highest_total || '.');
    ELSE
        RAISE no_tickets;
    END IF;
EXCEPTION
    WHEN no_tickets THEN
        DBMS_OUTPUT.PUT_LINE('No tickets have been sold.');
END proc_highest_grossing;
/
SHOW ERRORS;
-- Run test_script_24
EXECUTE proc_highest_grossing;
/*
The highest grossing experience is "HELICOPTER RIDE" and has made GBP 4000.
*/




-- proc_xp_duration - calculates the duration of an experience, in days
CREATE OR REPLACE PROCEDURE proc_xp_duration (in_xp_id experiences.experience_id%TYPE) IS
    CURSOR cur_duration IS
    SELECT d.*
    FROM experiences e, TABLE(e.experience_date) d
    WHERE e.experience_id = in_xp_id;

    vc_experience_name experiences.experience_name%TYPE;

    TYPE datearray IS VARRAY(2) OF DATE;
    dates datearray;

    rec_cur_duration cur_duration%ROWTYPE;
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Initialise array and set size to 2.
    dates := datearray();
    dates.extend(2);

    -- Open the cursor.
    OPEN cur_duration;

    -- Add dates for the given experience to the array.
    FOR i IN 1..dates.count LOOP
        FETCH cur_duration INTO rec_cur_duration;
        dates(i) := rec_cur_duration.column_value;
    END LOOP;

    -- Close the cursor.
    CLOSE cur_duration;

    -- Display the duration of the given experience.
    IF func_duration(dates(1), dates(2)) = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('The duration of experience "' || vc_experience_name || '" is 1 day.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('The duration of experience "' || vc_experience_name || '" is ' || (func_duration(dates(1), dates(2))+1) || ' days.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_xp_duration;
/
SHOW ERRORS;
-- Run test_script_25
EXECUTE proc_xp_duration(2);
/*
The duration of experience "COMEDY NIGHT" is 1 day.
*/




-- proc_staff_total - returns total number of staff required for an experience
CREATE OR REPLACE PROCEDURE proc_staff_total (in_xp_id experiences.experience_id%TYPE) IS
    vc_experience_name experiences.experience_name%TYPE;
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Display the amount of staff required for the given experience.
    DBMS_OUTPUT.PUT_LINE('The number of staff required for experience "' || vc_experience_name || '" is: ' || func_staff_total(in_xp_id));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_staff_total;
/
SHOW ERRORS;
-- Run test_script_26
EXECUTE proc_staff_total(2);
/* 
The number of staff required for experience "COMEDY NIGHT" is: 6
*/




-- proc_start_end_date - inserts the start and end date of an experience based on activities dates
CREATE OR REPLACE PROCEDURE proc_start_end_date (in_xp_id experiences.experience_id%TYPE) IS
    CURSOR cur_activity_dates IS
    SELECT d.column_value
    FROM experiences e, TABLE(e.activities) a, TABLE(a.activity_date) d
    WHERE e.experience_id = in_xp_id
    ORDER BY d.column_value ASC;
    
    vd_max_date DATE := '01-JAN-1900';
    vd_min_date DATE := '01-DEC-3000';

    date_null EXCEPTION;
    no_rows EXCEPTION;

    vc_experience_name experiences.experience_name%TYPE;
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Retrieve and store the min and max of the dates.
    FOR rec_cur_activity_dates IN cur_activity_dates LOOP
        IF rec_cur_activity_dates.column_value < vd_min_date THEN
            vd_min_date := rec_cur_activity_dates.column_value;
        END IF;
        IF rec_cur_activity_dates.column_value > vd_max_date THEN
            vd_max_date := rec_cur_activity_dates.column_value;
        END IF;
    END LOOP;

    -- Attempt to update the start and end date for the given experience.
    IF vd_min_date IS NOT NULL AND vd_max_date IS NOT NULL THEN
        UPDATE experiences
        SET experience_date = date_varray_type(vd_min_date, vd_max_date)
        WHERE experience_id = in_xp_id;
    ELSE
        RAISE date_null;
    END IF;

    -- Check if any rows were updated.
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('The start and end dates for the experience "' || vc_experience_name || '" have been updated successfully!');
    ELSE
        RAISE no_rows;
    END IF;
EXCEPTION
    WHEN no_rows THEN
        DBMS_OUTPUT.PUT_LINE('The start and end dates for the experience "' || vc_experience_name || '" could not be updated.');
    WHEN date_null THEN
        DBMS_OUTPUT.PUT_LINE('The start and end dates for the experience "' || vc_experience_name || '" could not be updated due to a null value.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_start_end_date;
/
SHOW ERRORS;
-- Test & run - test_script_27
UPDATE experiences
SET experience_date = date_varray_type('20-MAR-50', '23-JUN-44')
WHERE experience_id = 3;

SELECT experience_date FROM experiences WHERE experience_id = 3; 
-- Prints "DATE_VARRAY_TYPE('20-MAR-50', '23-JUN-44')".
EXECUTE proc_start_end_date (3);
SELECT experience_date FROM experiences WHERE experience_id = 3; 
/* 
PRINTS:
DATE_VARRAY_TYPE('01-MAY-20', '02-MAY-20')
*/




-- proc_print_experience_details - gives location and staff details for the given experience
CREATE OR REPLACE PROCEDURE proc_print_experience_details(in_xp_id experiences.experience_id%TYPE) IS

    vn_location_id NUMBER(30);
    vc_address VARCHAR2(500);

BEGIN
    -- Fetch the location ID and store it.
    SELECT location_id
    INTO vn_location_id
    FROM experiences 
    WHERE experience_id = in_xp_id;

    vc_address := func_print_location_address(vn_location_id);

    DBMS_OUTPUT.PUT_LINE (CHR(10) || 'The experience ' || func_xp_name(in_xp_id) || ' will be taking place at ' || vc_address || CHR(13) || 
    'Number of staff needed : ' || func_staff_total(in_xp_id) || CHR(10));
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
    END proc_print_experience_details;
/
SHOW ERRORS;

-- Run test_script_28
EXECUTE proc_print_experience_details(1);
/*
The experience LUXURY DINNER FOR 4 will be taking place at 
17 ALPHA HOUSE
ANDERSON STREET
ABERDEEN
ABERDEENSHIRE
SCOTLAND
Number of staff needed
: 6
*/




-- proc_xp_season  - inserts season in experiences based on date
CREATE OR REPLACE PROCEDURE proc_xp_season (in_xp_id experiences.experience_id%TYPE) IS
    CURSOR cur_duration IS
    SELECT d.*
    FROM experiences e, TABLE(e.experience_date) d
    WHERE e.experience_id = in_xp_id;

    vc_experience_name experiences.experience_name%TYPE;

    TYPE datearray IS VARRAY(2) OF DATE;
    dates datearray;

    rec_cur_duration cur_duration%ROWTYPE;

BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Initialise array and set size to 2.
    dates := datearray();
    dates.extend(2);

    -- Open the cursor.
    OPEN cur_duration;

    -- Add dates for the given experience to the array.
    FOR i IN 1..dates.count LOOP
        FETCH cur_duration INTO rec_cur_duration;
        dates(i) := rec_cur_duration.column_value;
    END LOOP;

    -- Close the cursor.
    CLOSE cur_duration;

    UPDATE experiences
    SET season = func_season(dates(1))
    WHERE experience_id = in_xp_id;


    -- Display success message.
        DBMS_OUTPUT.PUT_LINE('The season column for experience "' || vc_experience_name || '" has been inserted. ');

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');

END proc_xp_season;
/
SHOW ERRORS;
-- Run test_script_29
EXECUTE proc_xp_season(2);
-- The season column for experience "COMEDY NIGHT" has been inserted.
SELECT season FROM experiences WHERE experience_id = 2;
-- AUTUMN




-- COMMIT CHANGES
COMMIT;




-- === TESTS FOR PROCEDURES ===  test_script_30

-- Check creation -- 12 in total
SELECT object_name FROM user_procedures WHERE object_name LIKE 'PROC_%';


-- proc_print_sponsor_address
exec proc_print_sponsor_address; 
-- Prints "wrong number or type of arguments in call to 'PROC_PRINT_SPONSOR_ADDRESS'"
exec proc_print_sponsor_address('a'); 
-- Prints "numeric or value error: character to number conversion error"
exec proc_print_sponsor_address(6); 
-- Prints "An experience with an ID of 6 does not exist."
exec proc_print_sponsor_address(1); 
-- Prints the address for sponsor "Andrew Adams".

-- proc_xp_sponsors
exec proc_xp_sponsors; 
-- Prints "wrong number or type of arguments in call to 'PROC_XP_SPONSORS'"
exec proc_xp_sponsors('a'); 
-- Prints "numeric or value error: character to number conversion error"
exec proc_xp_sponsors(6); 
-- Prints "An experience with an ID of 6 does not exist."
exec proc_xp_sponsors(1); 
-- Prints a list of all the sponsors of the experience "LUXURY DINNER FOR 4".

-- proc_find_sponsor_by_address
exec proc_find_sponsor_by_address; 
-- Prints "wrong number or type of arguments in call to 'PROC_FIND_SPONSOR_BY_ADDRESS'"
exec proc_find_sponsor_by_address(test); 
-- Prints "identifier 'TEST' must be declared".
exec proc_find_sponsor_by_address('75'); 
-- Prints the address for sponsor "Ely Exeter".
exec proc_find_sponsor_by_address('northamptonshire'); 
-- Prints the addresses for sponsors "Darren Dooley" and "Ely Exeter".

-- proc_list_xp_activities
exec proc_list_xp_activities; 
-- Prints "wrong number or type of arguments in call to 'PROC_LIST_XP_ACTIVITIES'"
exec proc_list_xp_activities('a'); 
-- Prints "numeric or value error: character to number conversion error"
exec proc_list_xp_activities(6); 
-- Prints "An experience with an ID of 6 does not exist."
exec proc_list_xp_activities(1); 
-- Prints a list of all the activities in the experience "LUXURY DINNER FOR 4".

-- proc_calc_annual_takings
exec proc_calc_annual_takings; 
-- Prints "wrong number or type of arguments in call to 'PROC_CALC_ANNUAL_TAKINGS'"
exec proc_calc_annual_takings(6); 
-- Prints "wrong number or type of arguments in call to 'PROC_CALC_ANNUAL_TAKINGS'"
exec proc_calc_annual_takings('a', 'a'); 
-- Prints "numeric or value error: character to number conversion error"
exec proc_calc_annual_takings(6, '2020'); 
-- Prints "An experience with an ID of 6 does not exist."
exec proc_calc_annual_takings(1, '2020'); 
-- Prints "Between 1st January 2020 and 31st December 2020, the experience "LUXURY DINNER FOR 4" made GBP 1000 in sales."
exec proc_calc_annual_takings(1, '2021'); 
-- Prints "No tickets were sold for experience "LUXURY DINNER FOR 4" in 2021."

-- proc_lowest_price
exec proc_lowest_price; 
-- Prints "The lowest ticket price is GBP 45."

-- proc_highest_grossing
exec proc_highest_grossing; 
-- Prints "The highest grossing experience is "HELICOPTER RIDE" and has made GBP 4000."

DELETE FROM tickets; 
-- Delete all tickets.

exec proc_highest_grossing; 
-- Prints "No tickets have been sold."

-- Reinsert tickets.
INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 1, 1, 1000.00, '23-MAR-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 1, 1, 1000.00, '23-MAR-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 1, 1, 1200.00, '23-MAR-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 2, 2, 550.00, '13-FEB-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 3, 3, 2000.00, '06-JAN-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 3, 3, 2000.00, '27-FEB-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 4, 4, 45.00, '14-FEB-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 5, 5, 80.00, '16-JAN-2020');

INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 2, 1, 550.00, '13-FEB-2020');



-- proc_xp_duration
exec proc_xp_duration; 
-- Prints "wrong number or type of arguments in call to 'PROC_XP_DURATION'".
exec proc_xp_duration('a'); 
-- Prints "numeric or value error: character to number conversion error"
exec proc_xp_duration(6); 
-- Prints "An experience with an ID of 6 does not exist."
exec proc_xp_duration(1); 
-- Prints "The duration of experience "LUXURY DINNER FOR 4" is 1 day(s).

-- proc_staff_total
exec proc_staff_total; 
-- Prints "wrong number or type of arguments in call to 'PROC_STAFF_TOTAL'".
exec proc_staff_total('a'); 
-- Prints "numeric or value error: character to number conversion error"
exec proc_staff_total(6); 
-- Prints "An experience with an ID of 6 does not exist."
exec proc_staff_total(1); 
-- Prints "The amount of staff require for experience "LUXURY DINNER FOR 4" is: 6" 

-- proc_start_end_date
exec proc_start_end_date; 
-- Prints "wrong number or type of arguments in call to 'PROC_START_END_DATE'".
exec proc_start_end_date('a'); 
-- Prints "numeric or value error: character to number conversion error"
exec proc_start_end_date(6); 
-- Prints "An experience with an ID of 6 does not exist."
exec proc_start_end_date(1); 
-- Prints "The start and end dates for the experience "LUXURY DINNER FOR 4" have been updated successfully!"

-- Insert new (incomplete) experience.
INSERT INTO experiences (experience_id, experience_nature_id, experience_name, location_id)
VALUES (6, 1, 'TEST EXPERIENCE', 1); 

exec proc_start_end_date(6); 
-- Prints "The start and end dates for the experience "TEST EXPERIENCE" could not be updated due to a null value."

-- Delete the experience.
DELETE FROM experiences
WHERE experience_id = 6;

-- proc_print_experience_details
exec proc_print_experience_details(1); 
-- Prints "The experience LUXURY DINNER FOR 4 will be taking place at 17 ALPHA HOUSE [...] Number of staff needed : 6."
exec proc_print_experience_details(100); 
-- Prints "An experience with an ID of 100 does not exist."

-- proc_xp_season
UPDATE experiences 
SET season = 'WINTER' 
WHERE experience_id = 2; 
SELECT season FROM experiences WHERE experience_id = 2; 
-- WINTER
exec proc_xp_season(2); 
-- The season column for experience "COMEDY NIGHT" has been inserted.
SELECT season FROM experiences WHERE experience_id = 2; 
-- AUTUMN

exec proc_xp_season(3456); 
-- An experience with an ID of 3456 does not exist.

UPDATE experiences 
SET season = 'WINTER' 
WHERE experience_id = 3; 
SELECT season FROM experiences WHERE experience_id = 3;
exec proc_xp_season(3);
-- The season column for experience "COMEDY NIGHT" has been inserted.
SELECT season FROM experiences WHERE experience_id = 3; 
-- SPRING
	 
			 
			 

			 
/*
* CSY2038 Databases 2 - Assignment 2 - TRIGGERS.SQL
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\triggers.sql
-- @/Users/Laura/csy2038/DB-AS2/triggers.sql
-- @C:\Users\Daiana\DB-AS2\triggers.txt

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
FOR EACH ROW
WHEN ((INSTR(TO_CHAR(SYSDATE, 'DAY'),'SATURDAY')>0 OR INSTR(TO_CHAR(SYSDATE, 'DAY'),'SUNDAY')>0) OR 
(TO_CHAR(SYSDATE, 'HH24') < 9 OR TO_CHAR(Sysdate, 'HH24') > 16))
DECLARE
    no_weekends EXCEPTION;
    outside_hours EXCEPTION;
    PRAGMA exception_init(no_weekends, -20111);
    PRAGMA exception_init(outside_hours, -20112);
BEGIN

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
DELETE FROM experiences WHERE experience_id = 6;
SELECT experience_id FROM experiences;
-- CANNOT ALTER DATA OUTSIDE WORKING HOURS
-- Amend trigger for testing IF (TO_CHAR(SYSDATE, 'HH24') < 9 OR TO_CHAR(Sysdate, 'HH24') > 12)  gives successful insert for working hours.

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
-- Use ID from above;
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

-- With Laura's log in
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

-- With Daiana's log in
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
-- DROP COMPLETED!

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

-- with Laura's log in
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


-- With Daiana's log in
-- trig_user_log - records user log in date
CREATE OR REPLACE TRIGGER trig_user_log
AFTER LOGON
ON CSY2038_116.SCHEMA 

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



-- COMMIT CHANGES
COMMIT;



-- Testing - test_script_41
-- 10 triggers -- only 9 displayed, as one is db level example
-- SELECT trigger_name, trigger_type FROM user_triggers;
SELECT trigger_name FROM user_triggers;







/*
* CSY2038 Databases 2 - Assignment 2 - DROP.SQL
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\drop.sql
-- @/Users/Laura/csy2038/DB-AS2/drop.sql
-- @C:\Users\Daiana\DB-AS2\drop.txt



-- DROP FUNCTIONS (and testing procedures)

-- Run before running final version
-- DELETE FROM user_procedures WHERE object_name LIKE 'FUNC_%';

-- DROP FUNCTIONS
DROP FUNCTION func_staff_total;
DROP FUNCTION func_duration;
DROP FUNCTION func_xp_price_avg;
DROP FUNCTION func_takings_total;
DROP FUNCTION func_annual_takings_total;
DROP FUNCTION func_season;
DROP FUNCTION func_xp_name;
DROP FUNCTION func_sponsor_name;
DROP FUNCTION func_print_location_address;
DROP FUNCTION func_get_no_activities;
DROP FUNCTION func_make_upper;

-- DROP Procedures used for testing
DROP PROCEDURE proc_upper;
DROP PROCEDURE proc_get_no_activities;
DROP PROCEDURE proc_print_location_address;
DROP PROCEDURE proc_test_season;
DROP PROCEDURE proc_sponsor_name;
DROP PROCEDURE proc_xp_name;
DROP PROCEDURE proc_xp_annual_takings_total;
DROP PROCEDURE proc_xp_takings_total;
DROP PROCEDURE proc_xp_price_avg;
DROP PROCEDURE proc_test_duration;
-- DROP PROCEDURE proc_staff_total;

-- Drop procedures
DROP PROCEDURE proc_print_sponsor_address;
DROP PROCEDURE proc_xp_sponsors;
DROP PROCEDURE proc_find_sponsor_by_address;
DROP PROCEDURE proc_list_xp_activities;
DROP PROCEDURE proc_calc_annual_takings;
DROP PROCEDURE proc_lowest_avg_price;
DROP PROCEDURE proc_highest_grossing;
DROP PROCEDURE proc_xp_duration;
DROP PROCEDURE proc_staff_total;
DROP PROCEDURE proc_start_end_date;
DROP PROCEDURE proc_print_experience_details;
DROP PROCEDURE proc_xp_season;


-- DROP TRIGGERS
DROP TRIGGER trig_loc_insert_success;
DROP TRIGGER trig_xp_predicates;
DROP TRIGGER trig_pk_sponsor_no_update;
DROP TRIGGER trig_upper_firstname;
DROP TRIGGER trig_sponsors_reg_date;
DROP TRIGGER trig_security;
DROP TRIGGER trig_delete_sponsor;
DROP TRIGGER trig_schema_delete;
-- DROP TRIGGER trig_db_hello;
DROP TRIGGER trig_user_log;



-- DROP SEQUENCES
DROP SEQUENCE seq_tickets;
DROP SEQUENCE seq_experiences;
DROP SEQUENCE seq_experience_nature;
DROP SEQUENCE seq_locations;
DROP SEQUENCE seq_sponsors;
DROP SEQUENCE seq_userlog;

-- DROP FOREIGN KEYS
ALTER TABLE tickets
DROP CONSTRAINT fk_t_sponsors;

ALTER TABLE tickets
DROP CONSTRAINT fk_t_experiences;

ALTER TABLE experiences
DROP CONSTRAINT fk_e_locations;

ALTER TABLE experiences
DROP CONSTRAINT fk_e_experience_nature;

-- DROP PRIMARY KEYS
ALTER TABLE tickets
DROP CONSTRAINT pk_tickets;

ALTER TABLE sponsors
DROP CONSTRAINT pk_sponsors;

ALTER TABLE experience_nature
DROP CONSTRAINT pk_experience_nature;

ALTER TABLE locations
DROP CONSTRAINT pk_locations;


ALTER TABLE experiences
DROP CONSTRAINT pk_experiences;

ALTER TABLE userlog
DROP CONSTRAINT pk_userlog;


-- DROP CHECK, UNIQUE and DEFAULT CONSTRAINTS

ALTER TABLE sponsors
DROP CONSTRAINT ck_sponsor_surname;

ALTER TABLE sponsors
DROP CONSTRAINT ck_company_name;

ALTER TABLE experiences
DROP CONSTRAINT ck_season;

ALTER TABLE tickets
DROP CONSTRAINT ck_price;

ALTER TABLE sponsors
MODIFY registration_date DEFAULT NULL;

ALTER TABLE experience_nature
DROP CONSTRAINT uq_xp_nature_name;

-- DROP TABLES
DROP TABLE tickets;
DROP TABLE locations;
DROP TABLE sponsors;
DROP TABLE experience_nature;
DROP TABLE experiences;
DROP TABLE addresses;
DROP TABLE userlog;

-- DROP TYPES
DROP TYPE activity_table_type;
DROP TYPE activity_type;
DROP TYPE contact_varray_type;
DROP TYPE contact_type;
DROP TYPE date_varray_type;
DROP TYPE address_type;

-- COMMIT CHANGES
PURGE RECYCLEBIN;
COMMIT;

-- Testing
SELECT * FROM user_objects; 
-- SELECT object_name FROM user_objects;
-- no rows selected	 
			 
			 





/*
* CSY2038 Databases 2 - Assignment 2 - SCRIPT.SQL - to be used for demo
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/


-- script
-- @C:\DB-AS2\script.sql
-- @/Users/Laura/csy2038/DB-AS2/script.sql


COLUMN object_name FORMAT A30;
COLUMN object_type FORMAT A12;
PURGE RECYCLEBIN;
SELECT object_name, object_type FROM user_objects;


-- drop
@C:\DB-AS2\drop.sql
@/Users/Laura/csy2038/DB-AS2/drop.sql
@C:\Users\Daiana\DB-AS2\drop.txt

-- create
@C:\DB-AS2\create.sql
@/Users/Laura/csy2038/DB-AS2/create.sql
@C:\Users\Daiana\DB-AS2\create.txt

-- alter
@C:\DB-AS2\alter.sql
@/Users/Laura/csy2038/DB-AS2/alter.sql
@C:\Users\Daiana\DB-AS2\alter.txt

-- insert
@C:\DB-AS2\insert.sql
@/Users/Laura/csy2038/DB-AS2/insert.sql
@C:\Users\Daiana\DB-AS2\insert.txt

-- queries
@C:\DB-AS2\query.sql
@/Users/Laura/csy2038/DB-AS2/query.sql
@C:\Users\Daiana\DB-AS2\query.txt

-- functions
@C:\DB-AS2\functions.sql
@/Users/Laura/csy2038/DB-AS2/functions.sql
@C:\Users\Daiana\DB-AS2\functions.txt

-- procedures
@C:\DB-AS2\procedures.sql
@/Users/Laura/csy2038/DB-AS2/procedures.sql
@C:\Users\Daiana\DB-AS2\procedures.txt

-- triggers
@C:\DB-AS2\triggers.sql
@/Users/Laura/csy2038/DB-AS2/triggers.sql
@C:\Users\Daiana\DB-AS2\triggers.txt



COLUMN object_name FORMAT A30;
COLUMN object_type FORMAT A12;
PURGE RECYCLEBIN;
SELECT object_name, object_type FROM user_objects;	 
			 
			 
			 
			 
			 

			 


