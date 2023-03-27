BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS patient_visit_reschedule (
   id INT GENERATED ALWAYS AS IDENTITY,
   patient_id varchar(30) NOT NULL,
   last_visit_date DATE,
   new_visit_date DATE,
   changed_on TIMESTAMP(6) NOT NULL
);

CREATE OR REPLACE FUNCTION log_schedule_change()
  RETURNS TRIGGER 
  AS
$$
BEGIN
	IF NEW.visit_date <> OLD.visit_date THEN
		 INSERT INTO patient_visit_reschedule(patient_id, last_visit_date,
                                                new_visit_date, changed_on)
		 VALUES(OLD.visit_id, OLD.visit_date, NEW.visit_date, now());
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER schedule_change
  AFTER UPDATE
  ON PatientVisits
  FOR EACH ROW
  EXECUTE PROCEDURE log_schedule_change();


-- UPDATE PatientVisits
-- SET visit_date = '2020-09-01 01:23:21'
-- WHERE visit_id = '202111-HG-370955155937675';

COMMIT TRANSACTION;

-- DROP TRIGGER IF EXISTS schedule_change ON PatientVisits;