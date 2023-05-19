-- Student Number(s):	
-- Student Name(s):		



-- ***********************************************************************************************************
-- 1. Database creation and population
-- 
-- We first check if the database exists, and drop it if it does.
-- Setting the active database to the built in 'master' database ensures that we are not trying to drop the currently active database.
-- Setting the database to 'single user' mode ensures that any other scripts currently using the database will be disconnectetd.
-- This allows the database to be deleted, instead of giving a 'database in use' error when trying to delete it.
--
-- ***********************************************************************************************************


IF DB_ID('Medical_Management') IS NOT NULL
	BEGIN
		PRINT 'Database exists - dropping.';

		USE master;
		ALTER DATABASE Medical_Management
		SET SINGLE_USER 
		WITH ROLLBACK IMMEDIATE;

		DROP DATABASE Medical_Management;
	END
GO


--  Now that we are sure the database does not exist, we create it.

PRINT 'Creating database.';

CREATE DATABASE Medical_Management;

GO

--  Now that an empty database has been created, we will make it the active one.
--  The table creation statements that follow will therefore be executed on the newly created database.

USE Medical_Management;

GO



--  ***********************************************************************************************************
--  We now create the tables in the database.



--  *********************************************************************************************************
--  Create the staff table to hold staff information for clinic.
--  TODO. Which tables have foreign key referencing this table????????

PRINT 'Creating staff table...';

DROP TABLE IF EXISTS staff
GO
CREATE TABLE staff
(
	staff_id			INT NOT NULL PRIMARY KEY,
	first_name			VARCHAR(100) NOT NULL,
	last_name			VARCHAR(100) NOT NULL,
	gender				VARCHAR(20)  NOT NULL, 
	dateOfBirth			DATE NOT NULL, 
	phone_number		VARCHAR(20)  NOT NULL, 
	email				VARCHAR(100) NOT NULL,
	address				VARCHAR(200), 

	roleType			VARCHAR(50) NOT NULL, 
	job_title			VARCHAR(50) NOT NULL, 
	hire_date			DATE NOT NULL, 
    years_of_experience TINYINT NOT NULL, 
    certifications      VARCHAR(200), 	
	languages			VARCHAR(200)
);


--  ************************************************************************************************************************
--  Create the family table to hold family information for the patient and primary doctor information.
--  TODO. Which tables have foreign key referencing this table????????

DROP TABLE IF EXISTS family
GO

PRINT 'Creating family table...';

CREATE TABLE family
(
	family_id						INT NOT NULL PRIMARY KEY,
	physician_id					INT NOT NULL,			-- primary care physician for this family.

	headmember_first_name			VARCHAR(100) NOT NULL,
	headmember_last_name			VARCHAR(100) NOT NULL,
	headmember_phone_number			VARCHAR(20)  NOT NULL, 
	headmember_email				VARCHAR(100) NOT NULL, 
	headmember_address				VARCHAR(200) NOT NULL, 

	FOREIGN KEY (physician_id) REFERENCES staff (staff_id)
);


--  ************************************************************************************************************************
--  Create the patient table to hold patient information for whom visit doctors in this clinic.
--  TODO. Which tables have foreign key referencing this table????????

PRINT 'Creating patient table...';

DROP TABLE IF EXISTS patient
GO
CREATE TABLE patient
(
	patient_id				INT NOT NULL PRIMARY KEY,	  
	first_name				VARCHAR(100) NOT NULL,
	last_name				VARCHAR(100) NOT NULL,
	gender					VARCHAR(10) NOT NULL, 
	dateOfBirth				DATE NOT NULL, 	
	phone_number			VARCHAR(20)  NOT NULL, 
	email					VARCHAR(100) NOT NULL,  
	address					VARCHAR(200) NOT NULL, 

	emergency_contact_number	VARCHAR(20) NOT NULL,
	emergency_contact_fstname	VARCHAR(100) NOT NULL,
	emergency_contact_lstname	VARCHAR(100) NOT NULL,
	family_id					INT NOT NULL

	FOREIGN KEY (family_id) REFERENCES family (family_id),
);


--  ************************************************************************************************************************
--  Create the appointment table to hold appointment information for patients.
--  TODO. Which tables have foreign key referencing this table????????

PRINT 'Creating appointment table...';

