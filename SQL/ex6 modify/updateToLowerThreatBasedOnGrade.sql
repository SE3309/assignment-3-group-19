UPDATE prisoner
SET dangerLevel = 'Low'
WHERE prisonerID IN (
    SELECT prisonerID
    FROM prisoner_Education
    WHERE grade >= 80.0
) AND dangerLevel = 'Medium';
