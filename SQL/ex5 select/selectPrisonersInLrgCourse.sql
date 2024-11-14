SELECT prisonerName 
FROM prisoner 
WHERE prisonerID IN (
    SELECT prisonerID 
    FROM prisoner_Education pe
    JOIN education_Course ec ON pe.programID = ec.programID
    WHERE ec.capacity > (SELECT AVG(capacity) FROM education_Course)
);
