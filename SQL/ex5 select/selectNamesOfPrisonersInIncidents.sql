SELECT p.prisonerName, COUNT(ir.incidentReportID) AS incidentCount
FROM prisoner p
JOIN incident_Report ir ON ir.prisonerID = p.prisonerID
WHERE p.prisonerID > 8900
GROUP BY p.prisonerName;
