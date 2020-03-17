/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (), Laura Ghiorghisor ()
*/

-- @C:\DB-AS2\drop.sql

-- DROP SEQUENCES
DROP SEQUENCE seq_tickets;
DROP SEQUENCE seq_experiences;
DROP SEQUENCE seq_experience_nature;
DROP SEQUENCE seq_locations;
DROP SEQUENCE seq_sponsors;

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

ALTER TABLE experiences
DROP CONSTRAINT pk_experiences;

ALTER TABLE experience_nature
DROP CONSTRAINT pk_experience_nature;

ALTER TABLE locations
DROP CONSTRAINT pk_locations;

ALTER TABLE sponsors
DROP CONSTRAINT pk_sponsors;

-- DROP TABLES
DROP TABLE tickets;
DROP TABLE experiences;
DROP TABLE experience_nature;
DROP TABLE locations;
DROP TABLE sponsors;

-- DROP TYPES
DROP TYPE address_type;
DROP TYPE activity_table_type;
DROP TYPE activity_type;
DROP TYPE contact_varray_type;
DROP TYPE contact_type;

-- COMMIT CHANGES
PURGE RECYCLEBIN;
COMMIT;