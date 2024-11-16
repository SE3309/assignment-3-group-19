CREATE VIEW prisoners_education_status AS
SELECT p.prisonerID, p.prisonerName, p.dateOfBirth, pe.programID, pe.grade
FROM prisoner p
JOIN prisoner_education pe ON p.prisonerID = pe.prisonerID;