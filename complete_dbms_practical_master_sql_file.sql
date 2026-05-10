-- =====================================================
-- DBMS PRACTICAL MASTER SQL FILE
-- =====================================================

-- =====================================================
-- ASSIGNMENT 1 : DATABASE CREATION & CONSTRAINTS
-- =====================================================

DROP DATABASE IF EXISTS demo1;
CREATE DATABASE demo1;
USE demo1;

-- Student Table
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(50) UNIQUE,
    Age INT,
    Address VARCHAR(50)
);

-- Instructor Table
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(50),
    Department VARCHAR(50)
);

-- Course Table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    InstructorID INT,
    Credits INT,
    FOREIGN KEY (InstructorID)
    REFERENCES Instructor(InstructorID)
);

-- Enrollment Table
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID)
    REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID)
    REFERENCES Course(CourseID)
);

SHOW TABLES;

DESC Student;
DESC Instructor;
DESC Course;
DESC Enrollment;

-- =====================================================
-- INSERT DATA
-- =====================================================

INSERT INTO Student VALUES
(1, 'Niraj', 'niraj@gmail.com', 20, 'Pune'),
(2, 'Rahul', 'rahul@gmail.com', 22, 'Mumbai'),
(3, 'Sneha', 'sneha@gmail.com', 19, 'Delhi'),
(4, 'Amit', 'amit@gmail.com', 21, 'Pune');

INSERT INTO Instructor VALUES
(101, 'Dr Sharma', 'sharma@gmail.com', 'Computer'),
(102, 'Dr Mehta', 'mehta@gmail.com', 'IT'),
(103, 'Dr Patil', 'patil@gmail.com', 'Electronics');

INSERT INTO Course VALUES
(201, 'DBMS', 101, 4),
(202, 'Python', 102, 3),
(203, 'Java', 101, 4),
(204, 'Networks', 103, 3);

INSERT INTO Enrollment VALUES
(301, 1, 201, '2024-01-10'),
(302, 2, 202, '2024-01-12'),
(303, 1, 203, '2024-01-15'),
(304, 3, 201, '2024-01-18'),
(305, 4, 204, '2024-01-20');

SELECT * FROM Student;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT * FROM Enrollment;

-- =====================================================
-- ASSIGNMENT 2 : VIEWS & INDEXING
-- =====================================================

CREATE VIEW StudentView AS
SELECT Name, Email
FROM Student;

SELECT * FROM StudentView;

UPDATE StudentView
SET Name = 'Rohan'
WHERE Name = 'Rahul';

CREATE INDEX idx_email
ON Student(Email);

SHOW INDEX FROM Student;

-- =====================================================
-- ASSIGNMENT 3 : SQL QUERIES
-- =====================================================

-- SELECT
SELECT * FROM Student;

-- WHERE
SELECT *
FROM Student
WHERE Age > 20;

-- ORDER BY ASC
SELECT *
FROM Student
ORDER BY Age ASC;

-- ORDER BY DESC
SELECT *
FROM Student
ORDER BY Age DESC;

-- DISTINCT
SELECT DISTINCT Address
FROM Student;

-- LIKE
SELECT *
FROM Student
WHERE Name LIKE 'R%';

-- BETWEEN
SELECT *
FROM Student
WHERE Age BETWEEN 20 AND 22;

-- COUNT
SELECT COUNT(*) AS TotalStudents
FROM Student;

-- AVG
SELECT AVG(Age) AS AverageAge
FROM Student;

-- MAX
SELECT MAX(Age)
FROM Student;

-- MIN
SELECT MIN(Age)
FROM Student;

-- GROUP BY
SELECT CourseID, COUNT(*) AS TotalStudents
FROM Enrollment
GROUP BY CourseID;

-- HAVING
SELECT CourseID, COUNT(*) AS TotalStudents
FROM Enrollment
GROUP BY CourseID
HAVING COUNT(*) > 1;

