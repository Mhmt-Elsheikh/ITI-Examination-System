# source ~/Desktop/PyProjects/Environments/ITIExaminationSys/Scripts/Activate
from sqlalchemy import create_engine, text

connection_string = (
    "mssql+pyodbc:///?odbc_connect="
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=DESKTOP-QRRPVCL;"
    "DATABASE=ITIExaminationSystem;"
    "Trusted_Connection=yes;"
)
engine = create_engine(connection_string, echo=False)

#####################################################################
def AddDept(DeptName):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddDept
                    @DeptName = :DeptName
            """),
            {
                "DeptName": DeptName
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddDept('New Department')

def RemoveDept(DeptID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC RemoveDept
                    @DeptID = :DeptID
            """),
            {
                "DeptID": DeptID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# RemoveDept(1)

def AddTrack(TrackName, DeptID, TotalHours, Description):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddTrack
                    @TrackName = :TrackName,
                    @DeptID = :DeptID,
                    @TotalHours = :TotalHours,
                    @Description = :Description
            """),
            {
                "TrackName": TrackName,
                "DeptID": DeptID,
                "TotalHours": TotalHours,
                "Description": Description
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddTrack('New Track', 1, 120, 'This is a new track description.')

def RemoveTrack(TrackID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC RemoveTrack
                    @TrackID = :TrackID
            """),
            {
                "TrackID": TrackID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# RemoveTrack(1)

def NewIntake(IntakeName,StartDate,EndDate):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC NewIntake
                 @IntakeName = :IntakeName,
                 @StartDate = :StartDate,
                 @EndDate = :EndDate
            """),
            {
                "IntakeName": IntakeName,
                "StartDate": StartDate,
                "EndDate": EndDate
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# NewIntake('NewIntake22222', '2027-09-01', '2028-01-31')

def StopIntake(IntakeID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC StopIntake
                 @IntakeID = :IntakeID
            """),
            {
                "IntakeID": IntakeID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# StopIntake(1)

def AddCourse(CourseName,Description,MaxDegree,MinDegree,Hours):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                 Exec AddCourse
                    @CourseName = :CourseName,
                    @Description = :Description,
                    @MaxDegree = :MaxDegree,
                    @MinDegree = :MinDegree,
                    @Hours = :Hours
                 """),
                 {
                     "CourseName": CourseName,
                     "Description": Description,
                     "MaxDegree": MaxDegree,
                     "MinDegree": MinDegree,
                     "Hours": Hours
                 }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddCourse('Course','asdasda',100,60,3)

def AddTrackCourse(TrackID,CourseID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                 Exec AddTrackCourse
                    @TrackID = :TrackID,
                    @CourseID = :CourseID
                 """),
                 {
                     "TrackID": TrackID,
                     "CourseID": CourseID
                 }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddTrackCourse(1,1)

def RemoveTrackCourse(TrackID,CourseID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                 Exec RemoveTrackCourse
                    @TrackID = :TrackID,
                    @CourseID = :CourseID
                 """),
                 {
                     "TrackID": TrackID,
                     "CourseID": CourseID
                 }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# RemoveTrackCourse(1,7)

def NewOpenning(TrackID,IntakeID,BranchID,SuperID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                 Exec NewOpenning
                    @IntakeID = :IntakeID,
                    @TrackID = :TrackID,
                    @BranchID = :BranchID,
                    @SuperID = :SuperID
                 """),
                 {
                     "TrackID": TrackID,
                     "IntakeID": IntakeID,
                     "BranchID": BranchID,
                     "SuperID" : SuperID
                 }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# NewOpenning(1,1,1,6)

