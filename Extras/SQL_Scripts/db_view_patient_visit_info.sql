CREATE OR REPLACE VIEW PatientVisitInfoView
AS 
SELECT p.name as patient, 
	   pv.visit_date as visited_on, 
	   hf.name as facility_visited,
	   pp.name as procedure_conducted,
	   e.section as procedure_section,
	   pp.price as procedure_cost,
	   pv.payment as treatment_cost,
	   pv.rating as visit_rating
FROM PatientVisits pv
INNER JOIN Patients p ON pv.visit_pid=p.p_id
INNER JOIN HealthFacilities hf ON pv.visit_hid=hf.h_id
INNER JOIN PatientProcedures pp ON pv.procedure=pp.pr_id
INNER JOIN Employees e ON pv.procedure_by=e.emp_id;

-- DROP VIEW IF EXISTS PatientVisitInfoView;