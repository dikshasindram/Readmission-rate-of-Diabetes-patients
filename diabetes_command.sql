*to find readmission rate*
SELECT readmitted,
COUNT(*) AS total_patient
FROM diabetes.data
GROUP BY readmitted
ORDER BY readmitted DESC;

*to find readmission rate by demographics*
SELECT race,
COUNT(*) AS total_patient,
SUM(CASE WHEN readmitted IN ('<30', '>30') THEN 1 ELSE 0 END) AS readmitted,
round(
SUM(CASE WHEN readmitted IN ('<30', '>30') THEN 1 ELSE 0 END)*100/COUNT(*),2) AS readmitted_rate
FROM diabetes.data
GROUP BY race
ORDER BY readmitted_rate DESC;

*to find readmission rate by the impact of medication*
SELECT medication,
COUNT(*) AS total_patients,
SUM(CASE WHEN readmitted IN ('<30', '>30') THEN 1 ELSE 0 END) AS total_readmitted,
ROUND(
SUM(CASE WHEN readmitted IN ('<30', '>30') THEN 1 ELSE 0 END)*100/COUNT(*),2) AS readmitted_rate
FROM 
(SELECT 
CASE WHEN metformin IN ('Down', 'Up', 'Steady') THEN 'metformin'
WHEN repaglinide IN ('Down', 'Up', 'Steady') THEN 'repaglinide'
WHEN insulin IN ('Down', 'Up', 'Steady') THEN 'insulin'
ELSE 'other' END AS medication, readmitted 
FROM diabetes.data) as med_data
GROUP BY medication
ORDER BY readmitted_rate DESC;

*to assess the length of stay with readmission rate* 
SELECT time_in_hospital,
COUNT(*) AS total_patients,
SUM(CASE WHEN readmitted IN ('<30', '>30') THEN 1 ELSE 0 END) AS readmitted_patients,
round(
SUM(CASE WHEN readmitted IN ('<30', '>30') THEN 1 ELSE 0 END)*100/COUNT(*),2) AS readmitted_rate
FROM diabetes.data
GROUP BY time_in_hospital
ORDER BY readmitted_rate DESC;

*to evaluate readmission rate with discharge disposition*
SELECT description,
COUNT(*) AS totalpatients,
SUM(CASE WHEN readmitted IN ('<30','>30') THEN 1 ELSE 0 END) AS total_readmitted, 
round(
SUM(CASE WHEN readmitted IN ('<30','>30') THEN 1 ELSE 0 END)*100/ COUNT(*),2) AS readmitted_rate
FROM diabetes.data d
JOIN diabetes.dischrgid a
ON a.discharge_disposition_id= d.discharge_disposition_id
GROUP BY description
ORDER BY readmitted_rate DESC;

*to evaluate frequent readmitters by discharge disposition*
SELECT description,
COUNT(*) AS total_patient,
SUM(CASE WHEN readmitted IN ('<30','>30') THEN 1 ELSE 0 END) AS readmitted
FROM diabetes.data d
JOIN diabetes.dischrgid a
ON a.discharge_disposition_id = d.discharge_disposition_id
GROUP BY description
HAVING SUM(CASE WHEN readmitted IN ('<30','>30') THEN 1 ELSE 0 END)>1
ORDER BY readmitted DESC;