DROP TABLE IF EXISTS appointment
GO
CREATE TABLE appointment
( 
    appointment_id			INT NOT NULL PRIMARY KEY, 
    doctor_id				INT NOT NULL, 
    patient_id				INT NULL, 				-- If it is a new patient, their infomation is recorded at the first time they visit the doctor
	nurse_id				INT NULL,				-- Maybe no assistant nurse.
	receptionist_id			INT NOT NULL,			-- Mark receptionist who create this appointment.

	first_name				VARCHAR(100) NOT NULL,
	last_name				VARCHAR(100) NOT NULL,
	phone_number			VARCHAR(20)  NOT NULL, 
	email					VARCHAR(100) NOT NULL,  
    appointment_date		DATE NOT NULL, 
    appointment_time		TIME NOT NULL, 
    appointment_notes		VARCHAR(255) NOT NULL,  -- consulting type;symptoms;...

    FOREIGN KEY (patient_id) REFERENCES patient (patient_id), 
    FOREIGN KEY (doctor_id)  REFERENCES staff (staff_id),
	FOREIGN KEY (nurse_id) 	 REFERENCES staff (staff_id),
	FOREIGN KEY (receptionist_id) REFERENCES staff (staff_id)
); 




--  ************************************************************************************************************************
--  Create the diagnosis table to hold the diagnosis information for a patient in each visit.

PRINT 'Creating diagnosis table...';

DROP TABLE IF EXISTS diagnosis
GO
CREATE TABLE diagnosis
(
  	diagnosis_id 				INT NOT NULL PRIMARY KEY,
  	appointment_id				INT NOT NULL,
  	patient_id 					INT NOT NULL,
  	doctor_id 					INT NOT NULL,
  	nurse_id					INT NULL,				-- Maybe no assistant nurse.
  	symptoms					VARCHAR(255) NOT NULL,
  	diagnosis_date 				DATETIME NOT NULL,
  	diagnosis_description 		VARCHAR(255) NOT NULL,
  	treatment_description		VARCHAR(255) NOT NULL,


  	FOREIGN KEY (appointment_id) REFERENCES appointment (appointment_id),
  	FOREIGN KEY (patient_id) REFERENCES patient (patient_id),
  	FOREIGN KEY (doctor_id) REFERENCES staff (staff_id),
  	FOREIGN KEY (nurse_id) REFERENCES staff (staff_id),
);



--  ************************************************************************************************************************
--  Create the medication_item table to hold the information of medication that are used to treat and cure illness.
--  TODO. Which tables have foreign key referencing this table????????

PRINT 'Creating medication table...';

DROP TABLE IF EXISTS medication
GO
CREATE TABLE medication
( 
    medication_id			INT NOT NULL PRIMARY KEY, 
    medication_name			VARCHAR(255) NOT NULL, 
    description				VARCHAR(255) NOT NULL, 
    dosage					VARCHAR(255) NOT NULL, 
	special_instructions	VARCHAR(255) NOT NULL, 
	side_effects			VARCHAR(255) NOT NULL, 
	manufacturer			VARCHAR(255) NOT NULL, 
	production_date 		DATE NOT NULL, 
  	expire_date 			DATE NOT NULL,
    price					DECIMAL(10,2) NOT NULL, 

); 


--  ************************************************************************************************************************
--  Create the prescription table to hold the prescription information for patients.  
--  TODO. Which tables have foreign key referencing this table????????

PRINT 'Creating prescription table...';

DROP TABLE IF EXISTS prescription
GO
CREATE TABLE prescription
( 
 	prescription_id 			INT NOT NULL PRIMARY KEY, 
  	dosage 						VARCHAR(255) NOT NULL, 
  	start_date 					DATE NOT NULL, 
  	end_date 					DATE NOT NULL, 
  	description 				VARCHAR(255), 
  	diagnosis_id     			INT NOT NULL,

  	FOREIGN KEY (diagnosis_id) REFERENCES diagnosis (diagnosis_id) 

); 


--  ************************************************************************************************************************
--  Create the junction table to hold the a many-to-many relationship between the Prescription and Medication tables. 

PRINT 'Creating a junction table - Prescription_Medication table...';

