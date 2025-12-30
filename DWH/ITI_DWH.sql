use master
go

ALTER DATABASE ITI_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
go

drop database ITI_DWH;
go

create database ITI_DWH;
go

use ITI_DWH;
go

--------------------------------------
create table Dim_User(
	UserID int primary key,
    RoleName nvarchar(11),
    FullName NVARCHAR(60),
    FullAddress nvarchar(200),
    Governorate nvarchar(50),
    Email NVARCHAR(50),
    Phone NVARCHAR(13),
    DOB DATE,
    Gender char(1),
    MaritalStatus NVARCHAR(9),
    NumKids tinyint,
    IsActive BIT
);
go

create table Dim_University(
    UniversityID int primary key,
    UniversityName nvarchar(50),
    Country nvarchar(50)
);
go

create table Dim_Department(
	DeptID tinyint PRIMARY KEY,
	DeptName NVARCHAR(50),
	IsActive bit
);
go

create table Dim_Track(
	TrackID tinyINT PRIMARY KEY,
    TrackName NVARCHAR(50),
	DeptName nvarchar(50),
	TotalHours INT,
    [Description]  NVARCHAR(1000),
	IsActive bit
);
go

create table Dim_Intake(
    IntakeID INT PRIMARY KEY,
    IntakeName NVARCHAR(100),
    StartDate DATE,
    EndDate DATE,
	IsActive BIT
);
go

create table Dim_Branch(
	BranchID tinyint PRIMARY KEY,
	BranchName nVARCHAR(50),
    Governorate nvarchar(50),
    IsActive bit
);
go

create table Dim_Company(
    CompanyID int primary key,
    CompanyName nvarchar(50),
    Country nvarchar(50),
    CompanyType nvarchar(20)
);
go

create table Dim_JobType(
    JobTypeID tinyint primary key,
    EmploymentType nvarchar(11),
    WorkMode nvarchar(7)
);
go

create table Dim_Certificate(
    CertID int primary key,
    CertName nvarchar(100),
    [Hours] tinyint,
    Website nvarchar(100),
    StudyField nvarchar(50)
);
go

create table Dim_Course(
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(200),
    [Hours] int,
    MaxDegree INT,
    MinDegree INT
);
go

create table Dim_Exam(
    ExamID INT PRIMARY KEY,
    Score INT,
    ExamType char(1),
    Archived BIT
);
go

create table Dim_QP(
    QPID int primary key,
    CourseName nvarchar(200),
    Qtype nvarchar(10),
    QDescription nvarchar(1000)
);
go

