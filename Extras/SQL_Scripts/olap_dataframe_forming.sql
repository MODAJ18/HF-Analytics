SELECT vf.visit_id,
	   ppd.pr_id,
	   hfd.oshpd_id2,
	   hfd.location_id,
	   pd.p_id,
	   ed.emp_id,
	   ppd.name as procedure_name,
	   ppd.type as procedure_type,
	   ppd.price as procedure_price,
	   hfd.name as health_facility_name,
	   hfd.city as health_facility_city,
	   hfd.county as health_facility_county,
	   hfd.license_type as health_facility_license_type,
	   pd.name as patient_name,
	   pd.date_of_birth as patient_dob,
	   ed.emp_name as employee_name,
	   ed.section as employee_section,
	   ed.specialty as employee_specialty,
	   vf.visit_date,
	   vf.payment as visit_payment,
	   vf.rating as visit_rating
FROM VisitFact vf
INNER JOIN PatientProcedureDim ppd ON vf.procedure_dim_id = ppd.pr_id
INNER JOIN HealthFacilityDim hfd ON (vf.health_facility_dim_id_fac=hfd.oshpd_id2) AND (vf.health_facility_dim_id_loc=hfd.location_id)
INNER JOIN PatientDim pd ON vf.patient_dim_id=pd.p_id
INNER JOIN EmployeeDim ed ON vf.employee_dim_id=ed.emp_id;  