DROP TABLE IF EXISTS prescription_medication
GO
CREATE TABLE prescription_medication 
(
	prescription_id 			INT NOT NULL,
	medication_id 				INT NOT NULL,
	quantity 					INT NOT NULL,
  
  	-- This constraint indicates that the combination of 'prescription_id' and 'medication_id' columns
  	-- will be unique and used as the primary key for the table.
  	CONSTRAINT pm_pk PRIMARY KEY (prescription_id, medication_id),

  	CONSTRAINT pm_fk_prescription FOREIGN KEY (prescription_id) REFERENCES Prescription (prescription_id),
  	CONSTRAINT pm_fk_medication FOREIGN KEY (medication_id) REFERENCES Medication (medication_id)
);





--  **************************************************************************************
--  Now that the database tables have been created, we can populate them with data


PRINT 'Populating staff table...';

INSERT INTO staff 
(staff_id, first_name, last_name, gender, dateOfBirth, phone_number, email, address,
 roleType, job_title, hire_date, years_of_experience, certifications, languages)
VALUES
(1, 'John', 'Doe', 'Male', '1980-01-01', '123-456-7890', 'johndoe@example.com', '123 Main St, town1, USA', 'Doctor', 'Doctor', '2010-01-01', 10, 'American Board of Internal Medicine', 'English, Spanish'),
(2, 'Jane', 'Smith', 'Female', '1985-02-02', '987-654-3210', 'janesmith@example.com', '456 Oak St, town2, USA', 'Nurse', 'Nurse', '2015-01-01', 5, 'RN', 'English'),
(3, 'Bob', 'Johnson', 'Female', '1990-03-03', '555-555-1212', 'bobjohnson@example.com', '789 Pine St, town3, USA', 'Doctor', 'Doctor', '2014-01-01', 7, 'American Board of Pediatrics', 'English'),
(4, 'Alice', 'Brown', 'Female', '1995-04-04', '111-222-3333', 'alicebrown@example.com', '101 Elm St, town4, USA', 'Receptionist', 'Front Desk Receptionist', '2020-01-01', 1, '', 'English, French'),
(5, 'David', 'Lee', 'Male', '1980-05-05', '222-333-4444', 'davidlee@example.com', '202 Maple St, town5, USA', 'Doctor', 'Doctor', '2010-01-01', 10, 'American Board of Orthopaedic Surgery', 'English, Japanese, Mandarin'),
(6, 'Megan', 'Kim', 'Female', '1990-06-06', '444-555-6666', 'megankim@example.com', '303 Walnut St, town6, USA', 'Nurse', 'Nurse', '2015-01-01', 5, 'RN', 'English, Korean'),
(7, 'Charlie', 'Chen', 'Male', '1985-07-07', '777-777-7777', 'charliechen@example.com', '404 Chestnut St, town7, USA', 'Doctor', 'Doctor', '2014-01-01', 7, 'American Board of Internal Medicine', 'English, Spanish'),
(8, 'Lily', 'Wong', 'Female', '1995-08-08', '888-888-8888', 'lilywong@example.com', '505 Hickory St, town8, USA', 'Nurse', 'Nurse', '2010-01-01', 10, 'American Board of Internal Medicine, American Board of Medical Oncology', 'English, Cantonese'),
(9, 'Kevin', 'Park', 'Male', '1980-09-09', '999-999-9999', 'kevinpark@example.com', '606 Cedar St, town9, USA', 'Nurse', 'Nurse', '2014-01-01', 7, 'American Board of Dermatology', 'English, Korean, Japanese'),
(10, 'Olivia', 'Garcia', 'Female', '1990-05-05', '555-555-5555', 'oliviagarcia@example.com', '123 Main St', 'Nurse', 'Registered Nurse', '2015-01-01', 5, 'RN', 'English, Spanish'),
(11, 'William', 'Martinez', 'Male', '1975-06-06', '555-555-3454', 'williammartinez@example.com', '123 Main St', 'Receptionist', 'Receptionist', '2005-01-01', 15, 'MD', 'English, Spanish'),
(12, 'Sophia', 'Robinson', 'Female', '1985-07-07', '555-555-6577', 'sophiarobinson@example.com', '123 Main St', 'Receptionist', 'Receptionist', '2010-01-01', 10, 'MD', 'English, French'),
(13, 'Joseph', 'Clark', 'Male', '1990-08-08', '555-555-8543', 'josephclark@example.com', '123 Main St', 'Receptionist', 'Receptionist', '2006-04-17', 10, 'MD', 'English, French');



