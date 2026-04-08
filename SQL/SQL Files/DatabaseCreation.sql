CREATE DATABASE HealthcareDB;
USE HealthcareDB;

CREATE TABLE Patients(
 PatientID INT PRIMARY KEY AUTO_INCREMENT ,
 FullName 	VARCHAR (100) NOT NULL,
 Age INT NOT NULL, 
 Gender VARCHAR(10) NOT NULL,
 Address VARCHAR(250));

CREATE TABLE Hospitals(
 HospitalID INT PRIMARY KEY AUTO_INCREMENT,
 HospitalName VARCHAR(100) NOT NULL,
 Location VARCHAR(100) NOT NULL,
 Capacity INT NOT NULL);

CREATE TABLE Admissions(
 AdmissionID INT PRIMARY KEY AUTO_INCREMENT,
 PatientID INT,
 CONSTRAINT fk_patients FOREIGN KEY(PatientID) REFERENCES Patients(PatientID),
 HospitalID INT,
 CONSTRAINT fk_hospitals FOREIGN KEY(HospitalID) REFERENCES Hospitals(HospitalID),
 AdmissionDate DATE NOT NULL,
 DischargeDate DATE,
 ReasonForAdmission VARCHAR(255));

CREATE TABLE Treatments(
 TreatmentID INT PRIMARY KEY AUTO_INCREMENT,
 AdmissionID INT,
 CONSTRAINT fk_admissions FOREIGN KEY(AdmissionID) REFERENCES Admissions(AdmissionID),
 ProcedureName VARCHAR (50) NOT NULL,
 Cost DECIMAL(10,2) NOT NULL,
 Outcome VARCHAR(50));
 