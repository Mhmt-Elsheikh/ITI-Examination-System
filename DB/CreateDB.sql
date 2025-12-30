use master

go
ALTER DATABASE ITIExaminationSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
go
drop database ITIExaminationSystem;
go
-- Create DB and use it
create database ITIExaminationSystem;
go
use ITIExaminationSystem;
go

--------------------------------------
--Creating Support Tables

create table Governorate(
    GovID tinyint identity(1,1) primary key,
    GovName nvarchar(50) NOT NULL unique
);
go

create table UserRole(
    RoleID tinyint identity(1,1) PRIMARY KEY,
    RoleName   NVARCHAR(11)  NOT NULL UNIQUE,
    constraint CK_RoleName CHECK (RoleName IN ('Student', 'Instructor', 'Admin', 'Manager', 'CEO'))
);
go

create table Country(
    CountryID int identity(1,1) primary key,
    CountryName nvarchar(50) NOT NULL unique
);
go

create table CompanyType(
CTID tinyint identity(1,1) primary key,
CompanyType nvarchar(20) unique not null
);
go

create table Company(
    CompanyID int identity(1,1) primary key,
    CompanyName nvarchar(50) NOT NULL,
    Country_ID int NOT NULL,
    CompanyType_ID tinyint null,
    CONSTRAINT FK_Company_CountryID FOREIGN KEY (Country_ID) REFERENCES Country(CountryID),
    CONSTRAINT FK_Company_CompanyType FOREIGN KEY (CompanyType_ID) REFERENCES CompanyType(CTID)
);
go

create table MaritalStatus(
    MaritalStatID tinyint identity(1,1) PRIMARY KEY,
    MaritalStat NVARCHAR(9) NOT NULL UNIQUE,
    constraint CK_MaritalStat CHECK (MaritalStat IN ('Single', 'Engaged', 'Married', 'Divorced', 'Widowed'))
);
go

create table University(
    UniversityID int primary key,
    UniversityName nvarchar(50),
    Country_ID int not null,
    CONSTRAINT FK_University_Country FOREIGN KEY (Country_ID) REFERENCES Country(CountryID)
);
go

create table Faculty(
    FacultyID int primary key,
    FacultyName nvarchar(50)
);
go

create table JobType(
    JobTypeID tinyint identity(1,1) primary key,
    EmploymentType nvarchar(11),
    WorkMode nvarchar(7),
    constraint CK_EmpType CHECK (EmploymentType IN ('FullTime','PartTime','Internship')),
    constraint CK_Workmode CHECK (Workmode IN ('Onsite', 'Remote', 'Hybrid'))
);
go

create table Job(
    JobTitleID int identity(1,1) primary key,
    JobTitle nvarchar(50) not null unique
);
go

create table JobField(
    JobFieldID int identity(1,1) primary key,
    JobField nvarchar(50) not null unique
);
go

create table StudyField(
    StudyFieldID int identity(1,1) primary key,
    StudyFieldName nvarchar(50) not null unique
);
go

create table [Certificate](
    CertID int identity(1,1) primary key,
    CertName nvarchar(100) not null,
    [Hours] tinyint not null,
    Website nvarchar(100) not null,
    StudyField_ID int not null,
    constraint FK_Field_Cert foreign key(StudyField_ID) references StudyField(StudyFieldID)
);
go

create table Qtype(
    QtypeID tinyint identity(1,1) primary key,
    [Type] nvarchar(10) not null unique,
    CONSTRAINT CK_Qtype_Type CHECK ([Type] IN ('TrueFalse', 'MCQ', 'Text'))
);
go

-----------------------------------------------------------------------------------------------
-- Create Main Structure Tables

create table Department(
	DeptID tinyint identity(1,1) PRIMARY KEY,
	DeptName NVARCHAR(50) NOT NULL unique,
	IsActive bit NOT NULL Default 1
);
go

create table Track(
	TrackID tinyINT identity(1,1) PRIMARY KEY,
    TrackName NVARCHAR(50) NOT NULL unique,
	Dept_ID  tinyint NOT NULL,
	TotalHours INT NULL,
    [Description]  NVARCHAR(1000) NULL,
	IsActive bit NOT NULL Default 1,
	CONSTRAINT FK_Track_Dept FOREIGN KEY (Dept_ID) REFERENCES Department(DeptID)
);
go

create table Intake(
    IntakeID INT identity(1,1) PRIMARY KEY,
    IntakeName NVARCHAR(100) NOT NULL unique,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
	IsActive BIT DEFAULT 1
);
go

create table Course(
    CourseID INT identity(1,1) PRIMARY KEY,
    CourseName NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(1000) NULL,
    [Hours] int NOT NULL,
    MaxDegree INT not NULL,
    MinDegree INT not NULL
);
go