PRINT 'Populating family table...';

-- Family table
INSERT INTO family
(family_id, physician_id, headmember_first_name, headmember_last_name, 
	headmember_phone_number, headmember_email, headmember_address)
VALUES
(1, 1, 'William', 'Smith', '111-111-1111', 'williamsmith@gmail.com', '123 Main St'),
(2, 1, 'Linda', 'Johnson', '222-222-2222', 'lindajohnson@gmail.com', '456 Oak St'),
(3, 3, 'Lisa', 'Wilson', '222-222-2222', 'lindajohnson@gmail.com', '456 Oak St'),
(4, 3, 'Linda', 'Jones', '222-222-2222', 'lindajohnson@gmail.com', '456 Oak St'),
(5, 5, 'Amy', 'Lee', '222-222-2222', 'amylee@example.com', '456 Oak St'),
(6, 7, 'Matthew', 'Davis', '222-222-2222', 'matthewdavis@example.com', '456 Oak St');




PRINT 'Populating patient table...';

INSERT INTO patient 
(patient_id, first_name, last_name, gender, dateOfBirth, phone_number, email, address,
 emergency_contact_number, emergency_contact_fstname, emergency_contact_lstname, family_id)
VALUES 
(1, 'John', 'Doe', 'Male', '1980-06-15', '123-456-7890', 'johndoe@example.com', '123 Main St', '111-222-3333', 'Jane', 'Doe', 1),
(2, 'Jane', 'Doe', 'Female', '1985-08-10', '555-555-1212', 'janedoe@example.com', '456 Elm St', '333-444-5555', 'John', 'Doe', 1),
(3, 'Michael', 'Smith', 'Male', '1977-04-23', '555-123-4567', 'michaelsmith@example.com', '789 Oak Ave', '777-888-9999', 'Samantha', 'Smith', 2),
(4, 'Samantha', 'Smith', 'Female', '1982-09-12', '555-987-6543', 'samanthasmith@example.com', '321 Pine St', '222-333-4444', 'Michael', 'Smith', 2),
(5, 'David', 'Jones', 'Male', '1995-01-07', '555-111-2222', 'davidjones@example.com', '555 Cedar Ln', '444-555-6666', 'Emily', 'Jones', 4),
(6, 'Emily', 'Jones', 'Female', '1997-11-30', '555-444-3333', 'emilyjones@example.com', '777 Maple Rd', '777-777-7777', 'David', 'Jones', 4),
(7, 'Christopher', 'Lee', 'Male', '1988-03-01', '555-555-5555', 'chrislee@example.com', '444 Birch St', '888-999-0000', 'Amy', 'Lee', 5),
(8, 'Amy', 'Lee', 'Female', '1991-12-13', '555-222-3333', 'amylee@example.com', '555 Oak Ave', '444-555-6666', 'Christopher', 'Lee', 5),
(9, 'Matthew', 'Davis', 'Male', '1979-07-20', '555-777-8888', 'matthewdavis@example.com', '222 Pine St', '333-444-5555', 'Jennifer', 'Davis', 6),
(10, 'Jennifer', 'Davis', 'Female', '1983-10-05', '555-666-7777', 'jenniferdavis@example.com', '999 Oak Ave', '222-333-4444', 'Matthew', 'Davis', 6),
(11, 'Mark', 'Wilson', 'Male', '1990-02-15', '555-999-0000', 'markwilson@example.com', '444 Maple Ln', '111-222-3333', 'Lisa', 'Wilson', 3),
(12, 'Lisa', 'Wilson', 'Female', '1992-12-20', '555-777-6666', 'lisawilson@example.com', '777 Cedar Ave', '444-555-6666', 'Mark', 'Wilson', 3),
(13, 'Steven', 'Martin', 'Male', '1985-06-07', '555-222-1111', 'stevenmartin@example.com', '111 Pine St', '777-555-6666', 'Mark', 'Martin', 3);



PRINT 'Populating appointment table...';

INSERT INTO appointment 
(appointment_id, doctor_id, patient_id, nurse_id, receptionist_id,
 first_name, last_name, phone_number, email, appointment_date, appointment_time, appointment_notes)
