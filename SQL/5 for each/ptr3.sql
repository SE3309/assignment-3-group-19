SELECT transferReportID, prisonerID, transferReportDate
FROM prison_Transfer_Report
WHERE transferReportDate BETWEEN '2024-01-01' AND '2024-12-31';
