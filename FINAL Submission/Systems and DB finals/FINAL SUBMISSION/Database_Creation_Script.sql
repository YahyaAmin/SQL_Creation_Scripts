-- if Medical_management exists, kill current connections to Database
-- make single user
IF DB_ID('Medical_management') IS NOT NULL
	BEGIN
		USE [MASTER];

		ALTER	DATABASE Medical_management 
		SET 	SINGLE_USER
		WITH	ROLLBACK IMMEDIATE;

		DROP DATABASE Medical_management;
	END
GO

--******Create Tables*******

-- create new database called Medical_management_1
CREATE DATABASE Medical_management;
GO

USE Medical_management;
GO

-- create tables
DROP TABLE IF EXISTS [dbo].[Appointment]
GO
CREATE TABLE [dbo].[Appointment](
	[ID] [int] NOT NULL,
	[Date] [date] NULL,
	[Time] [time](7) NULL,
	[ward_no] [int] NULL,
	[Receptionist_id] [int] NULL,
	[Nurse_ID] [int] NOT NULL,
	[Doctor_id] [int] NOT NULL,
	CONSTRAINT [PK_Appointment] PRIMARY KEY CLUSTERED ([ID] ASC)
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [dbo].[Doctor]
GO
CREATE TABLE [dbo].[Doctor](
	[ID] [int] NOT NULL,
	[name] [varchar](50) NULL,
	[specialization] [varchar](50) NULL,
	CONSTRAINT [PK_Doctor] PRIMARY KEY CLUSTERED ([ID] ASC)
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [dbo].[Family_Member]
GO
CREATE TABLE [dbo].[Family_Member](
	[ID] [int] NOT NULL,
	[Head_of_family] [varchar](50) NULL,
	[total_family_member] [int] NULL,
	[Medical_Record_id] [int] NOT NULL,
	CONSTRAINT [PK_Family_Member] PRIMARY KEY CLUSTERED ([ID] ASC)
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [dbo].[Medical_Record]
GO
CREATE TABLE [dbo].[Medical_Record](
	[ID] [int] NOT NULL,
	[Test_results] [varchar](50) NULL,
	[Medical_History] [varchar](50) NULL,
	CONSTRAINT [PK_Medical_Record] PRIMARY KEY CLUSTERED ([ID] ASC)
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [dbo].[Medicine]
GO
CREATE TABLE [dbo].[Medicine](
	[ID] [nchar](10) NOT NULL,
	[name] [nchar](10) NULL,
	[manufacturer] [nchar](10) NULL,
	[potency_in_mg] [nchar](10) NULL,
	[dose] [nchar](10) NULL,
	[Prescription_id] [int] NOT NULL,
	CONSTRAINT [PK_Medicine] PRIMARY KEY CLUSTERED ([ID] ASC)
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [dbo].[Nurse]
GO
CREATE TABLE [dbo].[Nurse](
	[ID] [int] NOT NULL,
	[name] [nchar](10) NULL,
	CONSTRAINT [PK_Nurse] PRIMARY KEY CLUSTERED ([ID] ASC)
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [dbo].[Patient]
GO
CREATE TABLE [dbo].[Patient](
	[ID] [int] NOT NULL,
	[name] [varchar](50) NULL,
	[date_of_birth] [date] NULL,
	[Appointment_ID] [int] NOT NULL,
	[Medical_record_ID] [int] NOT NULL,
	[Prescription_id] [int] NOT NULL,
 CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED ([ID] ASC)
) ON [PRIMARY]
 GO
 
 
DROP TABLE IF EXISTS [dbo].[Prescription]
GO
 CREATE TABLE [dbo].[Prescription](
	[ID] [int] NOT NULL,
	[Total_no_of_medicines] [varchar](50) NULL,
	[Dosage] [varchar](50) NULL,
 CONSTRAINT [PK_Prescription] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [dbo].[Receptionist]
GO
CREATE TABLE [dbo].[Receptionist](
	[ID] [int] NOT NULL,
	[name] [varchar](50) NULL,
 CONSTRAINT [PK_Receptionist] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [dbo].[Treatment]
GO
CREATE TABLE [dbo].[Treatment](
	[ID] [int] NOT NULL,
	[treatment_type] [varchar](50) NULL,
	[duration_in_months] [varchar](50) NULL,
	[Patient_ID] [int] NOT NULL,
 CONSTRAINT [PK_Treatment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Receptionist] FOREIGN KEY([Receptionist_id])
REFERENCES [dbo].[Receptionist] ([ID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Receptionist]
GO
ALTER TABLE [dbo].[Family_Member]  WITH CHECK ADD  CONSTRAINT [FK_Family_Member_Medical_Record] FOREIGN KEY([Medical_Record_id])
REFERENCES [dbo].[Medical_Record] ([ID])
GO
ALTER TABLE [dbo].[Family_Member] CHECK CONSTRAINT [FK_Family_Member_Medical_Record]
GO
ALTER TABLE [dbo].[Medicine]  WITH CHECK ADD  CONSTRAINT [FK_Medicine_Prescription] FOREIGN KEY([Prescription_id])
REFERENCES [dbo].[Prescription] ([ID])
GO
ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [FK_Medicine_Prescription]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Medical_Record] FOREIGN KEY([Medical_record_ID])
REFERENCES [dbo].[Medical_Record] ([ID])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_Medical_Record]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Prescription1] FOREIGN KEY([Prescription_id])
REFERENCES [dbo].[Prescription] ([ID])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_Prescription1]
GO
ALTER TABLE [dbo].[Treatment]  WITH CHECK ADD  CONSTRAINT [FK_Treatment_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([ID])
GO
ALTER TABLE [dbo].[Treatment] CHECK CONSTRAINT [FK_Treatment_Patient]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Appointment] FOREIGN KEY([Appointment_id])
REFERENCES [dbo].[Appointment] ([ID])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_Appointment]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Doctor] FOREIGN KEY([Doctor_id])
REFERENCES [dbo].[Doctor] ([ID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Doctor]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Nurse] FOREIGN KEY([Nurse_id])
REFERENCES [dbo].[Nurse] ([ID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Nurse]