VALUES
(1, 1, 1, 2, 4, 'John', 'Doe', '1234567890', 'johndoe@example.com', '2023-05-10', '10:00:00', 'Routine checkup'),
(2, 1, 2, 6, 4, 'Jane', 'Doe', '2345678901', 'janedoe@example.com', '2023-05-11', '11:30:00', 'Follow up appointment'),
(3, 3, 3, NULL, 11, 'Bob', 'Smith', '3456789012', 'bobsmith@example.com', '2023-05-12', '14:00:00', 'Physical exam'),
(4, 5, 4, NULL, 12, 'Sara', 'Johnson', '4567890123', 'sarajohnson@example.com', '2023-05-13', '15:30:00', 'New patient appointment'),
(5, 7, 5, 9, 13, 'Mike', 'Wilson', '5678901234', 'mikewilson@example.com', '2023-05-14', '9:00:00', 'Flu/headache'),
(6, 1, 1, 2, 4, 'John', 'Doe', '1234567890', 'johndoe@example.com', '2023-05-15', '10:00:00', 'Routine checkup'),
(7, 1, 3, 6, 4, 'Jane', 'Doe', '2345678901', 'janedoe@example.com', '2023-05-10', '11:30:00', 'Follow up appointment'),
(8, 3, 2, NULL, 11, 'Bob', 'Smith', '3456789012', 'bobsmith@example.com', '2023-05-17', '14:00:00', 'Physical exam'),
(9, 5, 4, NULL, 12, 'Sara', 'Johnson', '4567890123', 'sarajohnson@example.com', '2023-05-18', '15:30:00', 'New patient appointment'),
(10, 7, 5, 9, 13, 'Mike', 'Wilson', '5678901234', 'mikewilson@example.com', '2023-05-19', '9:00:00', 'Flu/headache'),
(11, 3, 6, NULL, 11, 'Bob', 'Smith', '3456789012', 'bobsmith@example.com', '2023-06-17', '14:00:00', 'Physical exam'),
(12, 5, 7, NULL, 12, 'Sara', 'Johnson', '4567890123', 'sarajohnson@example.com', '2023-06-18', '15:30:00', 'New patient appointment'),
(13, 7, 8, 9, 13, 'Mike', 'Wilson', '5678901234', 'mikewilson@example.com', '2023-06-19', '9:00:00', 'Flu/headache');


PRINT 'Populating diagnosis table...';

INSERT INTO diagnosis 
(diagnosis_id, appointment_id, patient_id, doctor_id, nurse_id,
 symptoms, diagnosis_date, diagnosis_description, treatment_description)
VALUES
(1, 1, 1, 1, NULL, 'Fever, cough, headache', '2023-05-01 09:00:00', 'Common cold', 'Bed rest and lots of fluids'),
(2, 1, 1, 1, NULL, 'Sore throat, difficulty swallowing', '2023-02-02 09:00:00', 'Eat less', 'Rest and exercise'),
(3, 2, 2, 1, 8, 'Difficulty breathing, chest pain', '2023-05-01 10:00:00', 'Pneumonia', 'Antibiotics, rest, and fluids'),
(4, 3, 3, 3, 9, 'Sore throat, difficulty swallowing', '2023-05-02 11:00:00', 'Strep throat', 'Antibiotics and pain relievers'),
(5, 4, 4, 5, 10, 'Nausea, vomiting, diarrhea', '2023-05-02 12:00:00', 'Gastroenteritis', 'Oral rehydration therapy and rest'),
(6, 5, 5, 7, NULL, 'Joint pain, fatigue', '2023-05-02 13:00:00', 'Rheumatoid arthritis', 'Nonsteroidal anti-inflammatory drugs and disease-modifying antirheumatic drugs'),
(7, 6, 1, 1, NULL, 'Fever, cough, headache', '2023-05-01 09:00:00', 'Common cold', 'Bed rest and lots of fluids'),
(8, 7, 3, 1, 8, 'Fever, chest pain', '2023-05-01 10:00:00', 'Pneumonia', 'Antibiotics, rest, and fluids'),
(9, 8, 2, 1, NULL, 'Vomiting, cough, headache', '2023-05-01 09:00:00', 'Common cold', 'Bed rest and lots of fluids'),
(10, 9, 4, 3, 9, 'Sore throat, difficulty swallowing', '2023-01-26 11:00:00', 'Strep throat', 'Pain relievers'),
(11, 10, 5, 3, 9, 'Sore throat, difficulty swallowing', '2023-05-23 10:30:00', 'Sleep more', 'Rest'),
(12, 11, 6, 7, NULL, 'Joint pain, fatigue', '2023-05-02 13:00:00', 'Rheumatoid arthritis', 'Nonsteroidal anti-inflammatory drugs and disease-modifying antirheumatic drugs'),
(13, 12, 7, 1, NULL, 'Fever, cough, headache', '2023-05-01 09:00:00', 'Common cold', 'Bed rest and lots of fluids'),
(14, 13, 8, 1, 8, 'Fever, chest pain', '2023-05-01 10:00:00', 'Pneumonia', 'Antibiotics, rest, and fluids')



