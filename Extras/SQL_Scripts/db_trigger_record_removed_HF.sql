BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS RemovedHealthFacilities (
   id INT GENERATED ALWAYS AS IDENTITY,
   h_id INT,
   h_name VARCHAR(250),
   removed_on TIMESTAMP(6) NOT NULL
);

-- CREATE TABLE IF NOT EXISTS RemovedPatientProcedures (
--    id INT GENERATED ALWAYS AS IDENTITY,
--    h_id INT,
--    h_name VARCHAR(250),
--    removed_on TIMESTAMP(6) NOT NULL
-- );

CREATE OR REPLACE FUNCTION add_removed_health_facility()
  RETURNS TRIGGER 
  AS
$$
BEGIN
    INSERT INTO RemovedHealthFacilities(h_id, h_name, removed_on)
    VALUES(OLD.h_id, OLD.name, now());

	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER remove_health_facility
  BEFORE DELETE
  ON HealthFacilities
  FOR EACH ROW
  EXECUTE PROCEDURE add_removed_health_facility();

-- INSERT INTO 
--     HealthFacilities (h_id, oshpd_id, name, control_type_desc, control_type_category_desc,
--                       mssa_name, mssa_designation, license_type)
-- VALUES
--     ('106370674', '370673','RADY CHILDRENS HOSPITAL - SAN DIEGO', 'Nonprofit - Corporation',
--     'Nonprofit', 'Bay Park/Five Points/Hillcrest Northwest/Mission Hills/Mission Valley/Morena/Normal Heights/Old Town/Serra Mesa',
--     'Urban', 'Hospital');

-- DELETE FROM HealthFacilities
-- WHERE h_id = '106370674';

COMMIT TRANSACTION;

-- DROP TRIGGER IF EXISTS remove_health_facility ON HealthFacilities;