def Change_CEO(FullName, FullAddress, Governorate, Email, Password, Phone, DOB, Gender, MarStatusID, NumKids):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC Change_CEO
                    @FullName = :FullName,
                    @FullAddress = :FullAddress,
                    @Governorate = :Governorate,
                    @Email = :Email,
                    @Password = :Password,
                    @Phone = :Phone,
                    @DOB = :DOB,
                    @Gender = :Gender,
                    @MarStatusID = :MarStatusID,
                    @NumKids = :NumKids
                 """),
                 {
                    "FullName": FullName,
                    "FullAddress": FullAddress,
                    "Governorate": Governorate,
                    "Email": Email,
                    "Password": Password,
                    "Phone": Phone,
                    "DOB": DOB,
                    "Gender": Gender,
                    "MarStatusID": MarStatusID,
                    "NumKids": NumKids
                 })
        message = result.scalar()
        conn.commit()
        print(message)
# Change_CEO('New CEO', '321 Pine St', 'Cairo', 'Email@gmail','pass123', '0198765432', '1975-03-30', 'F',1,1)

def AssignBranchManager(FullName, FullAddress, Governorate, Email, Password, Phone, DOB, Gender, MarStatusID, NumKids, BranchID, YrsExp, Salary):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AssignBranchManager
                    @FullName     = :FullName,
                    @FullAddress  = :FullAddress,
                    @Governorate  = :Governorate,
                    @Email        = :Email,
                    @Password     = :Password,
                    @Phone        = :Phone,
                    @DOB          = :DOB,
                    @Gender       = :Gender,
                    @MarStatusID  = :MarStatusID,
                    @NumKids      = :NumKids,
                    @BranchID     = :BranchID,
                    @YrsExp = :YrsExp,
                    @Salary       = :Salary
            """),
            {
                "FullName": FullName,
                "FullAddress": FullAddress,
                "Governorate": Governorate,
                "Email": Email,
                "Password": Password,
                "Phone": Phone,
                "DOB": DOB,
                "Gender": Gender,
                "MarStatusID": MarStatusID,
                "NumKids": NumKids,
                "BranchID": BranchID,
                "YrsExp": YrsExp,
                "Salary": Salary
            }
        )

        message = result.scalar()
        conn.commit()
        print(message)
# AssignBranchManager("John Doe","123 Street","Alexandria","john@example.com","12345","01000000000","1990-01-01","M",1,0,1,5,15000)

def AddFulltimeInstructor(FullName, FullAddress, Governorate, Email, Password, Phone,
                          DOB, Gender, MarStatusID, NumKids, DeptID, BranchID,
                          Yrs_Experience, Salary):
        with engine.connect() as conn:
            result = conn.execute(
                text("""
                    EXEC AddFulltimeInstructor
                        @FullName = :FullName,
                        @FullAddress = :FullAddress,
                        @Governorate = :Governorate,
                        @Email = :Email,
                        @Password = :Password,
                        @Phone = :Phone,
                        @DOB = :DOB,
                        @Gender = :Gender,
                        @MarStatusID = :MarStatusID,
                        @NumKids = :NumKids,
                        @DeptID = :DeptID,
                        @BranchID = :BranchID,
                        @Yrs_Experience = :Yrs_Experience,
                        @Salary = :Salary
                """),
                {
                    "FullName": FullName,
                    "FullAddress": FullAddress,
                    "Governorate": Governorate,
                    "Email": Email,
                    "Password": Password,
                    "Phone": Phone,
                    "DOB": DOB,
                    "Gender": Gender,
                    "MarStatusID": MarStatusID,
                    "NumKids": NumKids,
                    "DeptID": DeptID,
                    "BranchID": BranchID,
                    "Yrs_Experience": Yrs_Experience,
                    "Salary": Salary
                }
            )
            message = result.scalar()
            conn.commit()
            print (message)
# AddFulltimeInstructor("Jane Doe","456 Test Ave","Cairo","jane.doe@example.com","Test1234","01012345678","1980-07-15","F",1,1,1,1,10,25000)

