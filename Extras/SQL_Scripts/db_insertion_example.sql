BEGIN TRANSACTION;
-- 1
INSERT INTO 
    PatientProcedures (pr_id, name, description, type, price)
VALUES
    ('XXXXXXXDAPf6a37', 'Dx_All_Pregnancies', 'Pregnancy is the time during which one or more offspring develops (gestates) inside a woman''s uterus (womb). A multiple pregnancy involves more than one offspring, such as with twins. Pregnancy usually occurs by sexual intercourse, but can also occur through assisted reproductive technology procedures. The diagnosis of pregnancy requires a multifaceted approach using 3 main diagnostic tools. These are history and physical examination, laboratory evaluation, and ultrasonography.', 
        'diagnosis', '15'),
    ('XXXXXXXXDC24449', 'Dx_Circulatory', 'Circulatory system diseases affect your heart and blood vessels and make it harder for blood to flow throughout your body. Some conditions have symptoms, but others are silent. Common symptoms include chest pain, edema, heart palpitations and shortness of breath. these diseases can be diagnosed through the Cardiovascular diagnostic procedures and screening tests can provide a wealth of information about the electrical activity of the heart, heartbeat rhythm, how well blood is pumping through the heart’s chambers and valves, how easily blood is flowing through the coronary arteries to the heart muscle, and whether there are tumors or abnormalities in the structure of the cardiovascular system.',
        'diagnosis', '1400');


-- 2
INSERT INTO 
    PatientCharacteristics (ch_id, sex, race_group, age_group, language, payer_source, disposition)
VALUES
    ('16755', 'Sex_Male', 'Hispanic', 'Age_30_39', 'Tagalog', 'Self_Pay', 'Routine'),
    ('25663', 'Sex_Male', 'Asian_Pacific_Islander', 'Age_60_69', 'Vietnamese',
    'Private_Coverage', 'Not_Defined_Elsewhere');


-- 3
INSERT INTO 
    Locations (location_id, name, county, address, zip_code, congressional_district_num,
                senate_district_num, assembly_district_num)
VALUES
    ('259', 'SAN DIEGO', 'SAN DIEGO', '3020 CHILDRENS WAY', '92123', '53', '39', '79');


-- 4
INSERT INTO 
    HealthFacilities (h_id, oshpd_id, name, control_type_desc, control_type_category_desc,
                      mssa_name, mssa_designation, license_type)
VALUES
    ('106370673', '370673','RADY CHILDRENS HOSPITAL - SAN DIEGO', 'Nonprofit - Corporation',
    'Nonprofit', 'Bay Park/Five Points/Hillcrest Northwest/Mission Hills/Mission Valley/Morena/Normal Heights/Old Town/Serra Mesa',
    'Urban', 'Hospital');


-- 5
INSERT INTO 
    HealthFacilityLocations (h_id, location_id)
VALUES
    ('106370673', '259');


-- 6
INSERT INTO 
    Patients (p_id, name, p_chid, p_hid, social_security_num, date_of_birth, 
              credit_card_number, address, state, city)
VALUES
    ('LF-82754757920252916526', 'Latoya Fitzpatrick', '16755', '106370673', '001-11-7487',
      '1978-10-2', '345563864804720', '18048 Hahn Stravenue Suite 526\nJefferychester, WA 29467',
      'New Hampshire', 'New Laurie'),
    ('DB-39935034091899284806', 'Danielle Barnes', '25663', '106370673', '428-70-8196',
      '1922-2-25', '180077166974642', '9050 Destiny Tunnel\nBrownfurt, RI 06369',
      'Texas', 'Gregorymouth');


-- 7 
INSERT INTO 
    Employees (emp_id, emp_name, emp_dob, emp_date_entry, emp_hid, building,
                emp_salary, section, specialty)
VALUES
    ('G-EK-137429280863837', 'Julie Hancock', '1980-1-20', '2016-10-08 08:49:37.867019',
     '106370673', 'A', '259014.26', 'Gynecology', 'Gynecologist'),
    ('C-YL-196529548602643', 'Tracy Maxwell', '1991-5-1', '2019-03-16 01:24:49.661696',
     '106370673', 'A', '119337.86', 'Cardiology', 'Nurse');


-- 8
INSERT INTO 
    PatientVisits (visit_id, visit_pid, procedure, visit_hid, visit_date, procedure_by,
                    rating, payment)
VALUES
    ('20209-CB-162221341466178', 'LF-82754757920252916526', 'XXXXXXXDAPf6a37',
      '106370673', '2020-09-17 01:23:22.120878', 'G-EK-137429280863837', '1',
        '28'),
    ('202111-HG-370955155937675', 'DB-39935034091899284806', 'XXXXXXXXDC24449',
      '106370673', NULL, 'C-YL-196529548602643', '5',
      '1719');

COMMIT TRANSACTION;