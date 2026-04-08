# 🏥 Healthcare SQL Analytics Project

---

## 📌 Overview

A structured SQL project that models and analyzes real-world healthcare data. It covers relational database design, data insertion, and a range of queries — from basic aggregations to advanced subqueries, views, and window functions — to extract meaningful insights across patients, hospitals, admissions, and treatments.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| MySQL | Database engine |
| SQL | Querying, aggregation, views, subqueries |

**SQL concepts used:** JOINs · Aggregations · Subqueries · Views · Window Functions · UNION · Advanced Filtering

---

## 📂 Database Schema

| Table | Columns |
|-------|---------|
| **Patients** | patient_id, name, age, gender, city, blood_type |
| **Hospitals** | hospital_id, name, location, capacity, department |
| **Admissions** | admission_id, patient_id, hospital_id, admit_date, discharge_date, reason |
| **Treatments** | treatment_id, admission_id, procedure, cost, outcome |

---

## 📊 Key Analyses Performed

- Patient demographic analysis (age, gender, city distribution)
- Hospital utilization and capacity tracking
- Treatment cost evaluation across hospitals
- Length of stay analysis per admission
- Advanced filtering using `WHERE`, `HAVING`, and `CASE`
- Subquery-based insights for comparative metrics
- View creation for simplified, reusable reporting
- Combining datasets using `UNION`
- Window functions for ranking and running totals

---

## 🔍 Highlight Queries & Outputs

### 1️⃣ Hospital Performance Analysis — `VIEW`

> Creates a view named `HospitalPerformance` to display total admissions, average stay, and total revenue per hospital.

```sql
CREATE VIEW HospitalPerformance AS
SELECT
    h.HospitalName,
    COUNT(a.AdmissionID)                              AS TotalAdmissions,
    AVG(DATEDIFF(a.DischargeDate, a.AdmissionDate))   AS AvgStay,
    SUM(t.Cost)                                       AS TotalRevenue
FROM Hospitals h
JOIN Admissions a ON h.HospitalID = a.HospitalID
JOIN Treatments t ON a.AdmissionID = t.AdmissionID
GROUP BY h.HospitalName;

SELECT * FROM HospitalPerformance;
```

**Output:**

| HospitalName | TotalAdmissions | AvgStay | TotalRevenue |
|---|---|---|---|
| General Hospital | 2 | 4.0000 | 5500.00 |
| City Clinic | 2 | 4.0000 | 1100.00 |
| Central Medical Center | 2 | 5.0000 | 8000.00 |
| Regional Health Facility | 2 | 11.0000 | 1400.00 |
| Sunrise Hospital | 2 | 10.5000 | 1200.00 |

📸 ![Subquery Result](Screenshots/Subquery.png)

---

### 2️⃣ Combining Patient Lists — `UNION`

> Combines lists of patients admitted for different reasons (surgery and therapy) into a single result set.

```sql
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
```

**Output:**

| FullName | ReasonForAdmission |
|---|---|
| John Doe | Surgery |
| Alice Johnson | Surgery |
| Jane Smith | Therapy |
| Michael Scott | Therapy |

📸 ![Union Output](Screenshots/UNION.png)

---

### 3️⃣ Advanced Filtering — `WHERE` + `DATEDIFF`

> Retrieves patients who stayed longer than 7 days in any hospital.

```sql
SELECT p.FullName,
       a.HospitalID,
       DATEDIFF(coalesce(DischargeDate, CURRENT_DATE), AdmissionDate) AS Total_Stay
FROM admissions a
JOIN patients p ON a.PatientID = p.PatientID
WHERE a.DischargeDate IS NOT NULL
  AND DATEDIFF(coalesce(DischargeDate, CURRENT_DATE), AdmissionDate) > 7;
```

**Output:**

| FullName | HospitalID | Total_Stay |
|---|---|---|
| Michael Scott | 4 | 15 |
| Sarah Taylor | 5 | 14 |

📸 ![Filtering Output](Screenshots/AdvanceFiltering.png)

---

### 4️⃣ Window Function — `DENSE_RANK`

> Ranks treatments based on their frequency using a window function.

```sql
SELECT
    ProcedureName,
    COUNT(*) AS Frequency,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS RankByFrequency
FROM Treatments
GROUP BY ProcedureName;
```

**Output:**

| ProcedureName | Frequency | RankByFrequency |
|---|---|---|
| Appendectomy | 1 | 1 |
| Physical Therapy | 1 | 1 |
| Fracture Repair | 1 | 1 |
| Blood Test | 1 | 1 |
| Antibiotics | 1 | 1 |
| Gallbladder Surgery | 1 | 1 |
| X-Ray | 1 | 1 |
| Chemotherapy | 1 | 1 |
| MRI Scan | 1 | 1 |
| Diabetes Treatment | 1 | 1 |

📸 ![Dense Rank Output](Screenshots/DenseRank.png)

---

## 📄 Project Documentation

Detailed problem statement and dataset reference: [View Document](Docs/HealthcareAnalytics.pdf)

---

## 🚀 Key Learnings

- ✅ Built a normalized relational database from scratch
- ✅ Applied multi-table JOIN operations (INNER, LEFT)
- ✅ Used aggregation functions (`SUM`, `AVG`, `COUNT`) for analytical insights
- ✅ Implemented subqueries for layered, comparative problem solving
- ✅ Created reusable SQL views for simplified reporting
- ✅ Understood practical differences between `UNION`, `IN`, and `JOIN`
- ✅ Applied window functions for ranking and cumulative metrics
- ✅ Used `WHERE` vs `HAVING` for pre- and post-aggregation filtering

---

## 📌 Conclusion

This project demonstrates how SQL can transform raw healthcare records into actionable clinical and operational insights — from tracking hospital revenue trends to identifying high-cost treatment patterns — reflecting real-world data analytics workflows.

---

> 💡 *Feel free to fork this project and extend it with stored procedures, triggers, or a connected dashboard using Power BI / Tableau.*
