CREATE OR REPLACE VIEW  FacilityPerformanceView
AS 
SELECT hf.name, 
	   count(DISTINCT p.p_id) as registered_patient_num, 
	   ROUND(avg(DISTINCT pv.payment), 2) as average_payment, 
	   ROUND(avg(DISTINCT pv.rating), 1) as average_rating
FROM HealthFacilities hf
INNER JOIN PatientVisits pv ON hf.h_id=pv.visit_hid
INNER JOIN Patients p on hf.h_id=p.p_hid
WHERE visit_date IS NOT NULL
GROUP BY hf.h_id;

-- DROP VIEW IF EXISTS FacilityPerformanceView;