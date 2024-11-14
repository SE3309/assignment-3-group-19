SELECT programID, programName, capacity, enrolment
FROM education_Course
WHERE enrolment < capacity;