create table Branch(
	BranchID tinyint identity(1,1) PRIMARY KEY,
	BranchName nVARCHAR(50) NOT NULL unique,
    Gov_ID tinyint not null,
    IsActive bit NOT NULL Default 1,
    constraint FK_Branch_Gov foreign key(Gov_ID) references Governorate(GovID)
);
go

create table [Class](
    Branch_ID tinyINT NOT NULL,
    ClassNumber NVARCHAR(10) NOT NULL,
    ClassCapacity tinyint not null,
    CONSTRAINT FK_Class_Branch FOREIGN KEY (Branch_ID) REFERENCES Branch(BranchID),
	CONSTRAINT PK_Class PRIMARY KEY (Branch_ID,ClassNumber)
);
go

create table TrackCourse(
    Track_ID  tinyINT NOT NULL,
    Course_ID INT NOT NULL,
    CONSTRAINT PK_Track_Course PRIMARY KEY (Track_ID, Course_ID),
    CONSTRAINT FK_TC_Track  FOREIGN KEY (Track_ID)  REFERENCES Track(TrackID),
    CONSTRAINT FK_TC_Course FOREIGN KEY (Course_ID) REFERENCES Course(CourseID)
);
go

-----------------------------------------------------------------------------------------------
-- Create Users Tables

create table [User] (
    UserID INT identity(1,1) PRIMARY KEY,
	Role_ID tinyint NOT NULL,
    FullName NVARCHAR(60) NOT NULL,
    FullAddress nvarchar(200) NULL,
    Gov_ID tinyint NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    [Password] NVARCHAR(25) NOT NULL,
    Phone NVARCHAR(13) null,
    DOB DATE NOT NULL,
    Gender char(1) NOT NULL,
    MaritalStatus_ID tinyint not null,
    NumKids tinyint not null,
    StartDate DATE NOT NULL,
    EndDate Date null,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_User_Role FOREIGN KEY (Role_ID) REFERENCES UserRole(RoleID),
    CONSTRAINT FK_User_Gov FOREIGN KEY (Gov_ID) REFERENCES governorate(GovID),
    CONSTRAINT CK_gender_in CHECK (Gender in ('m', 'f')),
    constraint FK_User_MT foreign key(MaritalStatus_ID) references MaritalStatus(MaritalStatID)
);
go

create table BranchManager(
    ManagerID int,
    Branch_ID tinyint,
    YrsExp tinyint not null,
    Salary int not null,
    constraint PK_Manager_Branch primary key (ManagerID, Branch_ID),
    CONSTRAINT FK_Manager_User FOREIGN KEY (ManagerID) REFERENCES [User](UserID),
    constraint FK_Manager_Branch foreign key (Branch_ID) references Branch(BranchID)
);
go

create table [Admin](
    AdminID int primary key,
    Branch_ID tinyint,
    Salary int not null,
    CONSTRAINT FK_Admin_User FOREIGN KEY (AdminID) REFERENCES [User](UserID),
    constraint FK_Admin_Branch foreign key (Branch_ID) references Branch(BranchID)
);
go

create table Instructor (
    InstructorID int primary key,
    YrsExp tinyint not null,
    Salary int not null
    constraint FK_Instructor_User foreign key(InstructorID) references [User](UserID)
);
go

create table FulltimeInstructor(
    InstructorID int primary key,
    Dept_ID tinyint not null,
    Branch_ID tinyint not null,
    CONSTRAINT FK_FTInstructor_User FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    CONSTRAINT FK_FTInstructor_Department FOREIGN KEY (Dept_ID) REFERENCES Department(DeptID),
    CONSTRAINT FK_FTInstructor_Branch FOREIGN KEY (Branch_ID) REFERENCES Branch(BranchID),
);
go

create table ExternalInstructor(
    InstructorID int primary key,
    Company_ID int not null,
    JobTitle_ID int not null,
    JobField_ID int not null,
    JobType_ID tinyint not null,
    CONSTRAINT FK_Exinst_User FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    CONSTRAINT FK_ExInst_Company FOREIGN KEY (Company_ID) REFERENCES Company(CompanyID),
    CONSTRAINT FK_ExInst_Jtitle FOREIGN KEY (JobTitle_ID) REFERENCES Job(JobTitleID),
    CONSTRAINT FK_ExInst_Jfield FOREIGN KEY (JobField_ID) REFERENCES JobField(JobFieldID),
    constraint FK_ExtInst_JTID foreign key(JobType_ID) references JobType(JobTypeID)
);
go

create table InstructorCanTeach(
    Instructor_ID INT NOT NULL,
    Course_ID INT NOT NULL,
    CONSTRAINT PK_InstructorCourse PRIMARY KEY (Instructor_ID, Course_ID),
    CONSTRAINT FK_InstructorCourse_Instructor FOREIGN KEY(Instructor_ID) REFERENCES Instructor(InstructorID),
    CONSTRAINT FK_InstructorCourse_Course FOREIGN KEY (Course_ID) REFERENCES Course(CourseID)
);
go

