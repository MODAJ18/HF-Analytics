-- PatientProcedureDim
SELECT pp.pr_id,
       pp.name,
       pp.type,
       pp.price
FROM PatientProcedures pp;


-- EmployeeDim
SELECT e.emp_id,
       e.emp_name,
       e.emp_dob,
       e.emp_date_entry,
       e.building,
       e.emp_salary,
       e.section,
       e.specialty
FROM Employees e;


-- PatientDim
SELECT p.p_id,
       p.name,
       pc.sex,
       pc.race_group,
       pc.age_group,
       pc.language,
       pc.payer_source,
       pc.disposition,
       p.social_security_num,
       p.date_of_birth,
       p.credit_card_number,
       p.address,
       p.state,
       p.city
FROM Patients p
INNER JOIN PatientCharacteristics pc ON p.p_chid=pc.ch_id;


-- HealthFacilityDim
SELECT 
       l.location_id,
       hf.h_id as oshpd_id2,
       hf.name,
       l.city,
       l.county,
       l.address,
       l.zip_code,
       hf.license_type
FROM HealthFacilities hf
INNER JOIN HealthFacilityLocations hfl ON hf.h_id=hfl.h_id
INNER JOIN Locations l ON hfl.location_id=l.location_id; 


-- HealthFacilityAdditionalDim
SELECT l.location_id as h_additional_id_loc,
       hf.h_id as h_additional_id_fac,       
       hf.oshpd_id,
       l.congressional_district_num,
       l.senate_district_num,
       l.assembly_district_num,
       hf.control_type_desc,
       hf.control_type_category_desc,
       hf.mssa_name,
       hf.mssa_designation
FROM HealthFacilities hf
INNER JOIN HealthFacilityLocations hfl ON hf.h_id=hfl.h_id
INNER JOIN Locations l ON hfl.location_id=l.location_id; 


-- VisitFact
SELECT pv.visit_id,
       pv.visit_pid as patient_dim_id,
       pv.procedure as procedure_dim_id,
       hf.h_id as health_facility_dim_id_fac,
       l.location_id as health_facility_dim_id_loc,
       pv.visit_date,
       pv.procedure_by as employee_dim,
       pv.rating,
       pv.payment
FROM HealthFacilities hf
INNER JOIN HealthFacilityLocations hfl ON hf.h_id=hfl.h_id
INNER JOIN Locations l ON hfl.location_id=l.location_id
INNER JOIN PatientVisits pv ON hf.h_id=pv.visit_hid; 





















