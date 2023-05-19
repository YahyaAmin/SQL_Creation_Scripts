-- Student Number(s):	
-- Student Name(s):		




-- **********************************************************************************************
-- 3. Queries
-- **********************************************************************************************


-- Query 1. Search male patients 
-- SELECT patient information
-- WHERE: 
-- 		gender is male 
-- Order the result by last name in ascending order.  

SELECT *  
FROM patient  
WHERE gender = 'Male'  
ORDER BY last_name ASC

 
  

-- Query 2. Get the count of appointments for each doctor:  

SELECT doctor_id, COUNT(*) AS appointment_count  
FROM appointment  
GROUP BY doctor_id  

  
  

-- Query 3. Get the list of patients who have appointments with the doctor whose staff id equals 1:  

SELECT *   
FROM patient as p JOIN appointment as ap  
ON ap.patient_id = p.patient_id  
WHERE ap.doctor_id = 1  

  


-- Query 4. Get the total number of patients in each family:  

SELECT  
	patient.family_id,
	Count(*) as number_member 
FROM patient
INNER JOIN family
ON patient.family_id = family.family_id  
GROUP BY patient.family_id 

  
  

-- Query 5. Find out the doctor who can speak Spanish and has the most years work experience   
 
SELECT top 1 * 
FROM staff  
WHERE staff.languages like '%Spanish%'  
ORDER BY staff.years_of_experience DESC 

  


-- Query 6. Medium
-- Retrieve a list of medications along with the total quantity prescribed for each medication.

SELECT
	medication.medication_id,
	medication.medication_name,
	medication.description,
	SUM(prescription_medication.quantity) AS total_quantity
FROM medication 
INNER JOIN prescription_medication 
ON medication.medication_id = prescription_medication.medication_id
GROUP BY medication.medication_id, medication.medication_name, medication.description
ORDER BY total_quantity DESC




-- Query 7. Medium






-- Query 8. High
-- Find out which doctors is available in the afternoon in the next 3 days, order by years of experience.
-- SELECT doctor id, doctor name
-- WHERE:
-- 		no appointment in the next 3 days from 12:00 pm to 4:00pm
-- Order the results by years of experience.

SELECT 
	v.doctor_id,
	v.doctor_name,
	v.gender,
	v.years_of_experience,
	v.languages
FROM  doctor_appointment_view AS v
WHERE 	( appointment_date NOT BETWEEN GETDATE() AND DATEADD(DAY, 3, GETDATE()) )   -- filters available the whole day
OR
		( appointment_date BETWEEN GETDATE() AND DATEADD(DAY, 3, GETDATE()) )     -- or available during 12:00 pm to 4:00pm
		AND DATEPART(HOUR, appointment_time) < 12

Group BY doctor_id, doctor_name, gender, years_of_experience, languages
ORDER BY years_of_experience DESC






-- Query 9. High





























  