def AddExternalInstructor(FullName, FullAddress, Governorate, Email, Password, Phone,
                          DOB, Gender, MarStatusID, NumKids, Yrs_Experience, Salary,
                          CompanyName, JobTitle, JobField, JobTypeID):
        with engine.connect() as conn:
            result = conn.execute(
                text("""
                    EXEC AddExternalInstructor
                        @FullName = :FullName,
                        @FullAddress = :FullAddress,
                        @Governorate = :Governorate,
                        @Email = :Email,
                        @Password = :Password,
                        @Phone = :Phone,
                        @DOB = :DOB,
                        @Gender = :Gender,
                        @MarStatusID = :MarStatusID,
                        @NumKids = :NumKids,
                        @Yrs_Experience = :Yrs_Experience,
                        @Salary = :Salary,
                        @CompanyName = :CompanyName,
                        @JobTitle = :JobTitle,
                        @JobField = :JobField,
                        @JobTypeID = :JobTypeID
                """),
                {
                    "FullName": FullName,
                    "FullAddress": FullAddress,
                    "Governorate": Governorate,
                    "Email": Email,
                    "Password": Password,
                    "Phone": Phone,
                    "DOB": DOB,
                    "Gender": Gender,
                    "MarStatusID": MarStatusID,
                    "NumKids": NumKids,
                    "Yrs_Experience": Yrs_Experience,
                    "Salary": Salary,
                    "CompanyName": CompanyName,
                    "JobTitle": JobTitle,
                    "JobField": JobField,
                    "JobTypeID": JobTypeID
                }
            )
            message = result.scalar()
            conn.commit()
            print(message)
# AddExternalInstructor("Test", "123 Main St", "Tanta", "test.johnson@example.com", "SecurePass1","01234567891", "1985-04-10", "F", 1, 2, 8, 20000,"TechCorp", "Software Engineer", "IT", 1)

def RemoveInstructor(InstructorID):
        with engine.connect() as conn:
            result = conn.execute(
                text("""
                    EXEC RemoveInstructor
                        @InstructorID = :InstructorID
                """),
                {
                    "InstructorID": InstructorID
                }
            )
            message = result.scalar()
            conn.commit()
            print(message)
# RemoveInstructor(8)

def AddAdmin(FullName, FullAddress, Governorate, Email, Password, Phone,
             DOB, Gender, MarStatusID, NumKids, BranchID, Salary):
        with engine.connect() as conn:
            result = conn.execute(
                text("""
                    EXEC AddAdmin
                        @FullName = :FullName,
                        @FullAddress = :FullAddress,
                        @Governorate = :Governorate,
                        @Email = :Email,
                        @Password = :Password,
                        @Phone = :Phone,
                        @DOB = :DOB,
                        @Gender = :Gender,
                        @MarStatusID = :MarStatusID,
                        @NumKids = :NumKids,
                        @BranchID = :BranchID,
                        @Salary = :Salary
                """),
                {
                    "FullName": FullName,
                    "FullAddress": FullAddress,
                    "Governorate": Governorate,
                    "Email": Email,
                    "Password": Password,
                    "Phone": Phone,
                    "DOB": DOB,
                    "Gender": Gender,
                    "MarStatusID": MarStatusID,
                    "NumKids": NumKids,
                    "BranchID": BranchID,
                    "Salary": Salary
                }
            )
            message = result.scalar()
            conn.commit()
            print(message)
# AddAdmin("Alice Smith", "789 Test Blvd", "Giza", "alice.smith@example.com", "Pass1234", "01098765432", "1985-03-20", "F", 1, 0, 1, 30000)

def RemoveAdmin(AdminID):
        with engine.connect() as conn:
            result = conn.execute(
                text("""
                    EXEC RemoveAdmin
                        @AdminID = :AdminID
                """),
                {
                    "AdminID": AdminID
                }
            )
            message = result.scalar()
            conn.commit()
            print(message)
# RemoveAdmin(5)

