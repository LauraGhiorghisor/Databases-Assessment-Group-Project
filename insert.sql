/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\insert.sql
-- @/Users/Laura/csy2038/DB-AS2/insert.sql



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