PRINT 'Populating medication table...';

INSERT INTO medication 
(medication_id, medication_name, description, dosage, special_instructions,
 side_effects, manufacturer, production_date, expire_date, price)
VALUES 
(1, 'Aspirin', 'Used for pain relief and fever reduction', '500mg', 'Take with food', 'Upset stomach', 'Bayer AG', '2021-01-01', '2022-12-31', 5.99),
(2, 'Lisinopril', 'Used to treat high blood pressure and heart failure', '10mg', 'Take at the same time every day', 'Dizziness, headache, tiredness', 'AstraZeneca', '2020-02-15', '2023-02-14', 12.99),
(3, 'Ibuprofen', 'Used for pain relief, fever reduction and inflammation', '200mg', 'Take with water and food', 'Upset stomach, headache', 'Pfizer Inc', '2022-03-01', '2024-02-29', 4.99),
(4, 'Metformin', 'Used to treat type 2 diabetes', '500mg', 'Take with food', 'Stomach upset, diarrhea, headache', 'Merck & Co.', '2021-11-01', '2023-10-31', 8.99),
(5, 'Levothyroxine', 'Used to treat hypothyroidism', '100mcg', 'Take in the morning on an empty stomach', 'Weight loss, tremors, headache', 'Abbott Laboratories', '2020-07-01', '2022-06-30', 14.99);



PRINT 'Populating prescription table...';

INSERT INTO prescription
(prescription_id, dosage, start_date, end_date, description, diagnosis_id)
VALUES 
(1, '1 pill twice daily', '2022-01-01', '2022-01-07', 'For pain relief', 1),
(2, '2 pills once daily', '2022-02-02', '2022-02-28', 'For high blood pressure', 2),
(3, '1 pill at bedtime',  '2022-03-10', '2022-03-20', 'For insomnia', 3),
(4, '1 pill three times daily', '2022-04-15', '2022-04-30', 'For infection', 3),
(5, '3 pills three times daily', '2022-04-15', '2022-04-30', 'For infection', 4),
(6, '3 pills after meals', '2022-05-05', '2022-05-10', 'For digestive issues', 4),
(7, '4 pills twice daily', '2022-05-05', '2022-05-13', 'For digestive issues', 5),
(8, '2 pills after meals', '2022-05-05', '2022-05-11', 'For digestive issues', 5),
(9, '1 pill three times daily', '2022-04-15', '2022-04-30', 'For infection', 6),
(10, '3 pills twice daily', '2022-04-15', '2022-04-30', 'For infection', 7),
(11, '3 pills after meals', '2022-05-12', '2022-05-15', 'For digestive issues', 8),
(12, '4 pills after meals', '2022-05-13', '2022-05-13', 'For digestive issues', 9),
(13, '3 pills twice daily', '2022-04-15', '2022-04-30', 'For infection', 10),
(14, '3 pills after meals', '2022-05-12', '2022-05-15', 'For digestive issues', 11),
(15, '4 pills after meals', '2022-05-13', '2022-05-13', 'For digestive issues', 12);




PRINT 'Populating prescription_medication table...';

INSERT INTO prescription_medication 
(prescription_id, medication_id, quantity)
VALUES 
	(1, 3, 2),
	(1, 4, 1),
	(2, 1, 1),
	(3, 2, 3),
	(4, 2, 2),
	(4, 5, 2),
	(5, 1, 2),
	(5, 2, 3),
	(5, 5, 1),
	(6, 5, 2),
	(7, 1, 2),
	(8, 2, 3),
	(9, 5, 1),
	(10, 2, 3),
	(11, 5, 1),
	(12, 4, 1),
	(13, 1, 1),
	(14, 2, 3);



PRINT 'Finish database creation and population.';



