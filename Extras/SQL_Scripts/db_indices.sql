BEGIN TRANSACTION;

CREATE INDEX IF NOT EXISTS idx_HF_name ON HealthFacilities(name);
CREATE INDEX IF NOT EXISTS idx_PP_name ON PatientProcedures(name);
CREATE INDEX IF NOT EXISTS idx_E_name ON Employees(emp_name);
CREATE INDEX IF NOT EXISTS idx_HF_name ON Patients(name);
CREATE INDEX IF NOT EXISTS idx_PV_date ON PatientVisits(visit_date);

COMMIT TRANSACTION;
