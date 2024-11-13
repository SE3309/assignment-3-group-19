SELECT programID, programName, instructorName, enrolment 
FROM education_Course
WHERE enrolment = (
    SELECT MIN(capacity) 
    FROM education_Course
);