create table Fact_Student(
	StudentSK int identity(1,1) primary key,
	Student_ID int,
	StartDate date,
	EndDate date,
    Age_When_Joined tinyint,
	Track_ID tinyint,
	Branch_ID tinyint,
	Intake_ID int,
	University_ID int,
	FacultyName nvarchar(50),
	GradYear int,
	GPA decimal(3,2),
    CONSTRAINT FK_Student_Student FOREIGN KEY (Student_ID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_Student_Track FOREIGN KEY (Track_ID) REFERENCES Dim_Track(TrackID),
    CONSTRAINT FK_Student_Branch FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(BranchID),
    CONSTRAINT FK_Student_Intake FOREIGN KEY (Intake_ID) REFERENCES Dim_Intake(IntakeID),
    CONSTRAINT FK_Student_University FOREIGN KEY (University_ID) REFERENCES Dim_University(UniversityID),
);
go

create table Fact_StudentFreelance(
    FreelanceSK int identity(1,1) primary key,
    Student_ID int,
    JobField nvarchar(50),
    Feedback tinyint,
    Revenue int,
    CONSTRAINT FK_Freelance_Student FOREIGN KEY (Student_ID) REFERENCES Dim_User(UserID)
);
go

create table Fact_GradJob(
    GradJobSK int identity(1,1) primary key,
    Student_ID int,
    Company_ID int,
    JobTitle nvarchar(50),
    JobField nvarchar(50),
    JobType_ID tinyint,
    Salary int,
    CONSTRAINT FK_GradJob_Student FOREIGN KEY (Student_ID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_GradJob_Company FOREIGN KEY (Company_ID) REFERENCES Dim_Company(CompanyID),
    CONSTRAINT FK_GradJob_JobType FOREIGN KEY (JobType_ID) REFERENCES Dim_JobType(JobTypeID)
);
go

create table Fact_StudentExternalCertificate(
    StudCertSK int identity(1,1) primary key,
    Student_ID int,
    Certificate_ID int,
    CONSTRAINT FK_Cert_Student FOREIGN KEY (Student_ID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_Cert_Cert FOREIGN KEY (Certificate_ID) REFERENCES Dim_Certificate(CertID)
);
go

create table Fact_Fulltime(
    InstructorSK int identity(1,1) primary key,
    Instructor_ID int,
    StartDate date,
    EndDate date,
    YrsExp tinyint,
    Salary int,
    Dept_ID tinyint,
    Branch_ID tinyint,
    CONSTRAINT FK_Fulltime_User FOREIGN KEY (Instructor_ID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_Instructor_Branch FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(BranchID),
    CONSTRAINT FK_Instructor_Department FOREIGN KEY (Dept_ID) REFERENCES Dim_Department(DeptID)
);
go

create table Fact_External(
    InstructorSK int identity(1,1) primary key,
    Instructor_ID int,
    StartDate date,
    EndDate date,
    YrsExp tinyint,
    Salary int,
    Company_ID int,
    JobTitle nvarchar(50),
    JobField nvarchar(50),
    JobType_ID tinyint,
    CONSTRAINT FK_External_User FOREIGN KEY (Instructor_ID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_External_Company FOREIGN KEY (Company_ID) REFERENCES Dim_Company(CompanyID),
    CONSTRAINT FK_External_JobType FOREIGN KEY (JobType_ID) REFERENCES Dim_JobType(JobTypeID)
);
go

create table Fact_InstructorCanTeach(
    CanTeachSK int identity(1,1) primary key,
    Instructor_ID int,
    Course_ID int,
    CONSTRAINT FK_CanTeach_User FOREIGN KEY (Instructor_ID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_CanTeach_Course FOREIGN KEY (Course_ID) REFERENCES Dim_Course(CourseID)
);
go

create table Fact_Teach(
    TeachSK int identity(1,1) primary key,
    Instructor_ID int,
    Course_ID int,
    Track_ID tinyint,
    Branch_ID tinyint,
    Intake_ID int,
    CONSTRAINT FK_Teach_Course FOREIGN KEY (Course_ID) REFERENCES Dim_Course(CourseID),
    CONSTRAINT FK_Teach_Track FOREIGN KEY (Track_ID) REFERENCES Dim_Track(TrackID),
    CONSTRAINT FK_Teach_Branch FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(BranchID),
    CONSTRAINT FK_Teach_Intake FOREIGN KEY (Intake_ID) REFERENCES Dim_Intake(IntakeID),
    CONSTRAINT FK_Teach_Instructor FOREIGN KEY (Instructor_ID) REFERENCES Dim_User(UserID)
);
go

create table Fact_Open(
    OpenID int primary key,
    SuperID int,
    Track_ID tinyint,
    Branch_ID tinyint,
    Intake_ID int,
    CONSTRAINT FK_Open_Super FOREIGN KEY (SuperID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_Open_Track FOREIGN KEY (Track_ID) REFERENCES Dim_Track(TrackID),
    CONSTRAINT FK_Open_Branch FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(BranchID),
    CONSTRAINT FK_Open_Intake FOREIGN KEY (Intake_ID) REFERENCES Dim_Intake(IntakeID)
);
go

create table Fact_TrackCourse(
    TrackCourseSK int identity(1,1) primary key,
    Track_ID tinyint,
    Course_ID int,
    CONSTRAINT FK_TC_Track FOREIGN KEY (Track_ID) REFERENCES Dim_Track(TrackID),
    CONSTRAINT FK_TC_Course FOREIGN KEY (Course_ID) REFERENCES Dim_Course(CourseID)
);
go

create table Fact_Exam(
    ExamSK int identity(1,1) primary key,
    Exam_ID int,
    Instructor_ID int,
    Course_ID int,
    Track_ID tinyint,
    Intake_ID int,
    Branch_ID tinyint,
    StartTime time(0),
    EndTime time(0),
    ExamDate date,
    CONSTRAINT FK_Exam_Exam FOREIGN KEY (Exam_ID) REFERENCES Dim_Exam(ExamID),
    CONSTRAINT FK_Exam_User FOREIGN KEY (Instructor_ID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_Exam_Course FOREIGN KEY (Course_ID) REFERENCES Dim_Course(CourseID),
    CONSTRAINT FK_Exam_Track FOREIGN KEY (Track_ID) REFERENCES Dim_Track(TrackID),
    CONSTRAINT FK_Exam_Intake FOREIGN KEY (Intake_ID) REFERENCES Dim_Intake(IntakeID),
    CONSTRAINT FK_Exam_Branch FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(BranchID)
);
go

create table Fact_ExamQuestions(
    ExamQuestionSK int identity(1,1) primary key,
    Exam_ID int,
    QP_ID int,
    Degree int,
    CONSTRAINT FK_EQ_Exam FOREIGN KEY (Exam_ID) REFERENCES Dim_Exam(ExamID),
    CONSTRAINT FK_EQ_QP FOREIGN KEY (QP_ID) REFERENCES Dim_QP(QPID)
);
go

create table Fact_StudentExamResult(
    ExamResultSK int identity(1,1) primary key,
    Student_ID int,
    Exam_ID int,
    TotalScore int,
    IsPass bit,
    CONSTRAINT FK_ExamResult_User FOREIGN KEY (Student_ID) REFERENCES Dim_User(UserID),
    CONSTRAINT FK_ExamResult_Exam FOREIGN KEY (Exam_ID) REFERENCES Dim_Exam(ExamID)
);
go