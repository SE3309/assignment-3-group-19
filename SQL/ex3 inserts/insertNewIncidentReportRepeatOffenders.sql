INSERT INTO incident_Report (incidentReportID, prisonerID, badgeNo, incidentReportDate)
SELECT 
    (SELECT MAX(incidentReportID) FROM incident_Report) + ROW_NUMBER() OVER (ORDER BY prisonerID) AS newIncidentID,
    prisonerID, 
    NULL, 
    CURDATE()
FROM incident_Report
GROUP BY prisonerID
HAVING COUNT(*) > 2;


