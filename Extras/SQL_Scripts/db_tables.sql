CREATE TABLE IF NOT EXISTS PatientProcedures (
    pr_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    type VARCHAR(50),
    price NUMERIC
);

CREATE TABLE IF NOT EXISTS PatientCharacteristics (
    ch_id INT PRIMARY KEY,
    sex VARCHAR(50) NOT NULL,
    race_group VARCHAR(50),
    age_group VARCHAR(50) NOT NULL,
    language VARCHAR(50) NOT NULL,
    payer_source VARCHAR(50) NOT NULL,
    disposition VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS Locations (
    location_id INT PRIMARY KEY,
    city varchar(150) NOT NULL,
    county VARCHAR(250),
    address VARCHAR(500) NOT NULL,
    zip_code VARCHAR(15),
    congressional_district_num INT,
    senate_district_num INT,
    assembly_district_num INT
);

CREATE TABLE IF NOT EXISTS HealthFacilities (
    h_id INT PRIMARY KEY,
    oshpd_id INT,
    name VARCHAR(250), 
    control_type_desc VARCHAR(150) NOT NULL,
    control_type_category_desc VARCHAR(100) NOT NULL,
    mssa_name VARCHAR(200),
    mssa_designation VARCHAR(50),
    license_type VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS HealthFacilityLocations (
    h_id int NOT NULL,
    location_id int NOT NULL,
    PRIMARY KEY (h_id, location_id),
    FOREIGN KEY (h_id)
      REFERENCES HealthFacilities (h_id),
    FOREIGN KEY (location_id)
      REFERENCES Locations (location_id)
);

CREATE TABLE IF NOT EXISTS Patients (
    p_id varchar(30) PRIMARY KEY,
    name varchar(150) NOT NULL,
    p_chid int,
    p_hid int NOT NULL,
    social_security_num char(11),
    date_of_birth date NOT NULL,
    credit_card_number varchar(30),
    address varchar(500),
    state varchar(100),
    city varchar(150),
    
    FOREIGN KEY (p_chid)
      REFERENCES PatientCharacteristics (ch_id),
    FOREIGN KEY (p_hid)
      REFERENCES HealthFacilities (h_id)
);

CREATE TABLE IF NOT EXISTS Employees (
    emp_id varchar(30) PRIMARY KEY,
    emp_name varchar(150) NOT NULL,
    emp_dob DATE,
    emp_date_entry DATE NOT NULL,
    emp_hid INT NOT NULL,
    building char(1) NOT NULL,
    emp_salary Numeric,
    section varchar(100)  NOT NULL,
    specialty varchar(300) NOT NULL,
    
    FOREIGN KEY (emp_hid)
      REFERENCES HealthFacilities (h_id)
);

CREATE TABLE IF NOT EXISTS PatientVisits (
    visit_id varchar(35) PRIMARY KEY,
    visit_pid varchar(30) NOT NULL,
    procedure varchar(20),
    visit_hid int NOT NULL,
    visit_date date,
    procedure_by varchar(30),
    rating int,
    payment Numeric,
    
    FOREIGN KEY (visit_pid)
      REFERENCES Patients (p_id),
    FOREIGN KEY (procedure)
      REFERENCES PatientProcedures (pr_id),
    FOREIGN KEY (visit_hid)
      REFERENCES HealthFacilities (h_id),
    FOREIGN KEY (procedure_by)
      REFERENCES Employees (emp_id)
);
