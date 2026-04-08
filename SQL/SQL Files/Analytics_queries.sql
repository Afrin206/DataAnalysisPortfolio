USE healthcaredb;

-- Patient Demographics Analysis
DESCRIBE patients;
SELECT Gender, COUNT(PatientID) AS Total_Patients, AVG(Age) AS Avg_Age
FROM patients
GROUP BY Gender;

-- Hospital Admission Volume Analysis
DESCRIBE hospitals;
DESCRIBE admissions;
SELECT h.HospitalName , 
 COUNT(a.AdmissionID) AS Total_Admissions
FROM hospitals h
JOIN admissions a
ON h.HospitalID = a.HospitalID
GROUP BY h.HospitalName
ORDER BY Total_Admissions DESC;

-- Total Costpert Per Hospital Analysis
DESCRIBE treatments;
DESCRIBE admissions;
SELECT h.HospitalName, SUM(t.Cost) as Total_Cost
FROM admissions a 
JOIN treatments t 
ON a.AdmissionID = t.AdmissionID
JOIN hospitals h
ON a.HospitalID = h.HospitalID
Group BY h.HospitalName;

-- Length Of Stay Analysis
SELECT h.HospitalName, COUNT(a.AdmissionID),
ROUND(AVG(DATEDIFF(COALESCE(a.DischargeDate , CURRENT_DATE), a.AdmissionDate))) AS AVG_Stay
FROM admissions a
JOIN hospitals h
ON a.HospitalID = h.HospitalID
WHERE a.DischargeDate IS NOT NULL
GROUP BY HospitalName;

-- Advance Filtering (Patients who stayed longer than 7 days in any hospital)
SELECT p.FullName, a.HospitalID, 
DATEDIFF(coalesce(DischargeDate, CURRENT_DATE), AdmissionDate) AS Total_Stay
FROM admissions a
Join patients p 
ON a.PatientID= p.PatientID
WHERE a.DischargeDate IS NOT NULL AND DATEDIFF(coalesce(DischargeDate, CURRENT_DATE), AdmissionDate) >7;

-- Advance Filtering (treatments that have been performed more than 5 times across all hospitals)
SELECT ProcedureName,
 COUNT(*) AS Frequency
FROM treatments
GROUP BY ProcedureName
HAVING COUNT(*) > 5;

-- Combining Data (Combine admission and treatment data to display complete patient histories)
SELECT p.FullName,
	   h.HospitalName,
       a.AdmissionDate,
       a.DischargeDate,
       t.ProcedureName,
       t.Cost
FROM patients p 
JOIN admissions a ON p.PatientID = a.PatientID
JOIN hospitals h ON a.HospitalID = h.HospitalID
JOIN treatments t ON a.AdmissionID = t.AdmissionID;

-- Combining Data (Combine lists of patients admitted for different reasons (e.g., surgery and therapy))
   -- Method-01 (UNION):
SELECT p.FullName,
       a.ReasonForAdmission
FROM patients p
JOIN admissions a ON p.PatientID = a.PatientID
WHERE a.ReasonForAdmission = "surgery"
UNION
SELECT p.FullName,
       a.ReasonForAdmission
FROM patients p
JOIN admissions a ON p.PatientID = a.PatientID
WHERE a.ReasonForAdmission = "therapy";

   -- Method-02 (IN OPERATOR):
SELECT p.FullName,
       a.ReasonForAdmission
FROM patients p
JOIN admissions a ON p.PatientID = a.PatientID
WHERE a.ReasonForAdmission IN("surgery", "therapy");

-- Subqueries and Views(subquery to find the hospital with the highest average treatment cost)
SELECT HospitalName
FROM Hospitals
WHERE HospitalID = (
    SELECT a.HospitalID
    FROM Admissions a
    JOIN Treatments t ON a.AdmissionID = t.AdmissionID
    GROUP BY a.HospitalID
    ORDER BY AVG(t.Cost) DESC
    LIMIT 1
);

-- Subqueries and Views(Create a view named HospitalPerformance to display the total number of admissions,average length of stay, and total revenue generated for each hospital.)
CREATE VIEW HospitalPerformance AS
SELECT 
    h.HospitalName,
    COUNT(a.AdmissionID) AS TotalAdmissions,
    AVG(DATEDIFF(a.DischargeDate, a.AdmissionDate)) AS AvgStay,
    SUM(t.Cost) AS TotalRevenue
FROM Hospitals h
JOIN Admissions a ON h.HospitalID = a.HospitalID
JOIN Treatments t ON a.AdmissionID = t.AdmissionID
GROUP BY h.HospitalName;
 SELECT *FROM HospitalPerformance;
 
 -- Window Functions(Use the RANK function to rank hospitals based on their total revenue)
 SELECT 
    HospitalName,
    TotalRevenue,
    RANK() OVER (ORDER BY TotalRevenue DESC) AS RankByRevenue
FROM HospitalPerformance;

-- Window Functions(Use DENSE_RANK to rank treatments based on their frequency)
SELECT 
    ProcedureName,
    COUNT(*) AS Frequency,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS RankByFrequency
FROM Treatments
GROUP BY ProcedureName;