INSERT INTO education_Course (programID, programName, programType, instructorName, capacity, enrolment)
SELECT 
    COALESCE(MAX(programID), 0) + 1,
    'Doctoring',
    'Learning',
    'John Doe',
    100,
    0
FROM education_Course;