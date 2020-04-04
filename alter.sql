/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\alter.sql
-- @/Users/Laura/csy2038/DB-AS2/alter.sql

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
DESC user_constraints;
SELECT constraint_name NAME, constraint_type T FROM user_constraints;
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