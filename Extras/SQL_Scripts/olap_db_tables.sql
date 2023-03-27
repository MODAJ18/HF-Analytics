-- PatientProcedureDim
CREATE TABLE IF NOT EXISTS PatientProcedureDim (
    pr_id varchar(20) PRIMARY KEY,
    name varchar(150) NOT NULL,
    type varchar(50),
    price numeric
);

-- EmployeeDim
CREATE TABLE IF NOT EXISTS EmployeeDim (
    emp_id varchar(30) PRIMARY KEY,
    emp_name varchar(150) NOT NULL,
    emp_dob DATE,
    emp_date_entry DATE NOT NULL,
    building char(1) NOT NULL,
    emp_salary Numeric,
    section varchar(100) NOT NULL,
    specialty varchar(300) NOT NULL
);

-- PatientDim
CREATE TABLE IF NOT EXISTS PatientDim (
    p_id varchar(30) PRIMARY KEY,
    name varchar(150) NOT NULL,
    sex varchar(50) NOT NULL,
    race_group varchar(50),
    age_group varchar(50) NOT NULL,
    language varchar(50) NOT NULL,
    payer_source varchar(50) NOT NULL,
    disposition varchar(150) NOT NULL,
    social_security_num char(11),
    date_of_birth date NOT NULL,
    credit_card_number varchar(30),
    address varchar(500),
    state varchar(100),
    city varchar(150)
);

-- HealthFacilityDim
CREATE TABLE IF NOT EXISTS HealthFacilityDim (
    location_id int NOT NULL,
    oshpd_id2 int NOT NULL,
    name varchar(250),
    city varchar(150) NOT NULL,
    county varchar(250),
    address varchar(500) NOT NULL,
    zip_code VARCHAR(15),
    license_type varchar(50) NOT NULL,
    PRIMARY KEY (location_id, oshpd_id2)
);

-- HealthFacilityAdditionalDim
CREATE TABLE IF NOT EXISTS HealthFacilityAdditionalDim (
    h_additional_id_loc int,
    h_additional_id_fac int,
    oshpd_id int,
    congressional_district_num int,
    senate_district_num int,
    assembly_district_num int,
    control_type_desc varchar(250) NOT NULL,
    control_type_category_desc varchar(100) NOT NULL,
    mssa_name VARCHAR(200),
    mssa_designation varchar(50),
    PRIMARY KEY(h_additional_id_loc, h_additional_id_fac),
    
    FOREIGN KEY (h_additional_id_loc, h_additional_id_fac)
      REFERENCES HealthFacilityDim (location_id, oshpd_id2)
);

-- VisitFact
CREATE TABLE IF NOT EXISTS VisitFact (
    visit_id varchar(35) PRIMARY KEY,
    patient_dim_id varchar(30) NOT NULL,
    procedure_dim_id varchar(20) NOT NULL,
    health_facility_dim_id_fac int NOT NULL,
    health_facility_dim_id_loc int NOT NULL,
    visit_date date NOT NULL,
    employee_dim_id varchar(30) NOT NULL,
    rating int NOT NULL,
    payment Numeric,
    
    FOREIGN KEY (patient_dim_id)
      REFERENCES PatientDim (p_id),
    FOREIGN KEY (procedure_dim_id)
      REFERENCES PatientProcedureDim (pr_id),
    FOREIGN KEY (health_facility_dim_id_loc, health_facility_dim_id_fac)
      REFERENCES HealthFacilityDim (location_id, oshpd_id2),
    FOREIGN KEY (employee_dim_id)
      REFERENCES EmployeeDim (emp_id)
);