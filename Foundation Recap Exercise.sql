/*
Foundation Recap Exercise

Use the table PatientStay.  
This lists 44 patients admitted to London hospitals over 5 days between Feb 26th and March 2nd 2024
*/

SELECT
	*
FROM
	PatientStay ps



/*
1. List the patients -
a) in the Oxleas or PRUH hospitals and
b) admitted in February 2024
c) only the Surgery wardsal

2. Show the PatientId, AdmittedDate, DischargeDate, Hospital and Ward columns only, not all the columns.
3. Order results by AdmittedDate (latest first) then PatientID column (high to low)
4. Add a new column LengthOfStay which calculates the number of days that the patient stayed in hospital, inclusive of both admitted and discharge date.
*/
-- Write the SQL statement here
SELECT
	ps.PatientId
	,ps.AdmittedDate
	,ps. DischargeDate
	,ps. Hospital
	,ps. Ward
	,DATEDIFF(DAY, ps.AdmittedDate, ps.DischargeDate) +1 AS LengthOfStay
FROM
	PatientStay ps
WHERE ps.Hospital IN ('Oxleas', 'PRUH')
	AND ps.AdmittedDate BETWEEN '2024-02-01' AND '2024-02-29'
	AND ps.Ward LIKE '%Surgery'
ORDER BY ps.AdmittedDate DESC, ps.PatientId DESC


/*
5. How many patients has each hospital admitted?  - CountOfPatients
6. How much is the total tarriff for each hospital?
7. List only those hospitals that have admitted over 10 patients
8. Order by the hospital with most admissions first
*/

-- Write the SQL statement here
--How many patients has each hospital admitted?
SELECT
	COUNT(*) AS [Number Of Patients]
FROM
	PatientStay ps

/*

--How much is the total tariff for each hospital
*/
SELECT
	ps.Hospital
,SUM(ps.Tariff) AS TotalTariff
FROM
	PatientStay ps
GROUP BY ps.Hospital
/*

--Total number of patients and Total Tarriff
*/
SELECT	
	ps. Hospital
	, COUNT(ps.PatientId) AS [Total Number of Patients]
	, SUM(ps.Tariff) AS [Total Tariff]
FROM
	PatientStay ps
GROUP BY ps.hospital
/*

--Total Tariff and Largest Tarriff for each hospital
*/
SELECT
	ps.hospital
	,SUM(ps.Tariff) AS [Total Tariff]
	,MAX(ps.Tariff) AS [Largest Tariff]
FROM
	PatientStay ps
GROUP BY ps.Hospital
HAVING SUM(ps.Tariff) >50
ORDER BY SUM(ps.Tariff) DESC
/*

--Joining two tables AND selecting column names to rectify having two columns with the same name

--This gives us all 44 patients from both tables as it has 2 Hospital Columns, we haven't filtered that out
*/
SELECT * FROM PatientStay ps LEFT JOIN DimHospitalBad h ON ps.Hospital = h.Hospital
/*

*/
SELECT
	ps.PatientId
	, ps.AdmittedDate
	, h.Hospital
	, h.[Type]
FROM
	PatientStay ps JOIN DimHospitalBad h ON ps.Hospital = h.Hospital
/*

*/
SELECT
	ps.PatientId
	, ps.AdmittedDate
	, h.Hospital
	, h.[Type]
FROM PatientStay ps LEFT JOIN DimHospitalBad h ON ps.Hospital = h.Hospital
/*
--We get NULL in hospital column here because DIMHospitalBad doesn't have PRUH in its table, so it doesn't display a name here

*/
SELECT
	ps.PatientId
	, ps.AdmittedDate
	, h.Hospital
	, h.[Type]
FROM PatientStay ps FULL OUTER JOIN DimHospitalBad h ON ps.Hospital = h.Hospital
/*
--We get an extra row for GSTT that is in the DimHospitalBad table, but not the PatientStay table, so it creates a new row and puts NULL values for PatientID and AdmittedDate


*/
SELECT
	ps.PatientId
	, ps.AdmittedDate
	, h.Hospital
	, h.[Type]
FROM PatientStay ps INNER JOIN DimHospital h ON ps.Hospital = h.Hospital
/*

--Find all patients MISSING ethnicity data
*/
SELECT
	ps.PatientId
	, ps.AdmittedDate
	, h.Hospital
	, h.[Type]
	, ps.Ethnicity
FROM PatientStay ps INNER JOIN DimHospital h ON ps.Hospital = h.Hospital
WHERE ps.Ethnicity IS NULL
/*

