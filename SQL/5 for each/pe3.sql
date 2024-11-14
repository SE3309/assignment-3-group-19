SELECT prisonerID, programID, grade, attendance
FROM prisoner_Education
WHERE programID = 50 AND grade > 85.0;
