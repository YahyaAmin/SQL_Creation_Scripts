-- Student Number(s):	
-- Student Name(s):		




-- **********************************************************************************************
-- 2. Views
-- **********************************************************************************************


USE Medical_Management;
GO


-- 1. Doctors_Appointments View
-- Create a view that combines 'appointment' and 'staff' tables to provide
-- a overview of a doctors' all appointments. With this view it is easier to check 
-- doctors' timetable and schedule the appointments.


DROP VIEW IF EXISTS doctor_appointment_view
GO

CREATE VIEW doctor_appointment_view AS
SELECT
	staff.staff_id AS doctor_id, 
	(staff.first_name+' '+staff.last_name) AS doctor_name,
	staff.gender,
	staff.years_of_experience,
	staff.languages,
	appointment.appointment_id, 
	appointment.appointment_date,
	appointment.appointment_time,
    appointment.patient_id, 
    appointment.first_name, 
    appointment.last_name, 
    appointment.appointment_notes
FROM staff INNER JOIN appointment
ON appointment.doctor_id = staff.staff_id
GO




-- 2. Patient medical history view
-- Create a view that combines 'patient', 'diagnosis' and 'prescription' tables
-- to provide a comprehensive overview of a patient's medical history information.


DROP VIEW IF EXISTS patient_overview
GO

CREATE VIEW patient_overview AS
SELECT
	patient.patient_id,
	patient.first_name,
	patient.last_name,
	patient.dateOfBirth,
	patient.gender,
	diagnosis.diagnosis_date,
	diagnosis.symptoms,
	diagnosis.diagnosis_description,
	diagnosis.treatment_description,
	prescription.prescription_id,
	prescription.description,
	prescription.start_date,
	prescription.end_date
FROM patient
LEFT JOIN diagnosis ON patient.patient_id = diagnosis.patient_id
LEFT JOIN prescription ON diagnosis.diagnosis_id = prescription.diagnosis_id
GO









