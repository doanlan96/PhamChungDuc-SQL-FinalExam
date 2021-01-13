DROP DATABASE IF EXISTS student_management;
CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;
DROP TABLE IF exists Student,
					 `Subject`,
                     StudentSubject;
-- question 1                     
CREATE TABLE Student
(
    StudentID TINYINT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    Age TINYINT NOT NULL,
    Gender ENUM('Male', 'Female', 'Unknown')
);
CREATE TABLE `Subject`
(
    SubjectID TINYINT AUTO_INCREMENT PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL
);
CREATE TABLE StudentSubject
(
    StudentID TINYINT,
    SubjectID TINYINT,
    Mark TINYINT,
    `Date` DATE,
    PRIMARY KEY (StudentID, SubjectID)
);
INSERT INTO Student(StudentName, Age, Gender) VALUES ('Nguyen Van A', '18', 'Male'),
													 ('Pham Van B', '17', 'Male'),
													 ('Trinh Van C', '20', 'Male'),
													 ('Tran Thi D', '18', 'Female');
INSERT INTO `Subject` (SubjectName) VALUES ('Math'),
										   ('Literature'),
                                           ('Biology'),
                                           ('Music'),
                                           ('English');
INSERT INTO StudentSubject(StudentID, SubjectID, Mark, `Date`) VALUES (2, 3, 9, '2020-10-24'),
																	  (2, 4, 7, '2020-10-26'),
																	  (1, 1, 9, '2020-10-22'),
																	  (1, 3, 10, '2020-10-24'),
                                                                      (3, 1, 7, '2020-10-22'),
                                                                      (3, 2, 6, '2020-10-25'),
                                                                      (4, 4, 10, '2020-10-26'),
                                                                      (4, 3, 7, '2020-10-24');
                                                                      
-- question 2
-- A
SELECT S.SubjectID, S.SubjectName
FROM `Subject` S
WHERE S.SubjectID NOT IN (SELECT SubjectID 
						  FROM StudentSubject);
-- B                          
SELECT S.SubjectID, S.SubjectName
FROM `Subject` S
WHERE S.SubjectID IN (SELECT SS.SubjectID  
					  FROM StudentSubject SS
                      GROUP BY SS.SubjectID
                      HAVING COUNT(SS.SubjecTID) >= 2);
                      
-- question 3                      
CREATE OR REPLACE VIEW StudentInfo AS
SELECT S.StudentID, Su.SubjectID, S.StudentName, S.Age AS StudentAge, S.Gender AS StudentGender, Su.SubjectName, SS.Mark, SS.`Date`
FROM StudentSubject SS
JOIN Student S ON S.StudentID = SS.StudentID
JOIN `Subject` Su ON Su.SubjectID = SS.SubjectID
ORDER BY SS.StudentID;

-- question 4
-- A 
DROP TRIGGER IF EXISTS SubjectUpdateID;
DELIMITER $$
CREATE TRIGGER SubjectUpdateID
AFTER UPDATE ON `Subject` 
FOR EACH ROW
BEGIN
UPDATE StudentSubject
SET SubjectID = NEW.SubjectID
WHERE SubjectId = OLD.SubjectID;
END$$
DELIMITER ;
-- B 
DROP TRIGGER IF EXISTS SubjectDeleteID;
DELIMITER $$
CREATE TRIGGER SubjectDeleteID
AFTER DELETE ON `Subject` 
FOR EACH ROW
BEGIN
DELETE FROM StudentSubject
WHERE SubjectID = OLD.SubjectID;
END$$
DELIMITER ; 

-- question 5
DROP PROCEDURE IF EXISTS SubjectUpdateID;
DELIMITER $$
CREATE PROCEDURE SubjectUpdateID(IN in_student_name VARCHAR(50))
BEGIN
IF in_student_name = '*'
THEN DELETE FROM Student; 
DELETE FROM StudentSubject; 
ELSE
DELETE FROM Student WHERE StudentName = in_student_name;
DELETE FROM StudentSubject WHERE StudentID = (SELECT StudentID
											   FROM Student
                                               WHERE StudentName = in_student_name);
END IF;
END $$
DELIMITER ;	
                    