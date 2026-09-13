-- Student Database Management System
-- Portfolio Project
-- MySQL 8.0

CREATE DATABASE IF NOT EXISTS student_database;
USE student_database;

-- =========================================================
-- 1. TABLES
-- =========================================================

CREATE TABLE IF NOT EXISTS departments (
    department_id INT NOT NULL AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (department_id)
);

CREATE TABLE IF NOT EXISTS students (
    student_id INT NOT NULL AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    department_id INT,
    PRIMARY KEY (student_id),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE IF NOT EXISTS courses (
    course_id INT NOT NULL AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    credit_hours INT NOT NULL,
    department_id INT NOT NULL,
    PRIMARY KEY (course_id),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT NOT NULL AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade VARCHAR(5),
    PRIMARY KEY (enrollment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- =========================================================
-- 2. SAMPLE DATA
-- =========================================================

INSERT INTO departments (department_name)
VALUES
('Management Information Systems'),
('Business Administration'),
('Accounting and Finance'),
('Marketing'),
('Human Resource Management');

INSERT INTO students (student_name, email, date_of_birth, department_id)
VALUES
('Ayesha Khan', 'ayesha.khan@university.edu', '2003-04-15', 1),
('Hamza Ali', 'hamza.ali@email.com', '2002-11-20', 2),
('Maham Ahmed', 'maham.ahmed@email.com', '2003-07-08', 3),
('Zainab Malik', 'zainab.malik@email.com', '2002-09-12', 4),
('Usman Shah', 'usman.shah@email.com', '2003-01-25', 5);

INSERT INTO courses (course_name, course_code, credit_hours, department_id)
VALUES
('Database Management Systems', 'MIS301', 3, 1),
('Business Finance', 'FIN201', 3, 2),
('Financial Accounting', 'ACC201', 3, 3),
('Marketing Management', 'MKT301', 3, 4),
('Human Resource Management', 'HRM301', 3, 5);

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade)
VALUES
(1, 1, '2026-01-10', 'A'),
(1, 3, '2026-01-10', 'B+'),
(2, 2, '2026-01-10', 'A-'),
(2, 4, '2026-01-10', 'B'),
(3, 3, '2026-01-10', 'A'),
(3, 5, '2026-01-10', 'B+'),
(4, 4, '2026-01-10', 'A-'),
(4, 1, '2026-01-10', 'B+'),
(5, 5, '2026-01-10', 'A');

-- =========================================================
-- 3. EXAMPLE QUERIES
-- =========================================================

SELECT * FROM departments;

SELECT * FROM students;

SELECT * FROM courses;

SELECT * FROM enrollments;

-- Multi-table JOIN
SELECT
    students.student_name,
    departments.department_name,
    courses.course_name,
    courses.course_code,
    enrollments.grade
FROM students
JOIN departments
    ON students.department_id = departments.department_id
JOIN enrollments
    ON students.student_id = enrollments.student_id
JOIN courses
    ON enrollments.course_id = courses.course_id;

-- Count courses per student
SELECT
    students.student_name,
    COUNT(enrollments.course_id) AS total_courses
FROM students
JOIN enrollments
    ON students.student_id = enrollments.student_id
GROUP BY students.student_id, students.student_name;

-- Grade distribution
SELECT
    grade,
    COUNT(*) AS number_of_students
FROM enrollments
GROUP BY grade
ORDER BY number_of_students DESC;

-- Filter by department
SELECT
    student_name,
    email
FROM students
WHERE department_id = 1;

-- Sort students alphabetically
SELECT
    student_id,
    student_name,
    email
FROM students
ORDER BY student_name ASC;

-- Subquery: students in MIS
SELECT
    student_name,
    email
FROM students
WHERE department_id = (
    SELECT department_id
    FROM departments
    WHERE department_name = 'Management Information Systems'
);

-- UPDATE example
UPDATE students
SET email = 'ayesha.khan@university.edu'
WHERE student_id = 1;

-- DELETE example used in the project
-- DELETE FROM enrollments
-- WHERE enrollment_id = 10;

-- =========================================================
-- 4. VIEW
-- =========================================================

CREATE OR REPLACE VIEW student_course_report AS
SELECT
    students.student_name,
    departments.department_name,
    courses.course_name,
    courses.course_code,
    enrollments.grade
FROM students
JOIN departments
    ON students.department_id = departments.department_id
JOIN enrollments
    ON students.student_id = enrollments.student_id
JOIN courses
    ON enrollments.course_id = courses.course_id;

SELECT * FROM student_course_report;

-- Final combined report
SELECT
    students.student_name,
    departments.department_name,
    courses.course_name,
    courses.course_code,
    enrollments.grade
FROM students
JOIN departments
    ON students.department_id = departments.department_id
JOIN enrollments
    ON students.student_id = enrollments.student_id
JOIN courses
    ON enrollments.course_id = courses.course_id
ORDER BY students.student_name ASC;
