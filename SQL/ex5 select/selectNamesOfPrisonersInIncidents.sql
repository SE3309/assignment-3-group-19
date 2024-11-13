SELECT prisonerName 
FROM prisoner p
WHERE EXISTS (
    SELECT 1 
    FROM incident_Report ir 
    WHERE ir.prisonerID = p.prisonerID AND p.prisonerID>8900
);
