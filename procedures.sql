/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\procedures.sql
-- @/Users/Laura/csy2038/DB-AS2/procedures.sql

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
        DBMS_OUTPUT.PUT_LINE('The duration of experience "' || vc_experience_name || '" is ' || func_duration(dates(1), dates(2)) || ' day(s).');
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
exec proc_print_sponsor_address; -- Prints "wrong number or type of arguments in call to 'PROC_PRINT_SPONSOR_ADDRESS'"
exec proc_print_sponsor_address('a'); -- Prints "numeric or value error: character to number conversion error"
exec proc_print_sponsor_address(6); -- Prints "An experience with an ID of 6 does not exist."
exec proc_print_sponsor_address(1); -- Prints the address for sponsor "Andrew Adams".

-- proc_xp_sponsors
exec proc_xp_sponsors; -- Prints "wrong number or type of arguments in call to 'PROC_XP_SPONSORS'"
exec proc_xp_sponsors('a'); -- Prints "numeric or value error: character to number conversion error"
exec proc_xp_sponsors(6); -- Prints "An experience with an ID of 6 does not exist."
exec proc_xp_sponsors(1); -- Prints a list of all the sponsors of the experience "LUXURY DINNER FOR 4".

-- proc_find_sponsor_by_address
exec proc_find_sponsor_by_address; -- Prints "wrong number or type of arguments in call to 'PROC_FIND_SPONSOR_BY_ADDRESS'"
exec proc_find_sponsor_by_address(test); -- Prints "identifier 'TEST' must be declared".
exec proc_find_sponsor_by_address('75'); -- Prints the address for sponsor "Ely Exeter".
exec proc_find_sponsor_by_address('northamptonshire'); -- Prints the addresses for sponsors "Darren Dooley" and "Ely Exeter".

-- proc_list_xp_activities
exec proc_list_xp_activities; -- Prints "wrong number or type of arguments in call to 'PROC_LIST_XP_ACTIVITIES'"
exec proc_list_xp_activities('a'); -- Prints "numeric or value error: character to number conversion error"
exec proc_list_xp_activities(6); -- Prints "An experience with an ID of 6 does not exist."
exec proc_list_xp_activities(1); -- Prints a list of all the activities in the experience "LUXURY DINNER FOR 4".

-- proc_calc_annual_takings
exec proc_calc_annual_takings; -- Prints "wrong number or type of arguments in call to 'PROC_CALC_ANNUAL_TAKINGS'"
exec proc_calc_annual_takings(6); -- Prints "wrong number or type of arguments in call to 'PROC_CALC_ANNUAL_TAKINGS'"
exec proc_calc_annual_takings('a', 'a'); -- Prints "numeric or value error: character to number conversion error"
exec proc_calc_annual_takings(6, '2020'); -- Prints "An experience with an ID of 6 does not exist."
exec proc_calc_annual_takings(1, '2020'); -- Prints "Between 1st January 2020 and 31st December 2020, the experience "LUXURY DINNER FOR 4" made GBP 1000 in sales."
exec proc_calc_annual_takings(1, '2021'); -- Prints "No tickets were sold for experience "LUXURY DINNER FOR 4" in 2021."

-- proc_lowest_price
exec proc_lowest_price; -- Prints "The lowest ticket price is GBP 45."

-- proc_highest_grossing
exec proc_highest_grossing; -- Prints "The highest grossing experience is "HELICOPTER RIDE" and has made GBP 4000."

DELETE FROM tickets; -- Delete all tickets.

exec proc_highest_grossing; -- Prints "No tickets have been sold."

-- Reinsert tickets.
INSERT INTO tickets(ticket_number, experience_id, sponsor_id, price, date_sold)
VALUES(seq_tickets.nextval, 1, 1, 1000.00, '23-MAR-2020');

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

-- proc_xp_duration
exec proc_xp_duration; -- Prints "wrong number or type of arguments in call to 'PROC_XP_DURATION'".
exec proc_xp_duration('a'); -- Prints "numeric or value error: character to number conversion error"
exec proc_xp_duration(6); -- Prints "An experience with an ID of 6 does not exist."
exec proc_xp_duration(1); -- Prints "The duration of experience "LUXURY DINNER FOR 4" is 1 day(s).

-- proc_staff_total
exec proc_staff_total; -- Prints "wrong number or type of arguments in call to 'PROC_STAFF_TOTAL'".
exec proc_staff_total('a'); -- Prints "numeric or value error: character to number conversion error"
exec proc_staff_total(6); -- Prints "An experience with an ID of 6 does not exist."
exec proc_staff_total(1); -- Prints "The amount of staff require for experience "LUXURY DINNER FOR 4" is: 6" 

-- proc_start_end_date
exec proc_start_end_date; -- Prints "wrong number or type of arguments in call to 'PROC_START_END_DATE'".
exec proc_start_end_date('a'); -- Prints "numeric or value error: character to number conversion error"
exec proc_start_end_date(6); -- Prints "An experience with an ID of 6 does not exist."
exec proc_start_end_date(1); -- Prints "The start and end dates for the experience "LUXURY DINNER FOR 4" have been updated successfully!"

-- Insert new (incomplete) experience.
INSERT INTO experiences (experience_id, experience_nature_id, experience_name, location_id)
VALUES (6, 1, 'TEST EXPERIENCE', 1); 

exec proc_start_end_date(6); -- Prints "The start and end dates for the experience "TEST EXPERIENCE" could not be updated due to a null value."

-- Delete the experience.
DELETE FROM experiences
WHERE experience_id = 6;

-- proc_print_experience_details
exec proc_print_experience_details(1); -- Prints "The experience LUXURY DINNER FOR 4 will be taking place at 17 ALPHA HOUSE [...] Number of staff needed : 6."
exec proc_print_experience_details(100); -- Prints "An experience with an ID of 100 does not exist."

-- proc_xp_season
UPDATE experiences 
SET season = 'WINTER' 
WHERE experience_id = 2; 
SELECT season FROM experiences WHERE experience_id = 2; -- WINTER
exec proc_xp_season(2); -- The season column for experience "COMEDY NIGHT" has been inserted.
SELECT season FROM experiences WHERE experience_id = 2; -- AUTUMN

exec proc_xp_season(3456); -- An experience with an ID of 3456 does not exist.

UPDATE experiences 
SET season = 'WINTER' 
WHERE experience_id = 3; 
SELECT season FROM experiences WHERE experience_id = 3;
exec proc_xp_season(3);-- The season column for experience "COMEDY NIGHT" has been inserted.
SELECT season FROM experiences WHERE experience_id = 3; -- SPRING
