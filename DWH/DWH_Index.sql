use ITI_DWH;
go


CREATE NONCLUSTERED INDEX IX_DimUser_Role_IsActive
ON Dim_User (RoleName, IsActive);
go
CREATE NONCLUSTERED INDEX IX_DimUser_FullName
ON Dim_User (FullName);
go
CREATE NONCLUSTERED INDEX IX_DimUser_Email
ON Dim_User (Email);
go


CREATE NONCLUSTERED INDEX IX_DimTrack_IsActive
ON Dim_Track (IsActive);
go
CREATE NONCLUSTERED INDEX IX_DimTrack_DeptName
ON Dim_Track (DeptName);
go


CREATE NONCLUSTERED INDEX IX_DimIntake_IsActive
ON Dim_Intake (IsActive);
go
CREATE NONCLUSTERED INDEX IX_DimIntake_Start_End
ON Dim_Intake (StartDate, EndDate);
go


CREATE NONCLUSTERED INDEX IX_DimExam_ExamType
ON Dim_Exam (ExamType);
go
CREATE NONCLUSTERED INDEX IX_DimExam_Archived
ON Dim_Exam (Archived);
go


CREATE NONCLUSTERED INDEX IX_DimQP_CourseName
ON Dim_QP (CourseName);
go
CREATE NONCLUSTERED INDEX IX_DimQP_Qtype
ON Dim_QP (Qtype);
go


CREATE NONCLUSTERED INDEX IX_FactStudent_StudentID
ON Fact_Student (Student_ID);
go
CREATE NONCLUSTERED INDEX IX_FactStud_Start_End
ON Fact_Student (StartDate, EndDate);

CREATE NONCLUSTERED INDEX IX_FactStudent_TrackID
ON Fact_Student (Track_ID);
go
CREATE NONCLUSTERED INDEX IX_FactStudent_BranchID
ON Fact_Student (Branch_ID);

CREATE NONCLUSTERED INDEX IX_FactStudent_IntakeID
ON Fact_Student (Intake_ID);
go
CREATE NONCLUSTERED INDEX IX_FactStudent_UniversityID
ON Fact_Student (University_ID);
go


CREATE NONCLUSTERED INDEX IX_FactFreelance_StudentID
ON Fact_StudentFreelance (Student_ID);
go


CREATE NONCLUSTERED INDEX IX_GradJob_StudentID
ON Fact_GradJob (Student_ID);
go
CREATE NONCLUSTERED INDEX IX_GradJob_CompanyID
ON Fact_GradJob (Company_ID);
go
CREATE NONCLUSTERED INDEX IX_GradJob_JobTypeID
ON Fact_GradJob (JobType_ID);
go


CREATE NONCLUSTERED INDEX IX_StudCert_StudentID
ON Fact_StudentExternalCertificate (Student_ID);
go
CREATE NONCLUSTERED INDEX IX_StudCert_CertificateID
ON Fact_StudentExternalCertificate (Certificate_ID);
go


CREATE NONCLUSTERED INDEX IX_Fulltime_InstructorID
ON Fact_Fulltime (Instructor_ID);
go
CREATE NONCLUSTERED INDEX IX_Fulltime_DeptID
ON Fact_Fulltime (Dept_ID);
go
CREATE NONCLUSTERED INDEX IX_FactFull_Start_End
ON Fact_Fulltime (StartDate, EndDate);
go
CREATE NONCLUSTERED INDEX IX_Fulltime_BranchID
ON Fact_Fulltime (Branch_ID);
go


CREATE NONCLUSTERED INDEX IX_External_InstructorID
ON Fact_External (Instructor_ID);
go
CREATE NONCLUSTERED INDEX IX_External_CompanyID
ON Fact_External (Company_ID);
go
CREATE NONCLUSTERED INDEX IX_FactExt_Start_End
ON Fact_External (StartDate, EndDate);
go
CREATE NONCLUSTERED INDEX IX_External_JobTypeID
ON Fact_External (JobType_ID);
go


CREATE NONCLUSTERED INDEX IX_CanTeach_InstructorID
ON Fact_InstructorCanTeach (Instructor_ID);
go
CREATE NONCLUSTERED INDEX IX_CanTeach_CourseID
ON Fact_InstructorCanTeach (Course_ID);
go


CREATE NONCLUSTERED INDEX IX_Teach_InstructorID
ON Fact_Teach (Instructor_ID);
go
CREATE NONCLUSTERED INDEX IX_Teach_CourseID
ON Fact_Teach (Course_ID);
go
CREATE NONCLUSTERED INDEX IX_Teach_TrackID
ON Fact_Teach (Track_ID);
go
CREATE NONCLUSTERED INDEX IX_Teach_BranchID
ON Fact_Teach (Branch_ID);
go
CREATE NONCLUSTERED INDEX IX_Teach_IntakeID
ON Fact_Teach (Intake_ID);
go


CREATE NONCLUSTERED INDEX IX_Open_SuperID
ON Fact_Open (SuperID);
go
CREATE NONCLUSTERED INDEX IX_Open_TrackID
ON Fact_Open (Track_ID);
go
CREATE NONCLUSTERED INDEX IX_Open_BranchID
ON Fact_Open (Branch_ID);
go
CREATE NONCLUSTERED INDEX IX_Open_IntakeID
ON Fact_Open (Intake_ID);
go

CREATE NONCLUSTERED INDEX IX_TrackCourse_TrackID
ON Fact_TrackCourse (Track_ID);
go
CREATE NONCLUSTERED INDEX IX_TrackCourse_CourseID
ON Fact_TrackCourse (Course_ID);
go


CREATE NONCLUSTERED INDEX IX_Exam_ExamID
ON Fact_Exam (Exam_ID);
go
CREATE NONCLUSTERED INDEX IX_Exam_InstructorID
ON Fact_Exam (Instructor_ID);

CREATE NONCLUSTERED INDEX IX_Exam_CourseID
ON Fact_Exam (Course_ID);
go
CREATE NONCLUSTERED INDEX IX_Exam_TrackID
ON Fact_Exam (Track_ID);
go
CREATE NONCLUSTERED INDEX IX_Exam_IntakeID
ON Fact_Exam (Intake_ID);
go
CREATE NONCLUSTERED INDEX IX_Exam_BranchID
ON Fact_Exam (Branch_ID);
go


CREATE NONCLUSTERED INDEX IX_ExamQuestions_ExamID
ON Fact_ExamQuestions (Exam_ID);
go
CREATE NONCLUSTERED INDEX IX_ExamQuestions_QPID
ON Fact_ExamQuestions (QP_ID);
go


CREATE NONCLUSTERED INDEX IX_StudentExamResult_StudentID
ON Fact_StudentExamResult (Student_ID);
go
CREATE NONCLUSTERED INDEX IX_StudentExamResult_ExamID
ON Fact_StudentExamResult (Exam_ID);