def AddStudent(FullName, FullAddress, Governorate, Email, Password, Phone,
               DOB, Gender, MarStatusID, NumKids, OpenID, UniversityName,
               FacultyName, GradYear, GPA):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddStudent
                    @FullName = :FullName,
                    @FullAddress = :FullAddress,
                    @Governorate = :Governorate,
                    @Email = :Email,
                    @Password = :Password,
                    @Phone = :Phone,
                    @DOB = :DOB,
                    @Gender = :Gender,
                    @MarStatusID = :MarStatusID,
                    @NumKids = :NumKids,
                    @OpenID = :OpenID,
                    @UniversityName = :UniversityName,
                    @FacultyName = :FacultyName,
                    @GradYear = :GradYear,
                    @GPA = :GPA
            """),
            {
                "FullName": FullName,
                "FullAddress": FullAddress,
                "Governorate": Governorate,
                "Email": Email,
                "Password": Password,
                "Phone": Phone,
                "DOB": DOB,
                "Gender": Gender,
                "MarStatusID": MarStatusID,
                "NumKids": NumKids,
                "OpenID": OpenID,
                "UniversityName": UniversityName,
                "FacultyName": FacultyName,
                "GradYear": GradYear,
                "GPA": GPA
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddStudent("Alice Smith", "123 College St", "Alexandria", "alice@example.com", "Pass1234", "01011112222",
#            "2000-05-12", "F", 1, 0, 1, "Alex University", "Computer Science", 2024, 3.75)


def RemoveStudent(StudentID):
        with engine.connect() as conn:
            result = conn.execute(
                text("""
                    EXEC RemoveStudent
                        @StudentID = :StudentID
                """),
                {
                    "StudentID": StudentID
                }
            )
            message = result.scalar()
            conn.commit()
            print(message)
# RemoveStudent(13)

def OpenNewBranch(BranchName, BranchGovName, FullName, FullAddress, Governorate, Email, Password,
                  Phone, DOB, Gender, MarStatusID, NumKids, YrsExp, Salary):
        with engine.connect() as conn:
            result = conn.execute(
                text("""
                    EXEC OpenNewBranch
                        @BranchName = :BranchName,
                        @BranchGovName = :BranchGovName,
                        @FullName = :FullName,
                        @FullAddress = :FullAddress,
                        @Governorate = :Governorate,
                        @Email = :Email,
                        @Password = :Password,
                        @Phone = :Phone,
                        @DOB = :DOB,
                        @Gender = :Gender,
                        @MarStatusID = :MarStatusID,
                        @NumKids = :NumKids,
                        @YrsExp = :YrsExp,
                        @Salary = :Salary
                """),
                {
                    "BranchName": BranchName,
                    "BranchGovName": BranchGovName,
                    "FullName": FullName,
                    "FullAddress": FullAddress,
                    "Governorate": Governorate,
                    "Email": Email,
                    "Password": Password,
                    "Phone": Phone,
                    "DOB": DOB,
                    "Gender": Gender,
                    "MarStatusID": MarStatusID,
                    "NumKids": NumKids,
                    "YrsExp": YrsExp,
                    "Salary": Salary
                }
            )
            message = result.scalar()
            conn.commit()
            print(message)
# OpenNewBranch("Central Branch2", "Cairo2", "John Doe2", "123 Main St2", "Cairo2", "john@example.com2", "123452","01000000002", "1985-02-15", "M", 1, 2, 5, 20000)

def RemoveBranch(BranchID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC RemoveBranch
                    @BranchID = :BranchID
            """),
            {
                "BranchID": BranchID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# RemoveBranch(7)

def AddClass(BranchID, ClassNumber, ClassCap):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddClass
                    @BranchID = :BranchID,
                    @ClassNumber = :ClassNumber,
                    @ClassCap = :ClassCap
            """),
            {
                "BranchID": BranchID,
                "ClassNumber": ClassNumber,
                "ClassCap": ClassCap
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddClass(1, "C101", 30)

def RemoveClass(BranchID, ClassNumber):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC RemoveClass
                    @BranchID = :BranchID,
                    @ClassNumber = :ClassNumber
            """),
            {
                "BranchID": BranchID,
                "ClassNumber": ClassNumber
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# RemoveClass(1, "C101")

def AddGradJob(StudentID, CompanyName, JobTitle, JobField, JobTypeID, Salary):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddGradJob
                    @StudentID = :StudentID,
                    @CompanyName = :CompanyName,
                    @JobTitle = :JobTitle,
                    @JobField = :JobField,
                    @JobTypeID = :JobTypeID,
                    @Salary = :Salary
            """),
            {
                "StudentID": StudentID,
                "CompanyName": CompanyName,
                "JobTitle": JobTitle,
                "JobField": JobField,
                "JobTypeID": JobTypeID,
                "Salary": Salary
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddGradJob(16, "TechCorp", "Software Engineer", "IT", 1, 15000)

def AddStudExtCert(StudentID, CertName):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddStudExtCert
                    @StudentID = :StudentID,
                    @CertName  = :CertName
            """),
            {
                "StudentID": StudentID,
                "CertName": CertName
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddStudExtCert(16, "Google Data Analytics")

def AddStudentFreelance(StudentID, Revenue, JobField, Feedback, MaxFeedback):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddStudentFreelance
                    @StudentID   = :StudentID,
                    @Revenue     = :Revenue,
                    @JobField    = :JobField,
                    @Feedback    = :Feedback,
                    @MaxFeedback = :MaxFeedback
            """),
            {
                "StudentID": StudentID,
                "Revenue": Revenue,
                "JobField": JobField,
                "Feedback": Feedback,
                "MaxFeedback": MaxFeedback
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddStudentFreelance(16, 12000, "Data Analysis", 80, 100)

def AddStudentTakes(StudentID, CourseID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddStudentTakes
                    @StudentID = :StudentID,
                    @CourseID = :CourseID
            """),
            {
                "StudentID": StudentID,
                "CourseID": CourseID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddStudentTakes(16,1)

def RemoveStudentTakes(StudentID, CourseID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC RemoveStudentTakes
                    @StudentID = :StudentID,
                    @CourseID = :CourseID
            """),
            {
                "StudentID": StudentID,
                "CourseID": CourseID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# RemoveStudentTakes(16,1)

def AddSchedule(TeachID, StartTime, EndTime, Date):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddSchedule
                    @TeachID = :TeachID,
                    @StartTime = :StartTime,
                    @EndTime = :EndTime,
                    @Date = :Date
            """),
            {
                "TeachID": TeachID,
                "StartTime": StartTime,
                "EndTime": EndTime,
                "Date": Date
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddSchedule(12, "10:00", "12:00", "2025-05-10")

def Add_InstructorCanTeach(InstructorID, CourseID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC Add_InstructorCanTeach
                    @InstructorID = :InstructorID,
                    @CourseID = :CourseID
            """),
            {
                "InstructorID": InstructorID,
                "CourseID": CourseID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# Add_InstructorCanTeach(6, 1)

def Remove_InstructorCanTeach(InstructorID, CourseID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC Remove_InstructorCanTeach
                    @InstructorID = :InstructorID,
                    @CourseID = :CourseID
            """),
            {
                "InstructorID": InstructorID,
                "CourseID": CourseID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# Remove_InstructorCanTeach(6, 1)

def AssignInstructorCourse(instructor_id, course_id, open_id):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AssignInstructorCourse
                    @InstructorID = :InstructorID,
                    @CourseID = :CourseID,
                    @OpenID = :OpenID
            """),
            {
                "InstructorID": instructor_id,
                "CourseID": course_id,
                "OpenID": open_id
            }
        )
        message = result.scalar()  # fetch the single message returned by the procedure
        conn.commit()
        print(message)
# AssignInstructorCourse(6, 1, 1)

def ReassignNew_InstructorCourse(InstructorID, CourseID, OpenID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC ReassignNew_InstructorCourse
                    @InstructorID = :InstructorID,
                    @CourseID = :CourseID,
                    @OpenID = :OpenID
            """),
            {
                "InstructorID": InstructorID,
                "CourseID": CourseID,
                "OpenID": OpenID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# ReassignNew_InstructorCourse(5, 3, 1)

def CreateExam(CourseID, StartTime, EndTime, Date, Score, ExamType, OpenID, InstructorID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC CreateExam
                    @CourseID = :CourseID,
                    @StartTime = :StartTime,
                    @EndTime = :EndTime,
                    @Date = :Date,
                    @Score = :Score,
                    @ExamType = :ExamType,
                    @OpenID = :OpenID,
                    @InstructorID = :InstructorID
            """),
            {
                "CourseID": CourseID,
                "StartTime": StartTime,
                "EndTime": EndTime,
                "Date": Date,
                "Score": Score,
                "ExamType": ExamType,
                "OpenID": OpenID,
                "InstructorID": InstructorID
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# CreateExam(1, "09:00", "11:00", "2025-12-20", 100, "c", 1, 6)

def AddQuestionUnified(Course_ID, Type_ID, Description, 
                       Option1=None, Option2=None, Option3=None, Option4=None, 
                       CorrectOption=None, TextAnswer=None):
    with engine.begin() as conn:  # auto-commits
        result = conn.execute(
            text("""
                EXEC AddQuestionUnified
                    @Course_ID = :Course_ID,
                    @Type_ID = :Type_ID,
                    @Description = :Description,
                    @Option1 = :Option1,
                    @Option2 = :Option2,
                    @Option3 = :Option3,
                    @Option4 = :Option4,
                    @CorrectOption = :CorrectOption,
                    @TextAnswer = :TextAnswer
            """),
            {
                "Course_ID": Course_ID,
                "Type_ID": Type_ID,
                "Description": Description,
                "Option1": Option1,
                "Option2": Option2,
                "Option3": Option3,
                "Option4": Option4,
                "CorrectOption": CorrectOption,
                "TextAnswer": TextAnswer
            }
        )
        # message = result.scalar()
        conn.commit()
        # print(message)
# # MCQ
# AddQuestionUnified(1, 1, "What is 2+2?", "2", "3", "4", "5", 3)
# # True/False
# AddQuestionUnified(1, 2, "Python is a snake?", CorrectOption=2)
# # Text
# AddQuestionUnified(1, 3, "Explain recursion.", TextAnswer="A function calling itself.")

def RemoveQuestionUnified(QPID):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC RemoveQuestionUnified
                    @QPID = :QPID
            """),
            {"QPID": QPID}
        )
        message = result.scalar()
        conn.commit()
        print(message)
# RemoveQuestionUnified(20)

def AddQuestionToExam_SP(ExamID, QPID, Degree):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC AddQuestionToExam
                    @ExamID = :ExamID,
                    @QPID = :QPID,
                    @Degree = :Degree
            """),
            {
                "ExamID": ExamID,
                "QPID": QPID,
                "Degree": Degree
            }
        )
        message = result.scalar()
        conn.commit()
        print(message)
# AddQuestionToExam_SP(1, 22, 10)


def PopulateExamChooseAuto_SP(examid, questioncount=10, allowedtypes='1,2,3'):
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                EXEC PopulateExamChooseAuto
                    @examid = :examid,
                    @questioncount = :questioncount,
                    @allowedtypes = :allowedtypes
            """),
            {
                "examid": examid,
                "questioncount": questioncount,
                "allowedtypes": allowedtypes
            }
        )
        # try:
        #     message = result.scalar()
        # except:
        #     message = None
        conn.commit()
        # print(message)
# PopulateExamChooseAuto_SP(1, 3, '1,2,3')

def ProcessFinishedExamsAndArchive_SP():
    with engine.connect() as conn:
        try:
            result = conn.execute(
                text("""
                    EXEC ProcessFinishedExamsAndArchive
                """)
            )
            for row in result:
                print(row)
        except Exception as e:
            print("Error:", e)
# ProcessFinishedExamsAndArchive_SP()

def StudentAnswer_PROCEDURE(student_id: int, exam_id: int, question_id: int, student_answer: str):
    with engine.connect() as conn:
        conn.execute(
            text("""
                EXEC dbo.StudentAnswer_PROCEDURE
                    @Student_ID = :student_id,
                    @exam_id = :exam_id,
                    @question_id = :question_id,
                    @student_answer = :student_answer
            """),
            {
                "student_id": student_id,
                "exam_id": exam_id,
                "question_id": question_id,
                "student_answer": student_answer,
            }
        )
        conn.commit()
    print(f"Answer for Student {student_id}, Question {question_id} submitted successfully.")

StudentAnswer_PROCEDURE(16, 1, 22, "C")