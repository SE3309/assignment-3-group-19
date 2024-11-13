INSERT INTO incident_Report (incidentReportID, prisonerID, badgeNo, incidentReportDate)
SELECT 
(SELECT MAX(incidentReportID) + 1 FROM incident_Report) AS incidentReportID, 
(SELECT prisonerID FROM prisoner ORDER BY RAND() LIMIT 1) AS prisonerID,
(SELECT badgeNo FROM guard ORDER BY RAND() LIMIT 1) AS badgeNo,
CURDATE() AS date;