SELECT g.guardName, p.prisonerName, ir.incidentReportDate
FROM guard g
JOIN incident_Report ir ON g.badgeNo = ir.badgeNo
JOIN prisoner p ON ir.prisonerID = p.prisonerID
WHERE ir.incidentReportDate = '2024-04-20';
