create database columbia_hospital_data ;
use  columbia_hospital_data;
select * from doctor_patients_data;


--- objective q15
SELECT  
    DoctorID, 
    DoctorName, 
    SUM(Fee) AS TotalRevenue, 
    COUNT(VisitID) AS TotalPatients
FROM Visits
GROUP BY DoctorID, DoctorName
ORDER BY TotalRevenue DESC, TotalPatients ASC;


--- objective q16
WITH MonthlyWait AS (
    SELECT 
        Department,
        DATETRUNC(month, VisitDate) AS VisitMonth,
        AVG(WaitTime) AS AvgWait,
        LAG(AVG(WaitTime), 1) OVER (PARTITION BY Department ORDER BY DATETRUNC(month, VisitDate)) AS PrevWait1,
        LAG(AVG(WaitTime), 2) OVER (PARTITION BY Department ORDER BY DATETRUNC(month, VisitDate)) AS PrevWait2
    FROM Visits
    GROUP BY Department, DATETRUNC(month, VisitDate)
)
SELECT DISTINCT Department 
FROM MonthlyWait
WHERE AvgWait < PrevWait1 AND PrevWait1 < PrevWait2;


---objective q17
WITH GenderCounts AS (
    SELECT 
        DoctorID,
        SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS MaleCount,
        SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS FemaleCount
    FROM Visits
    GROUP BY DoctorID
)
SELECT 
    DoctorID,
    CAST(MaleCount AS FLOAT) / NULLIF(FemaleCount, 0) AS MaleToFemaleRatio,
    DENSE_RANK() OVER (ORDER BY CAST(MaleCount AS FLOAT) / NULLIF(FemaleCount, 0) DESC) AS DoctorRank
FROM GenderCounts;



--- objective q18
SELECT 
    Doctor ID, 
    DoctorName, 
    AVG(CAST(SatisfactionScore AS FLOAT)) AS AvgSatisfaction
FROM visits
GROUP BY Doctor ID, DoctorName;


--- objective q19
SELECT 
    DoctorID, 
    COUNT(DISTINCT Race) AS DistinctRacesTreated
FROM Visits
GROUP BY DoctorID
HAVING COUNT(DISTINCT Race) > 1;




---- objective q20
SELECT 
    Department,
    SUM(CASE WHEN Gender = 'Male' THEN BillAmount ELSE 0 END) / 
    NULLIF(SUM(CASE WHEN Gender = 'Female' THEN BillAmount ELSE 0 END), 0) AS MaleToFemaleBillRatio
FROM Visits
GROUP BY Department;





--- objective q21
UPDATE Visits
SET SatisfactionScore = CASE 
    WHEN SatisfactionScore + 2 > 10 THEN 10 
    ELSE SatisfactionScore + 2 
END
WHERE Department = 'General Practice' 
  AND WaitTime > 30;



--- 



