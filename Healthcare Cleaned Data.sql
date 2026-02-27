CREATE TABLE patients(
		Name VARCHAR(50),
		Age INT,
		Gender VARCHAR(10),
		Blood_Type VARCHAR(5),
		Medical_Condition VARCHAR(20),
		Admission DATE,
		Doctor VARCHAR(50),
		Hospital VARCHAR(50), 
		Insurance_Provider VARCHAR(50),
		Billing_Amount NUMERIC(7,2),
		Room_Number NUMERIC(4),
		Admission_Type VARCHAR(50),
		Discharge DATE,
		Medication VARCHAR(50),
		Test_Results VARCHAR(50)
)

SELECT * FROM patients

UPDATE patients
SET name = INITCAP(LOWER(name));

--find Duplicates
SELECT NAME, age, admission, hospital  , room_number,Medical_Condition,COUNT(*)
FROM PATIENTS
GROUP BY  name,admission, hospital,age ,  room_number ,Medical_Condition
HAVING COUNT(*) > 1;

--Clean Table Data And Drop Duplicates
CREATE TABLE healthcare AS
SELECT DISTINCT *
FROM patients;

DROP TABLE patients;
SELECT * FROM healthcare

--Now find Again  Duplicates        No Duplicate Value Found
SELECT NAME, age, admission, hospital  , room_number,Medical_Condition,COUNT(*)
FROM healthcare
GROUP BY  name,admission, hospital,age ,  room_number ,Medical_Condition
HAVING COUNT(*) > 1;

--New Column of Stay
ALTER TABLE healthcare
ADD COLUMN length_of_stay INT;
UPDATE healthcare
SET length_of_stay = discharge - admission;

--Check Null Values
SELECT
    COUNT(*) FILTER (WHERE name IS NULL) AS name_nulls,
    COUNT(*) FILTER (WHERE age IS NULL) AS age_nulls,
    COUNT(*) FILTER (WHERE gender IS NULL) AS gender_nulls,
    COUNT(*) FILTER (WHERE admission IS NULL) AS admission_date_nulls,
    COUNT(*) FILTER (WHERE discharge IS NULL) AS discharge_date_nulls,
    COUNT(*) FILTER (WHERE hospital IS NULL) AS hospital_nulls,
    COUNT(*) FILTER (WHERE billing_amount IS NULL) AS billing_amount_nulls
FROM healthcare;

--Total Patients
--Unique Patients
SELECT COUNT(DISTINCT name) AS unique_patients
FROM healthcare;
--Total patients
SELECT COUNT(*) AS total_patients
FROM healthcare;

--Average Patients Age
SELECT ROUND(AVG(age), 2) AS average_age
FROM healthcare;

--Top Most Patience Medical Condition
SELECT medical_condition,
       COUNT(*) AS total_cases
FROM healthcare
GROUP BY medical_condition
ORDER BY total_cases DESC
LIMIT 5;

--Top Hospital Have Most Patients
SELECT hospital,
       COUNT(DISTINCT name) AS unique_patient
FROM healthcare
GROUP BY hospital
ORDER BY unique_patient DESC
LIMIT 5;

--Age wise Analysis
SELECT 
    CASE 
        WHEN age BETWEEN 0 AND 20 THEN '0-20'
        WHEN age BETWEEN 21 AND 40 THEN '21-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count
FROM healthcare
GROUP BY age_group
ORDER BY age_group;

--Monthly Revenue Trend
SELECT 
    DATE_TRUNC('month', admission) AS month,
    SUM(billing_amount) AS total_revenue
FROM healthcare
GROUP BY month
ORDER BY month;

--Top10 Doctors Revenue Wise
SELECT 
    doctor,
    SUM(billing_amount) AS total_revenue
FROM healthcare
GROUP BY doctor
ORDER BY total_revenue DESC
LIMIT 10;

--Hospital Rank With Revanue
SELECT 
    hospital,
    SUM(billing_amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(billing_amount) DESC) AS revenue_rank
FROM healthcare
GROUP BY hospital

--Running total of revenue month-wise.
SELECT 
    DATE_TRUNC('month', admission) AS month,
    SUM(billing_amount) AS total_revenue
FROM healthcare
GROUP BY month
ORDER BY month;
ORDER BY revenue_rank;
