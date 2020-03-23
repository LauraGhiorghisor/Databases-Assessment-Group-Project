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

    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.house_no || ' ' ||rec_cur_address.address.street);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.city);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.county);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.postcode);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.country);

    CLOSE cur_address;
END;
/
SHOW ERRORS;
*/

-- proc_print_sponsor_address
CREATE OR REPLACE PROCEDURE proc_print_sponsor_address (in_sponsor_id sponsors.sponsor_id%TYPE) IS
    CURSOR cur_address IS
    SELECT sponsor_id, address
    FROM sponsors
    WHERE sponsor_id = in_sponsor_id;

    rec_cur_address cur_address%ROWTYPE;
BEGIN
    OPEN cur_address;
    FETCH cur_address INTO rec_cur_address;

    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.house_no || ' ' ||rec_cur_address.address.street);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.city);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.county);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.postcode);
    DBMS_OUTPUT.PUT_LINE(rec_cur_address.address.country);

    CLOSE cur_address;
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
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_cur_sponsors.sponsor_id || ' - NAME: ' || rec_cur_sponsors.sponsor_surname || ', ' || rec_cur_sponsors.sponsor_firstname);
    END LOOP;
END proc_xp_sponsors;
/
SHOW ERRORS;

set escape on;

-- proc_calc_annual_takings
CREATE OR REPLACE PROCEDURE proc_calc_annual_takings (in_xp_id experiences.experience_id%TYPE, in_year VARCHAR2) IS
    vc_experience_name experiences.experience_name%TYPE;
    vd_date_sold DATE;
    vn_total NUMBER(6,2);
BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Calculate the annual takings and store it in vn_total.
    vn_total := func_annual_takings_total(in_xp_id, in_year);

    -- Display the amount made in the given year.
    IF vn_total IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Between 1st January ' || in_year || ' and 31st December ' || in_year || ', the experience "' || vc_experience_name || '" made GBP ' || vn_total || ' in sales.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No tickets were sold for experience "' || vc_experience_name || '" in ' || in_year || '.');
    END IF;
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
        DBMS_OUTPUT.PUT_LINE('No tickets have been sold.');
    END IF;
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

    -- Initialised array and set size to 2.
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
END proc_xp_duration;
/
SHOW ERRORS;

-- proc_staff_total
CREATE OR REPLACE procedure proc_staff_total (in_xp_id experiences.experience_id%TYPE) IS
    vc_experience_name experiences.experience_name%TYPE;

BEGIN
    -- Fetch the experience_name and store it in vc_experience_name.
    vc_experience_name := func_xp_name(in_xp_id);

    -- Display the amount of staff required for the given experience.
    DBMS_OUTPUT.PUT_LINE('The amount of staff required for experience "' || vc_experience_name || '" is: ' || func_staff_total(in_xp_id));
END proc_staff_total;
/
SHOW ERRORS;