/*
* CSY2038 Databases 2 - Assignment 2
* Group 5
* Alexander Turner (18416709), Daiana Gusatu (18424099), Laura Ghiorghisor (18408400)
*/

-- @C:\DB-AS2\procedures.sql
-- @/Users/Laura/csy2038/DB-AS2/procedures.sql

SET SERVEROUTPUT ON;

-- proc_print_location_address
/*
CREATE OR REPLACE PROCEDURE proc_print_location_address (in_location_id locations.location_id%TYPE) IS
    CURSOR cur_address IS
    SELECT location_id, address
    FROM locations
    WHERE location_id = in_location_id;

    rec_cur_address cur_address%ROWTYPE;
BEGIN
    OPEN cur_address;
    FETCH cur_address INTO rec_cur_address;

    DBMS_OUTPUT.PUT_LINE(INITCAP(rec_cur_address.address.house_no || ' ' ||rec_cur_address.address.street));
    DBMS_OUTPUT.PUT_LINE(INITCAP(rec_cur_address.address.city));
    DBMS_OUTPUT.PUT_LINE(INITCAP(rec_cur_address.address.county));
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.postcode);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.country || chr(10));

    CLOSE cur_address;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('A location with an ID of ' || in_location_id || ' does not exist.');
END;
/
SHOW ERRORS;
*/

-- proc_print_sponsor_address
CREATE OR REPLACE PROCEDURE proc_print_sponsor_address (in_sponsor_id sponsors.sponsor_id%TYPE) IS
    CURSOR cur_address IS
    SELECT sponsor_id, sponsor_firstname, sponsor_surname, address
    FROM sponsors
    WHERE sponsor_id = in_sponsor_id;

    rec_cur_address cur_address%ROWTYPE;
BEGIN
    OPEN cur_address;
    FETCH cur_address INTO rec_cur_address;

    DBMS_OUTPUT.PUT_LINE(INITCAP(rec_cur_address.sponsor_firstname || ' ' || rec_cur_address.sponsor_surname));
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

-- proc_xp_sponsors
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
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- List all sponsors for the given experience.
    DBMS_OUTPUT.PUT_LINE('=== SPONSORS FOR EXPERIENCE: "' || vc_experience_name || '" ===');
    FOR rec_cur_sponsors IN cur_sponsors LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_cur_sponsors.sponsor_id || ' | NAME: ' || rec_cur_sponsors.sponsor_surname || ', ' || rec_cur_sponsors.sponsor_firstname);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_xp_sponsors;
/
SHOW ERRORS;

-- proc_find_sponsor_by_address
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
        IF INSTR(vc_current_address, UPPER(in_search_string)) > 0 THEN
            proc_print_sponsor_address(rec_cur_sponsor_addresses.sponsor_id);
        END IF;

        FETCH cur_sponsor_addresses INTO rec_cur_sponsor_addresses;
    END LOOP;

    CLOSE cur_sponsor_addresses;
END proc_find_sponsor_by_address;
/
SHOW ERRORS;

-- proc_list_xp_activities
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

    rec_cur_activities cur_activities%ROWTYPE;
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Initialise array and set size to 2.
    dates := datearray();
    dates.extend(2);

    OPEN cur_activities;

    -- Display all activities belonging to the specified experience.
    DBMS_OUTPUT.PUT_LINE('=== Activities in experience "' || vc_experience_name || '" ===');
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

-- proc_calc_annual_takings
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

-- proc_lowest_avg_price
CREATE OR REPLACE PROCEDURE proc_lowest_avg_price IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('The lowest average price for all experiences is GBP ' || func_xp_price_min || '.');
END proc_lowest_avg_price;
/
SHOW ERRORS;

-- proc_highest_grossing
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

-- proc_xp_duration
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
    DBMS_OUTPUT.PUT_LINE('The duration of experience "' || vc_experience_name || '" is ' || func_duration(dates(1), dates(2)) || ' days.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_xp_duration;
/
SHOW ERRORS;

-- proc_staff_total
CREATE OR REPLACE PROCEDURE proc_staff_total (in_xp_id experiences.experience_id%TYPE) IS
    vc_experience_name experiences.experience_name%TYPE;
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Display the amount of staff required for the given experience.
    DBMS_OUTPUT.PUT_LINE('The amount of staff required for experience "' || vc_experience_name || '" is: ' || func_staff_total(in_xp_id));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('An experience with an ID of ' || in_xp_id || ' does not exist.');
END proc_staff_total;
/
SHOW ERRORS;

-- proc_start_end_date
CREATE OR REPLACE PROCEDURE proc_start_end_date (in_xp_id experiences.experience_id%TYPE) IS
    CURSOR cur_activity_dates IS
    SELECT d.column_value
    FROM experiences e, TABLE(e.activities) a, TABLE(a.activity_date) d
    WHERE e.experience_id = in_xp_id
    ORDER BY d.column_value ASC;
    
    vd_start_date DATE;
    vd_end_date DATE;

    date_null EXCEPTION;
    no_rows EXCEPTION;

    vc_experience_name experiences.experience_name%TYPE;
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Retrieve and store the start date and end date in vd_start_date and vd_end_date.
    FOR rec_cur_activity_dates IN cur_activity_dates LOOP
        IF vd_start_date IS NULL THEN
            vd_start_date := rec_cur_activity_dates.column_value;
        ELSE
            vd_end_date := rec_cur_activity_dates.column_value;
        END IF;
    END LOOP;

    -- Attempt to update the start and end date for the given experience.
    IF vd_start_date IS NOT NULL AND vd_end_date IS NOT NULL THEN
        UPDATE experiences
        SET experience_date = date_varray_type(vd_start_date, vd_end_date)
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