create table [Open] (
    OpenID int identity(1,1) primary key,
    Track_ID  tinyINT NOT NULL,
    Intake_ID INT NOT NULL,
    Branch_ID tinyint NOT NULL,
    Supervisor_ID int not null,
    CONSTRAINT FK_Open_Track FOREIGN KEY (Track_ID) REFERENCES Track(TrackID),
    CONSTRAINT FK_Open_Intake FOREIGN KEY (Intake_ID) REFERENCES Intake(IntakeID),
    CONSTRAINT FK_Open_Branch FOREIGN KEY (Branch_ID) REFERENCES Branch(BranchID),
    constraint FK_Open_Super foreign key (Supervisor_ID) references FulltimeInstructor(InstructorID)
);
go

create table Student(
    StudentID int primary key,
    Open_ID int not null,
    University_ID int not null,
    Faculty_ID int not null,
    GradYear int not null,
    GPA Decimal(3,2) not null,
    CONSTRAINT FK_Student_User FOREIGN KEY (StudentID) REFERENCES [User](UserID),
    CONSTRAINT FK_Student_Branch FOREIGN KEY (Open_ID) REFERENCES [Open](OpenID),
    constraint FK_Student_University foreign key (University_ID) references University(UniversityID),
    constraint FK_Student_Faculty foreign key (Faculty_ID) references Faculty(FacultyID),
    constraint CK_Student_GPA check (GPA between 0 and 4)
);
go

CREATE TABLE StudentFreelance(
    FreelanceID int identity(1,1) primary key,
    Student_ID int NOT NULL,
    Revenue int NOT NULL,
    JobField_ID int NOT NULL,
    Feedback tinyint NOT NULL,
    CONSTRAINT FK_Student_Freelance FOREIGN KEY (Student_ID) REFERENCES Student(StudentID),
    CONSTRAINT FK_Freelance_Jfield FOREIGN KEY (JobField_ID) REFERENCES JobField(JobFieldID),
    CONSTRAINT CHK_Feedback CHECK (Feedback >= 0 AND Feedback <= 5)
);
go

create table GradJob(
    StudentID int primary key,
    Company_ID int not null,
    JobTitle_ID int not null,
    JobField_ID int not null,
    JobType_ID tinyint not null,
    Salary int not null,
    CONSTRAINT FK_Grad_User FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    CONSTRAINT FK_Grad_Company FOREIGN KEY (Company_ID) REFERENCES Company(CompanyID),
    CONSTRAINT FK_Grad_Jtitle FOREIGN KEY (JobTitle_ID) REFERENCES Job(JobTitleID),
    CONSTRAINT FK_Grad_Jfield FOREIGN KEY (JobField_ID) REFERENCES JobField(JobFieldID),
    constraint FK_GradJob_JTID foreign key(JobType_ID) references JobType(JobTypeID)
);
go

create table StudentExternalCertificate(
    Student_ID int not null,
    [Cert_ID] int not null,
    CONSTRAINT PK_Cert_Stud PRIMARY KEY (Student_ID, Cert_ID),
    CONSTRAINT FK_SEC_Stud FOREIGN KEY (Student_ID) REFERENCES Student(StudentID),
    constraint FK_SEC_Cert foreign key (Cert_ID) references Certificate(CertID)
);
go

create table StudentTakes(
    Student_ID INT NOT NULL,
    Course_ID INT NOT NULL,
    Finished BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_Take PRIMARY KEY (Student_ID, Course_ID),
    CONSTRAINT FK_Take_User FOREIGN KEY (Student_ID) REFERENCES Student(StudentID),
    CONSTRAINT FK_Take_Course FOREIGN KEY (Course_ID) REFERENCES Course(CourseID)
);
go

create table Teach(
    TeachID int identity(1,1) primary key,
    Instructor_ID INT NOT NULL,
    Course_ID INT NOT NULL,
    Open_ID int NOT NULL,
    CONSTRAINT FK_Teach_User FOREIGN KEY(Instructor_ID) REFERENCES Instructor(InstructorID),
    CONSTRAINT FK_Teach_Course FOREIGN KEY (Course_ID) REFERENCES Course(CourseID),
	CONSTRAINT FK_Teach_Open FOREIGN KEY (Open_ID) REFERENCES [Open](OpenID)
);
go

-----------------------------------------------------------------------------------------------
-- Create Examination Tables

