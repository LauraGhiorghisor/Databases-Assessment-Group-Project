/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (), Laura Ghiorghisor ()
*/

-- @C:\DB-AS2\alter.sql

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
PRIMARY KEY (ticket_id);

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

-- CHECK CONSTRAINTS
-- sponsors
ALTER TABLE sponsors
ADD CONSTRAINT ck_sponsor_firstname
CHECK (sponsor_firstname = UPPER(sponsor_firstname))

ALTER TABLE sponsors
ADD CONSTRAINT ck_sponsor_surname
CHECK (sponsor_surname = UPPER(sponsor_surname))

ALTER TABLE sponsors
ADD CONSTRAINT ck_company_name
CHECK (company_name = UPPER(company_name))

ALTER TABLE sponsors
ADD CONSTRAINT ck_description
CHECK (description = UPPER(description))

-- COMMIT CHANGES
COMMIT;