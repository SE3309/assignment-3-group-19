SELECT incidentReportID, prisonerID, badgeNo, incidentReportDate
FROM incident_Report
WHERE incidentReportDate BETWEEN '2024-01-01' AND '2024-12-31';