create table Exam(
    ExamID INT identity(1,1) PRIMARY KEY,
    Teach_ID INT NOT NULL,
    StartTime TIME(0) NOT NULL,
    EndTime TIME(0) NOT NULL,
    ExamDate DATE NOT NULL,
    Score INT NULL,
    ExamType char(1) NOT NULL default('n'),
    Archived BIT NOT NULL DEFAULT (0),
    CONSTRAINT FK_Exam_Teach FOREIGN KEY (Teach_ID) REFERENCES Teach(TeachID),
    CONSTRAINT CK_Exam_TypeT CHECK (ExamType IN ('c', 'n')) -- c for Corrective & n for Normal
);
go

create table Schedule(
    ScheduleID int identity(1,1) primary key,
    Teach_ID int not null,
    StartTime time(0) not null,
    EndTime time(0) not null,
    [Date] Date not null,
    CONSTRAINT FK_Schedule_Teach FOREIGN KEY(Teach_ID) REFERENCES Teach(TeachID)
);
go

create table QuestionPool(
    QPID INT identity(1,1) PRIMARY KEY,
    Course_ID INT NOT NULL,
    Qtype_ID tinyint NOT NULL,
    [Description] NVARCHAR(1000) NOT NULL,
    CONSTRAINT FK_QPool_Course FOREIGN KEY (Course_ID) REFERENCES Course(CourseID),
    CONSTRAINT FK_QPool_Qtype FOREIGN KEY (Qtype_ID) REFERENCES Qtype(QtypeID)
);
go

create table AnswersMCQ(
    QP_ID INT NOT NULL,
    OptionID TINYINT NOT NULL,
    [Option] NVARCHAR(200) NOT NULL,
    IS_Correct BIT NOT NULL DEFAULT(0),
    CONSTRAINT PK_Answer_MCQ PRIMARY KEY (QP_ID, OptionID),
    CONSTRAINT FK_AMCQ_QP FOREIGN KEY (QP_ID) REFERENCES QuestionPool(QPID),
    CONSTRAINT CK_AMCQ_OptionID CHECK (OptionID BETWEEN 1 AND 4)
);
go

create table ExamQuestions(
    ExamQuestionID int identity(1,1) primary key,
    Exam_ID INT NOT NULL,
    QP_ID INT NOT NULL,
    Degree INT NOT NULL,
    CONSTRAINT FK_Choose_Exam FOREIGN KEY (Exam_ID) REFERENCES Exam(ExamID),
    CONSTRAINT FK_Choose_QP   FOREIGN KEY (QP_ID) REFERENCES QuestionPool(QPID)
);
go

create table StudentAnswer(
    Student_ID INT NOT NULL,
    ExamQuestion_ID int not null,
    Student_Answer NVARCHAR(1000) NULL,
	Qscore int not null,
    CONSTRAINT PK_Student_Answer PRIMARY KEY (Student_ID, ExamQuestion_ID),
    CONSTRAINT FK_SA_Student FOREIGN KEY (Student_ID) REFERENCES Student(StudentID),
    CONSTRAINT FK_SA_EQ FOREIGN KEY (ExamQuestion_ID) REFERENCES ExamQuestions(ExamQuestionID)
);
go

create table AnswerText(
    QP_ID INT NOT NULL PRIMARY KEY,
    Answer NVARCHAR(1000) NOT NULL,
    CONSTRAINT FK_AT_QP FOREIGN KEY (QP_ID) REFERENCES QuestionPool(QPID)
);
go

CREATE TABLE StudentExamResult(
    Student_ID INT NOT NULL,
    Exam_ID INT NOT NULL,
    TotalScore INT NOT NULL,
    IsPass BIT NOT NULL,
    CalculatedAt DATETIME NOT NULL CONSTRAINT DF_StudentExamResult_CalcAt DEFAULT (GETDATE()),
    CONSTRAINT PK_StudentExamResult PRIMARY KEY (Student_ID, Exam_ID),
    CONSTRAINT FK_SER_User FOREIGN KEY (Student_ID) REFERENCES Student(StudentID),
    CONSTRAINT FK_SER_Exam FOREIGN KEY (Exam_ID) REFERENCES Exam(ExamID)
);
go

-----------------------------------------------------------------------------------------------
-- Create Audit Tables

create table AuditExamSubmissions (
    Log_ID INT IDENTITY(1,1) PRIMARY KEY,
    User_ID INT NOT NULL,
    Exam_ID INT NOT NULL,
    Question_Pool_ID INT  NULL,
    Student_Answer NVARCHAR(max) NULL,
    Attempt_Time DATETIME DEFAULT GETDATE(),
);
go

CREATE TABLE AuditUserChanges (
    Log_ID INT IDENTITY(1,1) PRIMARY KEY,
    User_ID INT NOT NULL,
    Role_ID tinyint NOT NULL,
    Department_ID INT  NULL,
    Track_ID INT  NULL,
    Attempt_Time DATETIME DEFAULT GETDATE(),
    [Name] nvarchar(120) NOT NULL,
    Email nvarchar(120)  NULL
);
go