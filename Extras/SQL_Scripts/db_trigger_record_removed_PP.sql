BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS RemovedPatientProcedures (
   id INT GENERATED ALWAYS AS IDENTITY,
   pr_id VARCHAR(20),
   pr_name VARCHAR(150),
   removed_on TIMESTAMP(6) NOT NULL
);

CREATE OR REPLACE FUNCTION add_removed_patient_procedure()
  RETURNS TRIGGER 
  AS
$$
BEGIN
    INSERT INTO RemovedPatientProcedures(pr_id, pr_name, removed_on)
    VALUES(OLD.pr_id, OLD.name, now());

	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER remove_patient_procedure
  BEFORE DELETE
  ON PatientProcedures
  FOR EACH ROW
  EXECUTE PROCEDURE add_removed_patient_procedure();

-- INSERT INTO 
--     PatientProcedures (pr_id, name, description, type, price)
-- VALUES
--     ('XXXXXXXDCA31a13', 'Dx_Congenital_anomalies', 'comprise a wide range of abnormalities of body structure or function that are present at birth and are of prenatal origin. For efficiency and practicality, the focus is commonly on major structural anomalies. These are defined as structural changes that have significant medical, social or cosmetic consequences for the affected individual, and typically require medical intervention. early detection of these congenital anomalies is vital and can be achieved through fetal ultrasonography. Studies have proven that antenatal ultrasound can successfully diagnose fetal abnormalities in many cases and therefore aid in counseling of parents and planning for early intervention.',
--         'diagnosis', '410');

-- DELETE FROM PatientProcedures
-- WHERE pr_id = 'XXXXXXXDCA31a13';

COMMIT TRANSACTION;

-- DROP TRIGGER IF EXISTS remove_patient_procedure ON PatientProcedures;
