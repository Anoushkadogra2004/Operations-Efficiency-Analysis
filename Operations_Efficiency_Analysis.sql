CREATE DATABASE operations_efficiency;

USE operations_efficiency;

CREATE TABLE operations_data (
    Request_ID VARCHAR(20),
    Request_Date VARCHAR(20),
    Department VARCHAR(100),
    Process_Stage VARCHAR(100),
    Team VARCHAR(100),
    Location VARCHAR(100),
    Priority VARCHAR(30),
    Request_Channel VARCHAR(50),
    Target_Time_Hours DECIMAL(10,2),
    Actual_Time_Hours DECIMAL(10,2),
    Target_Met VARCHAR(10),
    Rework_Required VARCHAR(10),
    Error_Category VARCHAR(100),
    Labor_Cost DECIMAL(12,2),
    Overtime_Hours DECIMAL(10,2),
    Overtime_Cost DECIMAL(12,2),
    Rework_Cost DECIMAL(12,2),
    Request_Status VARCHAR(30)
);

SELECT COUNT(*) AS total_records
FROM operations_data;

SELECT COUNT(*) - COUNT(DISTINCT Request_ID)
AS duplicate_requests
FROM operations_data;

SELECT
    SUM(Request_ID IS NULL) AS missing_ID,
    SUM(Request_Date IS NULL) AS missing_Date,
    SUM(Department IS NULL) AS missing_Department,
    SUM(Team IS NULL) AS missing_Team,
    SUM(Actual_Time_Hours IS NULL) AS missing_Actual_Time,
    SUM(Labor_Cost IS NULL) AS missing_Labor_Cost
FROM operations_data;

SELECT
    Request_Status,
    COUNT(*) AS Total_Requests,
    ROUND(AVG(Actual_Time_Hours), 2) AS Avg_Processing_Hours,
    ROUND(SUM(Labor_Cost), 2) AS Total_Labor_Cost,
    ROUND(SUM(Rework_Cost), 2) AS Total_Rework_Cost
FROM operations_data
GROUP BY Request_Status;

SELECT
    Department,
    COUNT(*) AS Total_Requests,
    ROUND(AVG(Actual_Time_Hours), 2) AS Avg_Processing_Hours,
    ROUND(SUM(Overtime_Cost), 2) AS Total_Overtime_Cost,
    ROUND(SUM(Rework_Cost), 2) AS Total_Rework_Cost
FROM operations_data
GROUP BY Department
ORDER BY Total_Requests DESC;

SELECT
    Department,
    COUNT(*) AS Total_Requests,
    SUM(Target_Met = 'Yes') AS Requests_On_Target,
    ROUND(
        100.0 * SUM(Target_Met = 'Yes') / COUNT(*), 2
    ) AS SLA_Compliance_Percent
FROM operations_data
GROUP BY Department
ORDER BY SLA_Compliance_Percent ASC;

SELECT
    Department,
    Error_Category,
    COUNT(*) AS Total_Requests,
    ROUND(SUM(Rework_Cost), 2) AS Total_Rework_Cost
FROM operations_data
WHERE Rework_Required = 'Yes'
GROUP BY Department, Error_Category
ORDER BY Total_Rework_Cost DESC;

SELECT
    Process_Stage,
    COUNT(*) AS Total_Requests,
    ROUND(AVG(Actual_Time_Hours), 2) AS Avg_Time_Hours,
    ROUND(100.0 * SUM(Target_Met = 'Yes') / COUNT(*), 2)
        AS SLA_Compliance_Percent,
    ROUND(SUM(Overtime_Cost), 2) AS Overtime_Cost,
    ROUND(SUM(Rework_Cost), 2) AS Rework_Cost
FROM operations_data
GROUP BY Process_Stage
ORDER BY SLA_Compliance_Percent ASC;

SELECT
    Priority,
    COUNT(*) AS Total_Requests,
    ROUND(AVG(Actual_Time_Hours), 2) AS Avg_Time_Hours,
    ROUND(100.0 * SUM(Target_Met = 'Yes') / COUNT(*), 2)
        AS SLA_Compliance_Percent,
    ROUND(SUM(Overtime_Cost), 2) AS Overtime_Cost,
    ROUND(SUM(Rework_Cost), 2) AS Rework_Cost
FROM operations_data
GROUP BY Priority
ORDER BY SLA_Compliance_Percent ASC;

SELECT
    Error_Category,
    COUNT(*) AS Total_Requests,
    ROUND(SUM(Rework_Cost), 2) AS Total_Rework_Cost,
    ROUND(SUM(Overtime_Cost), 2) AS Total_Overtime_Cost
FROM operations_data
WHERE Rework_Required = 'Yes'
GROUP BY Error_Category
ORDER BY Total_Rework_Cost DESC;

SELECT
    Location,
    COUNT(*) AS Total_Requests,
    ROUND(
        100.0 * SUM(Target_Met = 'Yes') / COUNT(*), 2
    ) AS SLA_Compliance_Percent,
    ROUND(SUM(Overtime_Cost), 2) AS Overtime_Cost,
    ROUND(SUM(Rework_Cost), 2) AS Rework_Cost
FROM operations_data
GROUP BY Location
ORDER BY SLA_Compliance_Percent ASC;

SELECT
    COUNT(*) AS Total_Requests,
    ROUND(AVG(Actual_Time_Hours), 2) AS Avg_Processing_Hours,
    ROUND(100.0 * SUM(Target_Met = 'Yes') / COUNT(*), 2)
        AS Overall_SLA_Percent,
    SUM(Rework_Required = 'Yes') AS Rework_Requests,
    ROUND(SUM(Labor_Cost), 2) AS Total_Labor_Cost,
    ROUND(SUM(Overtime_Cost), 2) AS Total_Overtime_Cost,
    ROUND(SUM(Rework_Cost), 2) AS Total_Rework_Cost
FROM operations_data;

SELECT
    DATE_FORMAT(
        STR_TO_DATE(Request_Date, '%d-%m-%Y'),
        '%Y-%m'
    ) AS Request_Month,
    COUNT(*) AS Total_Requests,
    ROUND(
        100.0 * SUM(Target_Met = 'Yes') / COUNT(*), 2
    ) AS SLA_Compliance_Percent,
    ROUND(AVG(Actual_Time_Hours), 2) AS Avg_Processing_Hours,
    ROUND(SUM(Rework_Cost), 2) AS Rework_Cost
FROM operations_data
GROUP BY Request_Month
ORDER BY Request_Month;

SELECT
    Process_Stage,
    COUNT(*) AS Total_Requests,
    SUM(Target_Met = 'No') AS Missed_Targets,
    ROUND(SUM(Rework_Cost), 2) AS Rework_Cost
FROM operations_data
GROUP BY Process_Stage
ORDER BY Missed_Targets DESC
LIMIT 5;

SELECT
    COUNT(*) AS Total_Records,
    SUM(
        STR_TO_DATE(Request_Date, '%d-%m-%Y') IS NULL
    ) AS Invalid_Dates
FROM operations_data;