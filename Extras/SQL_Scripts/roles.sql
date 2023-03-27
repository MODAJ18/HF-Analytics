-- Business Executives
CREATE ROLE HF_business_ex
LOGIN
PASSWORD 'HF_be123'
CONNECTION LIMIT 5;
GRANT CONNECT ON DATABASE hospital_oltp_db TO HF_business_ex;
GRANT USAGE ON SCHEMA public TO HF_business_ex;
GRANT SELECT ON FacilityGeneralView TO HF_business_ex;
GRANT SELECT ON FacilityPerformanceView TO HF_business_ex;
GRANT SELECT ON PatientVisitInfoView TO HF_business_ex;
GRANT SELECT ON PatientVisits TO HF_business_ex;
GRANT SELECT ON HealthFacilities TO HF_business_ex;
GRANT SELECT ON PatientProcedures TO HF_business_ex;

-- Secretary
CREATE ROLE HF_secretary
LOGIN
PASSWORD 'HF_sec123'
CONNECTION LIMIT 25;
GRANT CONNECT ON DATABASE hospital_oltp_db TO HF_secretary;
GRANT USAGE ON SCHEMA public TO HF_secretary;
GRANT SELECT ON Patients TO HF_secretary;
GRANT SELECT, DELETE, UPDATE, INSERT ON PatientVisits TO HF_secretary;

-- Accountant
CREATE ROLE HF_accountant
LOGIN
PASSWORD 'HF_acc123'
CONNECTION LIMIT 20;
GRANT CONNECT ON DATABASE hospital_oltp_db TO HF_accountant;
GRANT USAGE ON SCHEMA public TO HF_accountant;
GRANT SELECT, DELETE, UPDATE, INSERT ON PatientVisits TO HF_accountant;
GRANT SELECT, DELETE, UPDATE, INSERT ON PatientProcedures TO HF_accountant;


-- Analyst
CREATE ROLE HF_analyst
LOGIN
PASSWORD 'HF_ana123'
CONNECTION LIMIT 10;
GRANT CONNECT ON DATABASE hospital_oltp_db TO HF_analyst;
GRANT CONNECT ON DATABASE hospital_olap_db TO HF_analyst;
GRANT USAGE ON SCHEMA public TO HF_analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO HF_analyst;


-- Data Engineer
CREATE ROLE HF_data_engineer
LOGIN
PASSWORD 'HF_de123'
CONNECTION LIMIT 10;
GRANT ALL PRIVILEGES ON DATABASE hospital_oltp_db TO HF_data_engineer;
GRANT ALL PRIVILEGES ON DATABASE hospital_olap_db TO HF_data_engineer;
GRANT USAGE ON SCHEMA public TO HF_data_engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO HF_data_engineer;


-- database administrator
CREATE ROLE HF_database_administrator WITH
SUPERUSER
CREATEDB
CREATEROLE
REPLICATION
LOGIN
PASSWORD 'HF_dba123'
CONNECTION LIMIT 5;
GRANT ALL PRIVILEGES ON DATABASE hospital_oltp_db TO HF_data_engineer;
GRANT ALL PRIVILEGES ON DATABASE hospital_olap_db TO HF_data_engineer;
GRANT ALL PRIVILEGES ON SCHEMA public TO HF_data_engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO HF_data_engineer;