-- SUBQUERY
SELECT Name
FROM Student
WHERE Age > (
    SELECT AVG(Age)
    FROM Student
);

-- =====================================================
-- ASSIGNMENT 4 : JOINS
-- =====================================================

-- INNER JOIN
SELECT s.Name, c.CourseName
FROM Student s
INNER JOIN Enrollment e
ON s.StudentID = e.StudentID
INNER JOIN Course c
ON e.CourseID = c.CourseID;

-- LEFT JOIN
SELECT s.Name, e.CourseID
FROM Student s
LEFT JOIN Enrollment e
ON s.StudentID = e.StudentID;

-- RIGHT JOIN
SELECT s.Name, e.CourseID
FROM Student s
RIGHT JOIN Enrollment e
ON s.StudentID = e.StudentID;

-- FULL OUTER JOIN USING UNION
SELECT s.Name, e.CourseID
FROM Student s
LEFT JOIN Enrollment e
ON s.StudentID = e.StudentID

UNION

SELECT s.Name, e.CourseID
FROM Student s
RIGHT JOIN Enrollment e
ON s.StudentID = e.StudentID;

-- =====================================================
-- ASSIGNMENT 5 : PROCEDURES & FUNCTIONS
-- =====================================================

DELIMITER //

CREATE PROCEDURE ShowStudents()
BEGIN
    SELECT * FROM Student;
END //

DELIMITER ;

CALL ShowStudents();

DELIMITER //

CREATE FUNCTION StudentCount()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM Student;

    RETURN total;
END //

DELIMITER ;

SELECT StudentCount();

-- =====================================================
-- ASSIGNMENT 6 : TRIGGERS & CURSORS
-- =====================================================

DELIMITER //

CREATE TRIGGER student_trigger
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    SET NEW.Name = UPPER(NEW.Name);
END //

DELIMITER ;

INSERT INTO Student VALUES
(10, 'niraj', 'n@gmail.com', 20, 'Pune');

SELECT * FROM Student;

DELIMITER //

CREATE PROCEDURE CursorDemo()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sname VARCHAR(50);

    DECLARE cur CURSOR FOR
    SELECT Name FROM Student;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO sname;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT sname;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

-- =====================================================
-- ASSIGNMENT 7 : MONGODB COMMANDS
-- =====================================================

-- use college

-- db.students.insertOne({
--   name: 'Niraj',
--   age: 20,
--   city: 'Pune'
-- })

-- db.students.find()

-- db.students.updateOne(
--   {name:'Niraj'},
--   {$set:{city:'Mumbai'}}
-- )

-- db.students.deleteOne({name:'Rahul'})

-- =====================================================
-- ASSIGNMENT 8 : CASE STUDY QUERIES
-- =====================================================

SELECT Department, COUNT(*)
FROM Instructor
GROUP BY Department;

SELECT s.Name, c.CourseName
FROM Student s
JOIN Enrollment e
ON s.StudentID = e.StudentID
JOIN Course c
ON e.CourseID = c.CourseID;

-- =====================================================
-- ASSIGNMENT 9 : BACKUP & RECOVERY
-- =====================================================

-- BACKUP COMMAND
-- mysqldump -u root -p demo1 > backup.sql

-- RESTORE COMMAND
-- mysql -u root -p demo1 < backup.sql

-- =====================================================
-- EXTRA IMPORTANT QUERY PATTERNS
-- =====================================================

-- JOIN PATTERN
-- SELECT a.col, b.col
-- FROM table1 a
-- JOIN table2 b
-- ON a.id = b.id;

-- GROUP BY PATTERN
-- SELECT col, COUNT(*)
-- FROM table
-- GROUP BY col;

-- SUBQUERY PATTERN
-- SELECT col
-- FROM table
-- WHERE val > (
--     SELECT AVG(val)
--     FROM table
-- );

-- =====================================================
-- USEFUL COMMANDS
-- =====================================================

SHOW TABLES;
SELECT DATABASE();
DESC Student;
SHOW CREATE TABLE Student;
