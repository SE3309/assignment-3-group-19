CREATE VIEW education_course_summary AS
SELECT ec.programID, ec.programName, ec.programType, ec.instructorName, ec.capacity, ec.enrolment
FROM education_Course ec;
