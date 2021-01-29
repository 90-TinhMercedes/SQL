CREATE DATABASE MarkManagement
GO
CREATE TABLE Students
(	studentID NVARCHAR(12) PRIMARY KEY,
studentName NVARCHAR(25),
dateOfBirth DATETIME,
email NVARCHAR(40),
phone NVARCHAR(12),
class NVARCHAR(10)
)

CREATE TABLE Subjects
(	SubjectID NVARCHAR(10) PRIMARY KEY,
subjectName NVARCHAR(25)
)

CREATE TABLE Mark
(	studentID NVARCHAR(12),
SubjectID NVARCHAR(10),
date datetime,
theory TINYINT,
practical TINYINT,
CONSTRAINT PK_Mark PRIMARY KEY(studentID, SubjectID),
CONSTRAINT FK_StudentID FOREIGN KEY(studentID) REFERENCES Students(studentID),
CONSTRAINT FK_SubjectID FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID)
)





