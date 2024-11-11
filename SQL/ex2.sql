CREATE TABLE education_Course(programID INT PRIMARY KEY,
							programName VARCHAR(50) NOT NULL,
                            programType VARCHAR(50) NOT NULL,
                            instructorName VARCHAR(50),
                            capacity INT NOT NULL,
                            enrolment INT DEFAULT 0,
                            CHECK (enrolment <= capacity));
CREATE TABLE cell_Block(cellBlockID INT PRIMARY KEY,
						securityLevel VARCHAR(25) NOT NULL,
                        capacity INT NOT NULL CHECK (capacity > 0),
                        occupancy INT DEFAULT 0,
                        numCells INT,
                        CHECK (occupancy <= capacity));
CREATE TABLE guard(badgeNo INT PRIMARY KEY,
				cellBlockID INT,
                guardName VARCHAR(50) NOT NULL,
                dateOfBirth DATE,
                weightKg INT,
                heightCm INT,
                salary INT,
                FOREIGN KEY (cellBlockID) REFERENCES cell_Block(cellBlockID));
CREATE TABLE cell(cellNo INT PRIMARY KEY,
				cellBlockID INT NOT NULL,
                cellType VARCHAR(25),
                floorNo INT,
                FOREIGN KEY (cellBlockID) REFERENCES cell_Block(cellBlockID));
CREATE TABLE prisoner(prisonerID INT PRIMARY KEY,
					cellNo INT NOT NULL,
                    prisonerName VARCHAR(50) NOT NULL,
                    dateOfBirth DATE,
                    heightCm INT,
                    weightKg INT,
                    eyeColor VARCHAR(20),
                    hairColor VARCHAR(20),
                    offenseType VARCHAR(25),
                    dangerLevel VARCHAR(25),
                    FOREIGN KEY (cellNo) REFERENCES cell(cellNo));
CREATE TABLE prisoner_Education(prisonerStudentID INT NOT NULL,
								programID INT NOT NULL,
                                grade DECIMAL(5, 2),
                                attendance DECIMAL(5, 2),
                                PRIMARY KEY (prisonerStudentID, programID),
                                FOREIGN KEY (prisonerStudentID) REFERENCES prisoner(prisonerID),
                                FOREIGN KEY (programID) REFERENCES education_Course(programID));
CREATE TABLE incident_Report(incidentReportID INT PRIMARY KEY,
							prisonerID INT NOT NULL,
                            guardBadgeNo INT,
                            incidentReportDate DATE NOT NULL,
                            FOREIGN KEY (prisonerID) REFERENCES prisoner(prisonerID),
                            FOREIGN KEY (guardBadgeNo) REFERENCES guard(badgeNo)); 
CREATE TABLE prison_Transfer_Report(transferReportID INT PRIMARY KEY,
									prisonerID INT NOT NULL,
                                    transferReportDate DATE NOT NULL,
                                    FOREIGN KEY (prisonerID) REFERENCES prisoner(prisonerID));
                                    
DELIMITER $$
CREATE TRIGGER update_enrollment_after_insert
AFTER INSERT ON prisoner_Education
FOR EACH ROW
BEGIN
    UPDATE education_Course
    SET enrolment = enrolment + 1
    WHERE programID = NEW.programID;
END$$
DELIMITER ;
                  
DELIMITER $$
CREATE TRIGGER update_enrollment_after_delete
AFTER DELETE ON prisoner_Education
FOR EACH ROW
BEGIN
    UPDATE education_Course
    SET enrolment = enrolment - 1
    WHERE programID = OLD.programID;
END$$
DELIMITER ;

ALTER TABLE prisoner
ADD CONSTRAINT unique_cell_no UNIQUE (cellNo);

DELIMITER $$
CREATE TRIGGER update_occupancy_after_insert
AFTER INSERT ON prisoner
FOR EACH ROW
BEGIN
    UPDATE cell_Block
    SET occupancy = occupancy + 1
    WHERE cellBlockID = (SELECT cellBlockID FROM cell WHERE cellNo = NEW.cellNo);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_occupancy_after_delete
AFTER DELETE ON prisoner
FOR EACH ROW
BEGIN
    UPDATE cell_Block
    SET occupancy = occupancy - 1
    WHERE cellBlockID = (SELECT cellBlockID FROM cell WHERE cellNo = OLD.cellNo);
END$$
DELIMITER ;






