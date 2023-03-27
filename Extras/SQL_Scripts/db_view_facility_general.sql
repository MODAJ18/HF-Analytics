-- /c hospital_oltp_db

CREATE OR REPLACE VIEW FacilityGeneralView
AS 
SELECT hf.name as health_facility,
	   hf.control_type_desc,
	   hf.license_type,
	--    l.city,
	   l.county,
	   count(p.p_id) as num_patient
FROM Patients p
INNER JOIN HealthFacilities hf ON p.p_hid=hf.h_id
INNER JOIN HealthFacilityLocations hfl ON hf.h_id=hfl.h_id
INNER JOIN Locations l ON hfl.location_id=l.location_id
GROUP BY hf.h_id, hfl.location_id, l.location_id;

-- DROP VIEW IF EXISTS FacilityGeneralView;