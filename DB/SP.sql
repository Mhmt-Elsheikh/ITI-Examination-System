use ITIExaminationSystem
go

CREATE OR ALTER FUNCTION ufn_DefaultIntakeID()
RETURNS INT
as
begin
    DECLARE @id INT;
    SELECT @id = MAX(IntakeID) FROM Intake;
    RETURN @id;
END;
go
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/* Adding Governorate */
create or alter procedure AddGov
    @GovName nvarchar(50)
as
begin
set nocount on;
    insert into Governorate (GovName)
    values(@GovName);
    return 0;
end;
go
----------------------------------------------------------
/* Adding Country */
create or alter procedure AddCountry
    @CountryName nvarchar(50)
as
begin
set nocount on;
    insert into Country (CountryName)
    values (@CountryName);
    return 0;
end;
go
----------------------------------------------------------
/* Adding Company */
create or alter procedure AddCompanyType
    @CompanyType nvarchar(20)
as
begin
set nocount on;
    insert into CompanyType (CompanyType)
    values (@CompanyType);
    return 0;
end;
go

create or alter procedure AddCompany
    @CompanyName nvarchar(50),
    @CountryName nvarchar(50),
    @CompanyType nvarchar(20)
as
begin
set nocount on;
    declare @CountryID int;
    declare @CompanyTypeID int;
    declare @NewCompanyID int;

    select @CountryID = CountryID from Country where CountryName = @CountryName;
    if @CountryID is null
    begin
        exec AddCountry @CountryName;
        select @CountryID = CountryID from Country where CountryName = @CountryName;
    end
    select @CompanyTypeID = CTID from CompanyType where CompanyType = @CompanyType;
    if @CompanyTypeID is null
    begin
        exec AddCompanyType @CompanyType;
        select @CompanyTypeID = CTID from CompanyType where CompanyType = @CompanyType;
    end
    insert into Company (CompanyName, Country_ID, CompanyType_ID)
    values (@CompanyName, @CountryID, @CompanyTypeID);
    return 0;
end;
go
----------------------------------------------------------
/* Adding Jobs */
create or alter procedure AddJob
    @JobTitle nvarchar(50)
as
begin
set nocount on;
    insert into Job (JobTitle)
    values (@JobTitle);
    return 0;
end;
go

create or alter procedure AddJobField
    @JobField nvarchar(50)
as
begin
set nocount on;
    insert into JobField (JobField)
    values (@JobField);
    return 0;
end;
go
----------------------------------------------------------
/* Study Fields & Certificates */
create or alter procedure AddStudyField
    @StudyFieldName nvarchar(50)
as
begin
set nocount on;
    insert into StudyField(StudyFieldName)
    values(@StudyFieldName);
    return 0;
end;
go

create or alter procedure AddCertificate
    @CertName nvarchar(100),
    @Hours tinyint,
    @Website nvarchar(100),
    @StudyFieldName nvarchar(50)
as
begin
set nocount on;
    declare @StudyFieldID int;
    select @StudyFieldID = StudyFieldID from StudyField where StudyFieldName = @StudyFieldName;
    if @StudyFieldID is null
    begin
        Exec AddStudyField @StudyFieldName=@StudyFieldName;
        select @StudyFieldID = StudyFieldID from StudyField where StudyFieldName = @StudyFieldName;
    end;

    insert into [Certificate](CertName, [Hours], Website, StudyField_ID)
    values(@CertName, @Hours, @Website, @StudyFieldID);
    return 0;
end;
go
----------------------------------------------------------
/* University & Faculty */
create or alter procedure AddUniversity
    @UniversityName nvarchar(50),
    @CountryName nvarchar(50)
as
begin
set nocount on;
    declare @CountryID int;
    select @CountryID = CountryID from Country where CountryName = @CountryName;
    if @CountryID is null
    begin
        Exec AddCountry @CountryName = @CountryName;
        select @CountryID = CountryID from Country where CountryName = @CountryName;
    end;

    insert into University(UniversityName, Country_ID)
    values(@UniversityName,@CountryID);
    return 0;
end;
go

create or alter procedure AddFaculty
    @FacultyName nvarchar(50)
as
begin
set nocount on;
    insert into Faculty(FacultyName)
    values(@FacultyName);
    return 0;
end;
go
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/* Adding & Removing Departments */
create or alter procedure AddDept
	@DeptName NVARCHAR(50)
as
begin
set nocount on;
    if exists(select 1 from Department where DeptName = @DeptName and IsActive = 1)
    begin
        select 'Department is already Active' as Message;
        return 1;
    end;
    if exists(select 1 from Department where DeptName = @DeptName and IsActive = 0)
    begin
        update Department set IsActive = 1 where DeptName = @DeptName and IsActive = 0;
        select 'InActive Department Reactivated' as Message;
        return 0;
    end;
    
	insert into Department (DeptName)
	values (@DeptName);
    select 'Department Added' as Message;
    return 0;
end;
go

create or alter procedure RemoveDept
	@DeptID tinyint
as
begin
set nocount on;
    if not exists(select 1 from Department where DeptID = @DeptID and IsActive = 1)
    begin
        select 'Department not found or InActive' as Message;
        return 1;
    end;

    if exists(select 1 from Track where Dept_ID = @DeptID and IsActive = 1)
    begin
        select 'Cant remove, Active tracks are assigned to this department' as Message;
        select * from Track where Dept_ID = @DeptID and IsActive = 1;
        return 1;
    end;

    if exists(select 1 from FulltimeInstructor i join [User] u on i.InstructorID = u.UserID where i.Dept_ID = @DeptID and u.IsActive = 1)
    begin
        select 'Cant remove, Active instructors are assigned to this department' as Message;
        return 1;
    end;

	update Department set IsActive = 0
	where DeptID = @DeptID;
    select 'Department removed successfully' as Message;
    return 0;
end;
go
----------------------------------------------------------
/* Adding Removing Tracks */
create or alter procedure AddTrack
    @TrackName NVARCHAR(60),
	@DeptID tinyint,
	@TotalHours INT,
    @Description NVARCHAR(1000)
as
begin
set nocount on;
    if not exists (select 1 from Department where DeptID = @DeptID and IsActive = 1)
    begin
        select 'Cannot add Track. Department is not available or inactive' as Message;
        return 1;
    end;

    if exists(select 1 from Track where TrackName = @TrackName and IsActive = 1 and Dept_ID = @DeptID)
    begin
        select 'Track is already Active' as Message;
        return 0;
    end;

    if exists(select 1 from Track where TrackName = @TrackName and IsActive = 0 and Dept_ID = @DeptID)
    begin
        update Track set IsActive = 1, Description = @Description where TrackName = @TrackName and IsActive = 0 and Dept_ID = @DeptID;
        select 'InActive Track Reactivated' as Message;
        return 0;
    end;

	insert into Track(TrackName,Dept_ID,TotalHours,[Description])
	values(@TrackName,@DeptID,@TotalHours,@Description)
    select 'Track Added Successfully' as Message;
    return 0;
end;
go

create or alter procedure RemoveTrack
    @TrackID tinyint
as
begin
set nocount on;
    if not exists(select 1 from Track where TrackID = @TrackID and IsActive = 1)
    begin
        select 'Invalid Track' as Message;
        return 1;
    end;

    if exists(select 1 from [Open] o join Intake i on o.Intake_ID = i.IntakeID where i.IsActive = 1 and o.Track_ID = @TrackID)
    begin
        select 'Cannot remove Track due to Active intake' as Message;
        return 1;
    end;

    update Track set IsActive = 0 where TrackID = @TrackID;
    select 'Track removed successfully' as Message;
    return 0;
end;
go
----------------------------------------------------------
/* Adding Removing Intake */
create or alter procedure NewIntake
    @IntakeName NVARCHAR(100),
    @StartDate DATE,
    @EndDate DATE
as
begin
set nocount on;
    IF EXISTS (SELECT 1 FROM Intake WHERE IntakeName = @IntakeName)
    BEGIN
        select 'Intake name already exists' as Message;
        RETURN 1;
    END;

    if @EndDate <= @StartDate
		begin
			select 'Error: EndDate must be greater than StartDate' as Message;
			return 1;
		end;

		insert into Intake(IntakeName,StartDate,EndDate)
		values(@IntakeName,@StartDate,@EndDate);
        select 'Intake Added Successfully' as Message;
        return 0;
end;
go

create or alter procedure StopIntake
    @IntakeID int
as
begin
set nocount on;
    if not exists (select 1 from Intake where IntakeID = @IntakeID)
    begin
        select 'Invalid Intake ID' as Message;
        return 1;
    end;
    declare @CurrentDate date = getdate();
    declare @IntakeEndDate DATE, @IntakeStartDate Date

    select @IntakeEndDate = EndDate from Intake where IntakeID = @IntakeID;
    select @IntakeStartDate = StartDate from Intake where IntakeID = @IntakeID;

    if @CurrentDate < @IntakeStartDate
    begin
        delete from Intake where IntakeID = @IntakeID;
        select 'Intake Deleted' as Message;
        return 1;
    end;
    if @IntakeEndDate > @CurrentDate and @IntakeStartDate < @CurrentDate
    begin
        select 'This intake is currently running, cannot stop it yet' as Message;
        return 1;
    end;

    begin try
        begin transaction;
            update Intake set IsActive = 0 where IntakeID = @IntakeID;
            update u set IsActive = 0, EndDate = @CurrentDate from [User] u join Student s ON s.StudentID = u.UserID join [Open] o ON o.OpenID = s.Open_ID where o.Intake_ID = @IntakeID;
        commit transaction;
        select 'Intake Stopped and Students Deactivated' as Message;
        return 0;
    end try
    begin catch
        IF @@TRANCOUNT > 0
        begin
            rollback transaction;
        end;
        select ('Error: ' + ERROR_MESSAGE()) as Message;
        RETURN 1;
    END CATCH
end;
go
----------------------------------------------------------

----------------------------------------------------------
/* Courses */
CREATE OR ALTER procedure AddCourse
    @CourseName NVARCHAR(50),
    @Description NVARCHAR(400),
    @MaxDegree INT,
    @MinDegree INT,
    @Hours int
as
begin
set nocount on;
    if exists (select 1 from Course where CourseName = @CourseName)
    begin
        update Course set [Description] = @Description, MaxDegree = @MaxDegree, MinDegree = @MinDegree, [Hours] = @Hours;
        select 'Course info updated successfully' as Message;
        return 0;
    end;

    insert into Course (CourseName, [description], [Hours], MaxDegree, MinDegree)
    values (@CourseName, @Description, @Hours, @MaxDegree, @MinDegree);
    select 'Course Added' as Message;
    return 0;
end;
go

CREATE OR ALTER PROCEDURE AddTrackCourse
    @TrackID INT,
    @CourseID INT
AS
BEGIN
set nocount on;
    if not exists(select 1 from Track where TrackID = @TrackID and IsActive = 1)
    begin
        select 'Invalid Track ID' as Message;
        return 1;
    end;
    if not exists(select 1 from Course where CourseID = @CourseID)
    begin
        select 'Invalid Course ID' as Message;
        return 1;
    end;

    if exists(select 1 from TrackCourse where Course_ID = @CourseID and Track_ID = @TrackID)
    begin
        select 'Course already exists in Track' as Message;
    end;

    INSERT INTO TrackCourse (Track_ID, Course_ID)
    VALUES (@TrackID, @CourseID);
    select 'Course Added to Track Successfully' as Message;
    return 0;
END;
go

CREATE OR ALTER PROCEDURE RemoveTrackCourse
    @TrackID INT,
    @CourseID INT
AS
BEGIN
set nocount on;
    if not exists(select 1 from Track where TrackID = @TrackID and IsActive = 1)
    begin
        select 'Invalid Track ID' as Message;
        return 1;
    end;
    if not exists(select 1 from Course where CourseID = @CourseID)
    begin
        select 'Invalid Course ID' as Message;
        return 1;
    end;

    DELETE FROM TrackCourse
    WHERE Track_ID = @TrackID AND Course_ID = @CourseID;
    select 'Course Removed from Track' as Message;
    return 0;
END;
go
----------------------------------------------------------
/* Open */
create or alter procedure NewOpenning
    @TrackID tinyint,
    @IntakeID int,
    @BranchID tinyint,
    @SuperID int
as
begin
set nocount on;
    if not exists(select 1 from FulltimeInstructor i join Branch b on i.Branch_ID = b.BranchID join [User] u on i.InstructorID = u.UserID where u.IsActive=1 and b.IsActive=1 and i.InstructorID = @SuperID)
    begin
        select 'Invalid Instructor' as Message;
        return 1;
    end;
    if exists(select 1 from [Open] o join Intake i on o.Intake_ID = i.IntakeID where o.Supervisor_ID = @SuperID and i.IsActive = 1)
    begin
        select 'Instructor is already a supervisor' as Message;
        return 1;
    end;

    declare @TrackID_test int, @IntakeID_test int, @BranchID_test TINYINT;
    select @TrackID_test = TrackID from Track where TrackID = @TrackID and IsActive = 1;
    select @IntakeID_test = IntakeID from Intake where IntakeID = @IntakeID and IsActive = 1;
    select @BranchID_test = BranchID from Branch where BranchID = @BranchID and IsActive = 1;
    if @TrackID_test is null or @IntakeID_test is null or @BranchID_test is null
    begin
        select 'Error: Invalid or inactive inputs' as Message;
        return 1;
    end;

        insert into [Open] (Track_ID, Intake_ID, Branch_ID, Supervisor_ID)
        values (@TrackID, @IntakeID, @BranchID, @SuperID);
        select 'New opening created successfully.' as Message;
        return 0;
END;
GO
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/* Adding Removing Users */
create or alter procedure AddUser
	@RoleID tinyint,
    @FullName NVARCHAR(60),
    @FullAddress nvarchar(200),
    @GovName nvarchar(50),
    @Email NVARCHAR(50),
    @Password NVARCHAR(25),
    @Phone NVARCHAR(13),
    @DOB DATE,
    @Gender char(1),
    @MarStatusID tinyint,
    @NumKids tinyint,
    @NewUserID INT output
as
begin
set nocount on;
    declare @GovID int;
    select @GovID = GovID from Governorate where GovName = @GovName;
    if @GovID is null
    begin
        exec AddGov @GovName=@GovName;
        select @GovID = GovID from Governorate where GovName = @GovName;
    end;
    if exists(select 1 from [User] where FullName = @FullName and Email = @Email and DOB = @DOB and IsActive = 1)
    begin
        select 'User already active' as Message;
        return 1;
    end;

    declare @StartDate date = getdate();

    insert into [User] (Role_ID, FullName, FullAddress, Gov_ID, Email, [Password], Phone, DOB, StartDate, Gender, MaritalStatus_ID, NumKids)
    values(@RoleID, @FullName, @FullAddress, @GovID, @Email, @Password, @Phone, @DOB, @StartDate, @Gender, @MarStatusID, @NumKids)
    
    SET @NewUserID = SCOPE_IDENTITY();
    return 0;
end;
go

create or alter procedure RemoveUser
    @UserID int
as
begin
set nocount on;
    if not exists(select 1 from [User] where UserID = @UserID and IsActive = 1)
    begin
        return 1;
    end;

    declare @EndDate date = getdate();
    update [User] set IsActive = 0, EndDate = @EndDate where UserID = @UserID;
    return 0;
end
go
----------------------------------------------------------
/* CEO & Managers */
create or alter procedure Change_CEO
    @FullName NVARCHAR(60),
    @FullAddress nvarchar(200),
    @Governorate nvarchar(50),
    @Email NVARCHAR(50),
    @Password NVARCHAR(25),
    @Phone NVARCHAR(13),
    @DOB DATE,
    @Gender char(1),
    @MarStatusID tinyint,
    @NumKids tinyint
as
begin
set nocount on;
    declare @RoleID tinyint, @NewUserID int;
    select @RoleID = RoleID from UserRole where RoleName = 'CEO';
    declare @EndDate date = getdate();

    begin try
        Begin transaction;
            update [User] set IsActive = 0, EndDate = @EndDate where Role_ID = @RoleID;

            EXEC AddUser @RoleID, @FullName, @FullAddress, @Governorate, @Email, @Password, @Phone, @DOB, @Gender, @MarStatusID, @NumKids, @NewUserID = @NewUserID output;
        commit transaction;
        select 'CEO Changed' as Message;
        return 0;
    end try
    begin catch
        if @@trancount > 0
        begin
            rollback transaction;
        end;
        select ('Error: ' + ERROR_MESSAGE()) as Message;
        return 1;
    end catch;
end;
go

create or alter procedure AssignBranchManager
    @FullName nvarchar(60),
    @FullAddress nvarchar(200),
    @Governorate nvarchar(50),
    @Email nvarchar(50),
    @Password nvarchar(25),
    @Phone nvarchar(13),
    @DOB date,
    @Gender char(1),
    @MarStatusID tinyint,
    @NumKids tinyint,
    @BranchID tinyint,
    @YrsExp tinyint,
    @Salary int
as
begin
set nocount on;
    if not exists(select 1 from Branch where BranchID = @BranchID and isActive = 1)
    begin
        select 'Invalid Branch' as Message;
        return 1;
    end;

    if exists(select 1 from BranchManager bm join [User] u on bm.ManagerID = u.UserID 
          where u.Email = @Email and u.IsActive = 1)
    begin
        select 'This user is already assigned as a manager' as Message;
        return 1;
    end

    declare @NewUserID int, @RoleID tinyint, @OldManagerID int;

    select @RoleID = RoleID from UserRole where RoleName = 'Manager';

    select @OldManagerID = ManagerID from BranchManager bm join [User] u on bm.ManagerID = u.UserID where IsActive = 1 and bm.Branch_ID = @BranchID;

    begin try
        begin transaction;
            if @OldManagerID is not null
            begin
                Exec RemoveUser @OldManagerID=@OldManagerID;
            end;

            EXEC AddUser @RoleID, @FullName, @FullAddress, @Governorate, @Email, @Password, @Phone, @DOB, @Gender, @MarStatusID, @NumKids, @NewUserID = @NewUserID output;

            insert into BranchManager(ManagerID,Branch_ID,YrsExp,Salary)
            values(@NewUserID, @BranchID,@YrsExp, @Salary);
        commit transaction;
        select 'Branch Manager Added Successfully' as Message;
        return 0;
    end try
    begin catch
        IF @@TRANCOUNT > 0
        begin
            ROLLBACK TRANSACTION;
        end;
        select ('Error: ' + ERROR_MESSAGE()) as Message;
        return 1;
    END CATCH;
end;
go
----------------------------------------------------------
/* Instructors */
CREATE OR ALTER PROCEDURE AddFulltimeInstructor
    @FullName NVARCHAR(60),
    @FullAddress nvarchar(200),
    @Governorate nvarchar(50),
    @Email NVARCHAR(50),
    @Password NVARCHAR(25),
    @Phone NVARCHAR(13),
    @DOB DATE,
    @Gender char(1),
    @MarStatusID tinyint,
    @NumKids tinyint,
    @DeptID tinyint,
    @BranchID tinyint,
    @Yrs_Experience tinyINT,
    @Salary INT
as
begin
set nocount on;
    if not exists(select 1 from Branch where BranchID = @BranchID and IsActive = 1)
    begin
        select 'Invalid or inactive Branch' as Message;
        return 1;
    end;

    if not exists(select 1 from Department where DeptID = @DeptID and IsActive = 1)
    begin
        select 'Invalid or inactive Department' as Message;
        return 1;
    end;

    declare @NewUserID int;
    declare @RoleID tinyint;
    select @RoleID = RoleID from UserRole where RoleName = 'Instructor';
    EXEC AddUser @RoleID, @FullName, @FullAddress, @Governorate, @Email, @Password, @Phone, @DOB, @Gender, @MarStatusID, @NumKids, @NewUserID = @NewUserID output;
    if @NewUserID is null
    begin
        select 'Error: User Creation Failed' as Message;
        return 1;
    end

    begin try
        begin transaction;
            insert into Instructor(InstructorID,YrsExp,Salary)
            values(@NewUserID,@Yrs_Experience,@Salary);

            INSERT INTO FulltimeInstructor (InstructorID, Dept_ID, Branch_ID)
            VALUES (@NewUserID, @DeptID, @BranchID);
        commit transaction;
        select 'Fulltime Instructor Added Successfully' as Message;
        return 0;
    end try
    begin catch
        if @@trancount > 0
        begin
            rollback transaction;
        end;
        select ('Error: ' + ERROR_MESSAGE()) as Message;
        return 1;
    end catch;
END;
go

CREATE OR ALTER PROCEDURE AddExternalInstructor
    @FullName NVARCHAR(60),
    @FullAddress nvarchar(200),
    @Governorate nvarchar(50),
    @Email NVARCHAR(50),
    @Password NVARCHAR(25),
    @Phone NVARCHAR(13),
    @DOB DATE,
    @Gender char(1),
    @MarStatusID tinyint,
    @NumKids tinyint,
    @Yrs_Experience tinyINT,
    @Salary INT,
    @CompanyName nvarchar(50),
    @JobTitle nvarchar(50),
    @JobField nvarchar(50),
    @JobTypeID tinyint
as
begin
set nocount on;
    declare @CompanyID int;
    select @CompanyID = CompanyID from Company where CompanyName = @CompanyName;
    if @CompanyID is null
    begin
        exec AddCompany @CompanyName=@CompanyName, @CountryName='Unknown', @CompanyType='Unknown';
        select @CompanyID = CompanyID from Company where CompanyName = @CompanyName;
    end

    declare @JobTitleID int;
    select @JobTitleID = JobTitleID from Job where JobTitle = @JobTitle;
    if @JobTitleID is null
    begin
        Exec AddJob @JobTitle=@JobTitle;
        select @JobTitleID = JobTitleID from Job where JobTitle = @JobTitle;
    end

    declare @JobFieldID int;
    select @JobFieldID = JobFieldID from JobField where JobField = @JobField;
    if @JobFieldID is null
    begin
        Exec AddJobField @JobField=@JobField;
        select @JobFieldID = JobFieldID from JobField where JobField = @JobField;
    end

    declare @NewUserID int;
    declare @RoleID tinyint;
    select @RoleID = RoleID from UserRole where RoleName = 'Instructor';
    EXEC AddUser @RoleID, @FullName, @FullAddress, @Governorate, @Email, @Password, @Phone, @DOB, @Gender, @MarStatusID, @NumKids, @NewUserID = @NewUserID output;
    if @NewUserID is null
    begin
        select 'Error: User Creation Failed' as Message;
        return 1;
    end

    begin try
        begin transaction;
            insert into Instructor(InstructorID,YrsExp,Salary)
            values(@NewUserID,@Yrs_Experience,@Salary);

            INSERT INTO ExternalInstructor (InstructorID, Company_ID, JobTitle_ID, JobField_ID, JobType_ID)
            VALUES (@NewUserID, @CompanyID, @JobTitleID, @JobFieldID, @JobTypeID);
        commit transaction;
    select 'External Instructor Added Successfully' as Message;
    return 0;
    end try
    begin catch
        IF @@TRANCOUNT > 0
            begin
                ROLLBACK TRANSACTION;
            end;
            select 'Error Adding Instructor' as Message;
            return 1;
    end catch;
END;
go

create or alter procedure RemoveInstructor
    @InstructorID int
as
begin
set nocount on;
    if exists(select 1 from [Open] o join Intake i on i.IntakeID = o.Intake_ID  where o.Supervisor_ID = @InstructorID and i.IsActive = 1)
    begin
        select 'Error: Instructor is an active Supervisor' as Message;
        return 1;
    end
    
    declare @RoleID tinyint;
    select @RoleID = RoleID from UserRole where RoleName = 'Instructor';
    if not exists(select 1 from [User] where UserID = @InstructorID and IsActive = 1 and Role_ID = @RoleID)
        begin
            select 'Invalid Instructor ID' as Message;
            return 1;
        end
    if @InstructorID is not null
    begin
        Exec RemoveUser @UserID=@InstructorID;
        select 'Instructor Removed Successfully' as Message;
        return 0;
    end;
    select 'Failed' as Message;
    return 1;
end;
go
----------------------------------------------------------
/* Admins */
create or alter procedure AddAdmin
    @FullName nvarchar(60),
    @FullAddress nvarchar(200),
    @Governorate nvarchar(50),
    @Email nvarchar(50),
    @Password nvarchar(25),
    @Phone nvarchar(13),
    @DOB date,
    @Gender char(1),
    @MarStatusID tinyint,
    @NumKids tinyint,
    @BranchID tinyint,
    @Salary int
as
begin
set nocount on;
    if not exists (select 1 from Branch where BranchID = @BranchID and IsActive = 1)
    begin
        select 'Invalid Branch' as Message;
        return;
    end;
    
    declare @NewUserID int;
    declare @RoleID tinyint;
    select @RoleID = RoleID from UserRole where RoleName = 'Admin';

    begin try
        begin transaction;
            EXEC AddUser @RoleID, @FullName, @FullAddress, @Governorate, @Email, @Password, @Phone, @DOB, @Gender, @MarStatusID, @NumKids, @NewUserID = @NewUserID output;

            insert into [Admin](AdminID,Branch_ID,Salary)
            values(@NewUserID, @BranchID, @Salary)
        commit transaction;
        select 'Admin Added Successfully' as Message;
        return 0;
    end try
    begin catch
        if @@trancount > 0
            begin
                rollback transaction;
            end;
            select 'Failed' as Message;
            return 1;
    end catch;
end;
go

create or alter procedure RemoveAdmin
    @AdminID int
as
begin
set nocount on;
    if not exists (select 1 from [Admin] a join [User] u on u.UserID = a.AdminID where u.UserID = @AdminID and IsActive = 1)
    begin
        select 'Invalid Admin ID' as Message;
        return 1;
    end;

    Exec RemoveUser @UserID=@AdminID;
    select 'Admin Removed Successfully' as Message;
    return 0;
end;
go
----------------------------------------------------------
/* Students */
create or alter procedure AddStudent
    @FullName nvarchar(60),
    @FullAddress nvarchar(200),
    @Governorate nvarchar(50),
    @Email nvarchar(50),
    @Password nvarchar(25),
    @Phone nvarchar(13),
    @DOB date,
    @Gender char(1),
    @MarStatusID tinyint,
    @NumKids tinyint,
    @OpenID int,
    @UniversityName nvarchar(50),
    @FacultyName nvarchar(50),
    @GradYear int,
    @GPA Decimal(3,2)
as
begin
set nocount on;
    if not exists(select 1 from [Open] o join Intake i on o.Intake_ID = i.IntakeID where o.OpenID = @OpenID and i.IsActive = 1)
    begin
        select 'Invalid OpenID' as Message;
        return 1;
    end;

    if @GPA < 0 or @GPA > 4
    begin
        select 'GPA should be between 0 and 4' as Message;
        return 1;
    end;

    declare @UniversityID int , @FacultyID int , @RoleID tinyint , @NewUserID INT;

    select @UniversityID = UniversityID from University where UniversityName = @UniversityName;
    if @UniversityID is null
    begin
        exec AddUniversity @UniversityName = @UniversityName , @CountryName = 'Unknown';
        select @UniversityID = UniversityID from University where UniversityName = @UniversityName;
    end;
    select @FacultyID = FacultyID from Faculty where FacultyName = @FacultyName;
    if @FacultyID is null
    begin
        exec AddFaculty @FacultyName = @FacultyName;
        select @FacultyID = FacultyID from Faculty where FacultyName = @FacultyName;
    end;

    select @RoleID = RoleID from UserRole where RoleName = 'Student';

    begin try
        begin transaction;
            EXEC AddUser @RoleID, @FullName, @FullAddress, @Governorate, @Email, @Password, @Phone, @DOB, @Gender, @MarStatusID, @NumKids, @NewUserID = @NewUserID output;
                
            insert into Student(StudentID, Open_ID, University_ID, Faculty_ID, GradYear, GPA)
            values (@NewUserID, @OpenID, @UniversityID, @FacultyID, @GradYear, @GPA);
        commit transaction;
        select 'Student Added' as Message;
        return 0;
    end try
    begin catch
        if @@trancount > 0
        begin
            rollback transaction;
        end;
        select ('Error: ' + ERROR_MESSAGE()) as Message;
        return 1;
    end catch;
end;
go

create or alter procedure RemoveStudent
    @StudentID int
as
begin
set nocount on;
    if not exists (select 1 from Student s join [User] u on u.UserID = s.StudentID where u.UserID = @StudentID and IsActive = 1)
    begin
        select 'Invalid Student ID' as Message;
        return 1;
    end;

    Exec RemoveUser @UserID=@StudentID;
    select 'Student Removed Successfully' as Message;
    return 0;
end;
go
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/* Adding Removing Branches */
create or alter procedure OpenNewBranch
    --Branch
	@BranchName nvarchar(50),
    @BranchGovName nvarchar(50),
    --Manager
    @FullName nvarchar(60),
    @FullAddress nvarchar(200),
    @Governorate nvarchar(50),
    @Email nvarchar(50),
    @Password nvarchar(25),
    @Phone nvarchar(13),
    @DOB date,
    @Gender char(1),
    @MarStatusID tinyint,
    @NumKids tinyint,
    @YrsExp tinyint,
    @Salary int
as
begin
set nocount on;
    declare @BranchGovID tinyint, @BranchID tinyint, @Action NVARCHAR(50);

    select @BranchGovID = GovID from Governorate where GovName = @BranchGovName;
    if @BranchGovID is null
    begin
        Exec AddGov @GovName=@BranchGovName;
        select @BranchGovID = GovID from Governorate where GovName = @BranchGovName;
    end

    if exists(select 1 from Branch where BranchName = @BranchName and IsActive = 1 and Gov_ID = @BranchGovID)
    begin
        select 'Branch already exists and active' as Message;
        return 0;
    end;

    begin try
        begin transaction;
            if exists(select 1 from Branch where BranchName = @BranchName and Gov_ID = @BranchGovID and IsActive = 0)
            begin
                update Branch set IsActive = 1 where BranchName = @BranchName and Gov_ID = @BranchGovID and IsActive = 0;
                set @Action = 'Inactive Branch Reactivated Successfully';
            end
            else
            begin
                insert into Branch(BranchName, Gov_ID)
                values(@BranchName, @BranchGovID);
                set @Action = 'Branch Added Successfully';
            end;

            select @BranchID = BranchID from Branch where BranchName = @BranchName and Gov_ID = @BranchGovID and IsActive = 1;

            Exec AssignBranchManager @FullName, @FullAddress, @Governorate, @Email, @Password, @Phone, @DOB, @Gender, @MarStatusID, @NumKids, @BranchID, @YrsExp, @Salary;
        commit transaction;
        select @Action as Message;
        return 0;
    end try
    begin catch
        IF @@TRANCOUNT > 0
        begin
            rollback transaction;
        end;
        select ('Error: ' + ERROR_MESSAGE()) as Message;
        return 1;
    end catch;
end;
go

create or alter procedure RemoveBranch
    @BranchID tinyint
as
begin
set nocount on;
    if not exists(select 1 from Branch where BranchID = @BranchID and IsActive = 1)
    begin
        select 'Invalid Branch ID' as Message;
        return 1;
    end;

    if exists (select 1 from [Open] o join Intake i on o.Intake_ID = i.IntakeID where o.Branch_ID = @BranchID and i.IsActive = 1)
		begin
			select 'Cant remove before active Intake ' as Message;
            return 1;
		end

        if exists(select 1 from [Admin] a join [User] u on a.AdminID = u.UserID where a.Branch_ID = @BranchID and u.IsActive = 1)
        begin
            select 'Cant remove branch with active Admin staff' as Message;
            return 1;
        end

        if exists (select 1 from FulltimeInstructor i join [User] u on i.InstructorID = u.UserID where i.Branch_ID = @BranchID and u.IsActive = 1)
        begin
            select 'Cant remove Branch with active Fulltime Instructors' as Message;
            return 1;
        end;

        declare @ManagerID int;

        begin try
            begin transaction;
                select @ManagerID = ManagerID from BranchManager bm join [User] u on bm.ManagerID = u.UserID where bm.Branch_ID = @BranchID and u.IsActive = 1;
                if @ManagerID is not null
                begin
                    Exec RemoveUser @UserID=@ManagerID;
                end;
                delete from [Class] where Branch_ID = @BranchID;
                update Branch set IsActive = 0 where BranchID = @BranchID;
            commit transaction;
		    select 'Branch removed successfully' as Message;
            return 0;
        end try
        begin catch
            IF @@TRANCOUNT > 0
            begin
                ROLLBACK TRANSACTION;
            end;
        select ('Error: ' + ERROR_MESSAGE()) as Message;
    END CATCH;
end;
go
----------------------------------------------------------
/* Adding Removing Classes */
create or alter procedure AddClass
    @BranchID tinyint,
    @ClassNumber nvarchar(10),
    @ClassCap tinyint
as
begin
set nocount on;
    if not exists(select 1 from Branch where BranchID = @BranchID and IsActive = 1)
    begin
        select 'Branch not available or inactive' as Message;
        return 1;
    end;

    insert into [Class](Branch_ID,ClassNumber,ClassCapacity)
    values(@BranchID,@ClassNumber,@ClassCap);
    select 'Class Added' as Message;
    return 0;
end;
go

create or alter procedure RemoveClass
    @BranchID tinyint,
    @ClassNumber nvarchar(10)
as
begin
set nocount on;
    if not exists(select BranchID from Branch where BranchID = @BranchID and IsActive = 1)
    begin
        select 'Invalid Branch' as Message;
        return 1;
    end;
    if not exists(Select ClassNumber from [Class] where ClassNumber = @ClassNumber and Branch_ID = @BranchID)
    begin
        select 'Invalid Class' as Message;
        return 1;
    end;

    delete from [class] where Branch_ID = @BranchID and ClassNumber = @ClassNumber;
    select 'Class removed' as Message;
    return 0;
end;
go
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/* Grad KPIs */
create or alter procedure AddGradJob
    @StudentID int,
    @CompanyName nvarchar(50),
    @JobTitle nvarchar(50),
    @JobField nvarchar(50),
    @JobTypeID tinyint,
    @Salary int
as
begin
set nocount on;
    if not exists(select 1 from Student s join [User] u on s.StudentID = u.UserID where s.StudentID = @StudentID and IsActive = 1)
    begin
        select 'Invalid Student ID' as Message;
        return 1;
    end;

    declare @CompanyID int;
    select @CompanyID = CompanyID from Company where CompanyName = @CompanyName;
    if @CompanyID is null
    begin
        exec AddCompany @CompanyName=@CompanyName, @CountryName='Unknown', @CompanyType='Unknown';
        select @CompanyID = CompanyID from Company where CompanyName = @CompanyName;
    end;

    declare @JobTitleID int;
    select @JobTitleID = JobTitleID from Job where JobTitle = @JobTitle;
    if @JobTitleID is null
    begin
        Exec AddJob @JobTitle = @JobTitle
        select @JobTitleID = JobTitleID from Job where JobTitle = @JobTitle;
    end;

    declare @JobFieldID int;
    select @JobFieldID = JobFieldID from JobField where JobField = @JobField;
    if @JobFieldID is null
    begin
        Exec AddJobField @JobField = @JobField
        select @JobFieldID = JobFieldID from JobField where JobField = @JobField;
    end;

    insert into GradJob(StudentID, Company_ID, JobTitle_ID, JobField_ID, JobType_ID, Salary)
    values(@StudentID, @CompanyID, @JobTitleID, @JobFieldID, @JobTypeID, @Salary);
    select 'Graduate Job Added Successfully' as Message;
    return 0;
end;
go

create or alter procedure AddStudExtCert
    @StudentID int,
    @CertName nvarchar(100)
as
begin
set nocount on;
    if not exists(select 1 from Student s join [User] u on s.StudentID = u.UserID where s.StudentID = @StudentID and IsActive = 1)
    begin
        select 'Invalid Student ID' as Message;
        return 1;
    end;

    declare @CertID int;
    select @CertID = CertID from [Certificate] where CertName = @CertName;
    if @CertID is null
    begin
        Exec AddCertificate @CertName=@CertName, @Hours = 0, @Website ='Unknown', @StudyFieldName = 'Unknown';
        select @CertID = CertID from [Certificate] where CertName = @CertName;
    end;

    insert into StudentExternalCertificate(Student_ID, [Cert_ID])
    values(@StudentID, @CertID);
    select 'Student Certificate Added Successfully' as Message;
    return 0;
end;
GO

create or alter procedure AddStudentFreelance
    @StudentID int,
    @Revenue int,
    @JobField nvarchar(50),
    @Feedback int,
    @MaxFeedback int
as
begin
set nocount on;
    if not exists(select 1 from Student s join [User] u on s.StudentID = u.UserID where s.StudentID = @StudentID and IsActive = 1)
    begin
        select 'Invalid Student ID' as Message;
        return 1;
    end;

    declare @JobFieldID int
    select @JobFieldID = JobFieldID from JobField where JobField = @JobField
    if @JobFieldID is null
    begin
        Exec AddJobField @JobField = @JobField;
        select @JobFieldID = JobFieldID from JobField where JobField = @JobField;
    end;

    if @Feedback < 0 or @MaxFeedback <= 0
    begin
        select 'Invalid Feedback' as Message;
        return 1;
    end;

    set @Feedback = CAST(((@Feedback * 5.0) / @MaxFeedback) AS tinyint);

    insert into StudentFreelance(Student_ID,Revenue,JobField_ID,Feedback)
    values(@StudentID, @Revenue, @JobFieldID, @Feedback);
    select 'Student Freelance Added Successfully' as Message;
end;
go
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/* Schedule & Student Courses */
CREATE OR ALTER PROCEDURE AddStudentTakes
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate student
    IF NOT EXISTS(
        SELECT 1 
        FROM Student s 
        JOIN [User] u ON u.UserID = s.StudentID 
        WHERE s.StudentID = @StudentID 
          AND u.IsActive = 1
    )
    BEGIN
        SELECT 'Invalid Student' AS Message;
        RETURN 1;
    END;

    -- Validate student has a track
    DECLARE @TrackID INT;
    SELECT @TrackID = o.Track_ID
    FROM Student s
    JOIN [Open] o ON s.Open_ID = o.OpenID
    WHERE s.StudentID = @StudentID;

    IF @TrackID IS NULL
    BEGIN
        SELECT 'Student Track Not Found' AS Message;
        RETURN 1;
    END;

    -- Validate course belongs to track
    IF NOT EXISTS(
        SELECT 1 
        FROM TrackCourse
        WHERE Track_ID = @TrackID 
          AND Course_ID = @CourseID
    )
    BEGIN
        SELECT 'Course not in Student enrolled Track' AS Message;
        RETURN 1;
    END;

    -- Prevent duplicates
    IF EXISTS(
        SELECT 1 
        FROM StudentTakes 
        WHERE Student_ID = @StudentID 
          AND Course_ID = @CourseID
    )
    BEGIN
        SELECT 'Student Already Enrolled to this course' AS Message;
        RETURN 1;
    END;

    -- Insert
    INSERT INTO StudentTakes (Student_ID, Course_ID)
    VALUES (@StudentID, @CourseID);

    SELECT 'Student Enrolled in Course Successfully' AS Message;
    RETURN 0;
END;
GO


create or alter procedure RemoveStudentTakes
    @StudentID INT,
    @CourseID INT
as
begin
set nocount on;
    if not exists(select 1 from Student s join [User] u on u.UserID = s.StudentID where s.StudentID = @StudentID and u.IsActive = 1)
    begin
        select 'Invalid Student' as Message;
        return 1;
    end;

    if not exists(select 1 from Student s join [Open] o on s.Open_ID = o.OpenID join TrackCourse tc on o.Track_ID = tc.Track_ID join Course c on tc.Course_ID = c.CourseID where s.StudentID = @StudentID and c.CourseID = @CourseID)
    begin
        select 'Invalid Course' as Message;
        return 1;
    end;

    if exists(select 1 from StudentTakes where Student_ID = @StudentID and Course_ID = @CourseID and Finished = 1)
    begin
        select 'Student Already finished this course' as Message;
        return 1;
    end;

    update StudentTakes set Finished = 1 where Student_ID = @StudentID and Course_ID = @CourseID;
    select 'Student Finished course successfully' as Message;
    return 0;
END;
go
----------------------------------------------------------
create or alter procedure AddSchedule
    @TeachID int,
    @StartTime Time(0),
    @EndTime Time(0),
    @Date date
as
begin
set nocount on;
    if not exists(select 1 from Teach t join [Open] o on o.OpenID = t.Open_ID join Intake i on i.IntakeID = o.Intake_ID where t.TeachID = @TeachID and i.IsActive = 1)
    begin
        select 'Invalid Schedule Parameters' as Message;
        return 1;
    end;

    if @StartTime >= @EndTime
    begin
        select 'Start Time must be earlier than End Time.' as Message;
        return 1;
    end;

    if @Date <= CAST(GETDATE() AS DATE)
    begin
        select 'Schedule Date must be in the future' as Message;
        return 1;
    end

    insert into Schedule(Teach_ID, StartTime, EndTime, [Date])
    values(@TeachID, @StartTime, @EndTime, @Date);
    select 'Schedule Added Successfully' as Message;
    return 0;
end;
go
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/* Instructors Teach */
create or alter procedure Add_InstructorCanTeach
    @InstructorID int,
    @CourseID int
as
begin
set nocount on;
    if not exists(select 1 from Instructor i join [User] u on u.UserID = i.InstructorID where i.InstructorID = @InstructorID and u.IsActive = 1)
    begin
        select 'Invalid Instructor ID' as Message;
        return 1;
    end;

    if not exists(select 1 from Course where CourseID = @CourseID)
    begin
        select 'Invalid Course ID' as Message;
        return 1;
    end;

    insert into InstructorCanTeach(Instructor_ID, Course_ID)
    values(@InstructorID, @CourseID);
    select 'Successful' as Message;
    return 0;
end;
go

create or alter procedure Remove_InstructorCanTeach
    @InstructorID int,
    @CourseID int
as
begin
set nocount on;
    if not exists(select 1 from Instructor i join [User] u on u.UserID = i.InstructorID where i.InstructorID = @InstructorID and u.IsActive = 1)
    begin
        select 'Invalid Instructor ID' as Message;
        return 1;
    end;

    if not exists(select 1 from Course where CourseID = @CourseID)
    begin
        select 'Invalid Course ID' as Message;
        return 1;
    end;
    delete from InstructorCanTeach where Instructor_ID = @InstructorID and Course_ID = @CourseID;
    select 'Removed' as Message;
    return 0;
end;
go
----------------------------------------------------------
CREATE OR ALTER PROCEDURE AssignInstructorCourse
    @InstructorID INT,
    @CourseID INT,
    @OpenID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check Instructor
    IF NOT EXISTS(
        SELECT 1 
        FROM Instructor instr 
        JOIN [User] u ON instr.InstructorID = u.UserID 
        WHERE u.IsActive = 1 AND instr.InstructorID = @InstructorID
    )
    BEGIN
        SELECT 'Invalid Instructor ID' AS Message;
        RETURN 1;
    END;

    -- Check instructor can teach course
    IF NOT EXISTS(
        SELECT 1 
        FROM Course c 
        JOIN InstructorCanTeach ict ON ict.Course_ID = c.CourseID 
        WHERE ict.Instructor_ID = @InstructorID AND c.CourseID = @CourseID
    )
    BEGIN
        SELECT 'Instructor cant teach this course' AS Message;
        RETURN 1;
    END;

    -- Check active Open/Intake
    IF NOT EXISTS(
        SELECT 1 
        FROM [Open] o 
        JOIN Intake i ON i.IntakeID = o.Intake_ID 
        WHERE i.IsActive = 1 AND o.OpenID = @OpenID
    )
    BEGIN
        SELECT 'Inactive Intake' AS Message;
        RETURN 1;
    END;

    -- Prevent duplicate assignment
    IF EXISTS(
        SELECT 1 
        FROM Teach 
        WHERE Course_ID = @CourseID AND Open_ID = @OpenID
    )
    BEGIN
        SELECT 'An Instructor is already assigned to this course' AS Message;
        RETURN 1;
    END;

    -- Assign instructor
    INSERT INTO Teach (Instructor_ID, Course_ID, Open_ID)
    VALUES (@InstructorID, @CourseID, @OpenID);

    SELECT 'Instructor Assigned Successfully' AS Message;
    RETURN 0;
END;
GO


CREATE OR ALTER PROCEDURE ReassignNew_InstructorCourse
    @InstructorID INT,
    @CourseID INT,
    @OpenID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if a current instructor exists
    IF NOT EXISTS(SELECT 1 FROM Teach WHERE Course_ID = @CourseID AND Open_ID = @OpenID)
    BEGIN
        SELECT 'Course is already vacant, Assign an instructor' AS Message;
        RETURN 1;
    END;
    
    BEGIN TRY
        BEGIN TRANSACTION;
            -- Remove current instructor
            DELETE FROM Teach WHERE Course_ID = @CourseID AND Open_ID = @OpenID;

            -- Assign new instructor
            EXEC AssignInstructorCourse @InstructorID = @InstructorID, @CourseID = @CourseID, @OpenID = @OpenID;

        COMMIT TRANSACTION;
        SELECT 'Instructor reassigned successfully' AS Message;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT ('Reassignment Failed: ' + ERROR_MESSAGE()) AS Message;
        RETURN 1;
    END CATCH;
END;
GO

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/* Questions & Exams */
create or alter procedure CreateExam
    @CourseID INT,
    @StartTime TIME(0),
    @EndTime TIME(0),
    @Date DATE,
    @Score INT,
    @ExamType char(1),
	@OpenID INT,
	@InstructorID INT
as
begin
set nocount on;
    if @StartTime >= @EndTime
    begin
        select 'Exam Start Time must be earlier than End Time.' as Message;
        return 1;
    end;

    if @Date <= CAST(GETDATE() AS DATE)
    begin
        select 'Exam Date must be in the future' as Message;
        return 1;
    end

    declare @TeachID int
    select @TeachID = TeachID from Teach where Instructor_ID = @InstructorID and Course_ID = @CourseID and Open_ID = @OpenID
    if @TeachID is null
    begin
        select 'This user is not assigned to teach the given course in this Open.' as Message;
        return 1
    end;

    if @ExamType != 'c' and @ExamType != 'n'
    begin
        select 'Invalid Exam Type' as Message;
        return 1;
    end;

    insert into Exam (Teach_ID, StartTime, EndTime, ExamDate, score, ExamType)
    values (@TeachID, @StartTime, @EndTime, @Date, @Score, @ExamType);

    select 'Exam Created Successfully' as Message;
    return 0;
end;
go
----------------------------------------------------------
CREATE OR ALTER PROCEDURE AddQuestionUnified
    @Course_ID     INT,
    @Type_ID          int,
    @Description   NVARCHAR(500),
    @Option1       NVARCHAR(50) = NULL,
    @Option2       NVARCHAR(50) = NULL,
    @Option3       NVARCHAR(50) = NULL,
    @Option4       NVARCHAR(50) = NULL,
    @CorrectOption TINYINT      = NULL,
    @TextAnswer    NVARCHAR(1000) = NULL
AS
BEGIN

    BEGIN TRY
        /* ---------- Validation ---------- */
        IF NOT EXISTS (SELECT 1 FROM dbo.Course WHERE CourseID = @Course_ID)
        BEGIN
            RAISERROR('Course_ID does not exist.', 16, 1);
            RETURN 1;
        END;

        IF @Type_ID NOT IN (1, 2, 3)
        BEGIN
            RAISERROR('Invalid Type. Allowed: MCQ, TrueFalse, Text.', 16, 1);
            RETURN 1;
        END;

        -- Text: no options allowed; answer is optional but recommended
        IF @Type_ID = 3 AND (
           @Option1 IS NOT NULL OR @Option2 IS NOT NULL OR
           @Option3 IS NOT NULL OR @Option4 IS NOT NULL OR
           @CorrectOption IS NOT NULL)
        BEGIN
            RAISERROR('Text questions must not include options or CorrectOption.', 16, 1);
            RETURN 1;
        END;

        -- True/False: CorrectOption must be 1 (True) or 2 (False)
        IF @Type_ID = 2 AND (@CorrectOption NOT IN (1,2))
        BEGIN
            RAISERROR('For TrueFalse, CorrectOption must be 1 (True) or 2 (False).', 16, 1);
            RETURN 1;
        END;

        -- MCQ: need 1–4 options; CorrectOption in 1..4 and must exist
        IF @Type_ID = 1
        BEGIN
            DECLARE @optCount INT =
                (CASE WHEN @Option1 IS NOT NULL THEN 1 ELSE 0 END) +
                (CASE WHEN @Option2 IS NOT NULL THEN 1 ELSE 0 END) +
                (CASE WHEN @Option3 IS NOT NULL THEN 1 ELSE 0 END) +
                (CASE WHEN @Option4 IS NOT NULL THEN 1 ELSE 0 END);

            IF @optCount = 0
            BEGIN
                RAISERROR('MCQ must have at least one option.', 16, 1);
                RETURN 1;
            END;

            IF @CorrectOption NOT BETWEEN 1 AND 4
            BEGIN
                RAISERROR('For MCQ, CorrectOption must be between 1 and 4.', 16, 1);
                RETURN 1;
            END;

            IF (@CorrectOption = 1 AND @Option1 IS NULL) OR
               (@CorrectOption = 2 AND @Option2 IS NULL) OR
               (@CorrectOption = 3 AND @Option3 IS NULL) OR
               (@CorrectOption = 4 AND @Option4 IS NULL)
            BEGIN
                RAISERROR('CorrectOption must reference a non-NULL option.', 16, 1);
                RETURN 1;
            END;
        END;

        /* ---------- Atomic insert ---------- */
        BEGIN TRAN;

        -- Concurrency-safe QPID allocation
        INSERT INTO dbo.QuestionPool(Course_ID, Qtype_ID, [Description])
        VALUES (@Course_ID, @Type_ID, @Description);
        DECLARE @NewQPID int;
        select @NewQPID = QPID from QuestionPool where Course_ID = @Course_ID and Qtype_ID = @Type_ID and [Description] = @Description;

        IF @Type_ID = 1
        BEGIN
            IF @Option1 IS NOT NULL
                INSERT INTO dbo.AnswersMCQ(QP_ID, OptionID, [Option], IS_Correct)
                VALUES (@NewQPID, 1, @Option1, IIF(@CorrectOption=1,1,0));
            IF @Option2 IS NOT NULL
                INSERT INTO dbo.AnswersMCQ(QP_ID, OptionID, [Option], IS_Correct)
                VALUES (@NewQPID, 2, @Option2, IIF(@CorrectOption=2,1,0));
            IF @Option3 IS NOT NULL
                INSERT INTO dbo.AnswersMCQ(QP_ID, OptionID, [Option], IS_Correct)
                VALUES (@NewQPID, 3, @Option3, IIF(@CorrectOption=3,1,0));
            IF @Option4 IS NOT NULL
                INSERT INTO dbo.AnswersMCQ(QP_ID, OptionID, [Option], IS_Correct)
                VALUES (@NewQPID, 4, @Option4, IIF(@CorrectOption=4,1,0));
        END
        ELSE IF @Type_ID = 2
        BEGIN
            -- Always insert canonical TF options
            INSERT INTO dbo.AnswersMCQ(QP_ID, OptionID, [Option], IS_Correct)
            VALUES
                (@NewQPID, 1, N'True',  IIF(@CorrectOption=1,1,0)),
                (@NewQPID, 2, N'False', IIF(@CorrectOption=2,1,0));
        END
        ELSE IF @Type_ID = 3
        BEGIN
            -- Save expected/model answer only if provided
            IF @TextAnswer IS NOT NULL
                INSERT INTO dbo.AnswerText(QP_ID, Answer)
                VALUES (@NewQPID, @TextAnswer);
        END

        COMMIT TRAN;

        select 'Question (QPID=' + CAST(@NewQPID AS NVARCHAR(20)) + ') and answers added successfully.' as Message;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRAN;
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END
go
----------------------------------------------------------
CREATE OR ALTER PROCEDURE RemoveQuestionUnified
    @QPID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @QType int;

    -- Find the type of the question
    SELECT @QType = Qtype_ID
    FROM dbo.QuestionPool
    WHERE QPID = @QPID;

    IF @QType IS NULL
    BEGIN
        select 'No question found with the given QPID.' as Message;
        RETURN 1;
    END;

    -- Remove answers depending on type
    IF @QType IN (1, 2)
    BEGIN
        DELETE FROM dbo.AnswersMCQ WHERE QP_ID = @QPID;
    END
    ELSE IF @QType = 3
    BEGIN
        DELETE FROM dbo.AnswerText WHERE QP_ID = @QPID;
    END;

    -- Remove from QuestionPool itself
    DELETE FROM dbo.QuestionPool WHERE QPID = @QPID;

    select 'Question and related answers removed successfully' as Message;
END;
go
----------------------------------------------------------
CREATE OR ALTER PROCEDURE AddQuestionToExam
    @ExamID INT,
    @QPID INT,
    @Degree INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentDate DATE = GETDATE();

    -- Check if exam exists, not archived, and is in the future
    IF NOT EXISTS (SELECT 1 FROM Exam WHERE ExamID = @ExamID AND Archived = 0 AND ExamDate > @CurrentDate)
    BEGIN
        SELECT 'Invalid Exam' AS Message;
        RETURN 1;
    END;

    -- Check if question belongs to the course taught in this exam
    IF NOT EXISTS (
        SELECT 1 
        FROM QuestionPool qp
        JOIN Course c ON qp.Course_ID = c.CourseID
        JOIN Teach t ON t.Course_ID = qp.Course_ID
        JOIN Exam e ON e.Teach_ID = t.TeachID
        WHERE qp.QPID = @QPID AND e.ExamID = @ExamID
    )
    BEGIN
        SELECT 'Question does not belong to Exam' AS Message;
        RETURN 1;
    END;

    -- Insert the question into the exam
    INSERT INTO ExamQuestions (Exam_ID, QP_ID, Degree)
    VALUES (@ExamID, @QPID, @Degree);

    SELECT 'Question added to exam successfully' AS Message;
    RETURN 0;
END;
GO

----------------------------------------------------------
create or alter procedure PopulateExamChooseAuto
    @examid        int,
    @questioncount int           = 10,
    @allowedtypes  VARCHAR(50) = '1,2,3'
as
begin
    if @questioncount <= 0
    begin
        raiserror(N'@questioncount must be > 0.', 16, 1);
        return;
    end

    declare
        @course_id  int,
        @open_id  int,
        @Instructor_ID    int,
        @score      int,
        @date       date,
        @start_time time(0);

    declare @TeachID int
    select @TeachID = TeachID from Teach where Open_ID = @Open_ID and Instructor_ID = @Instructor_ID and Course_ID = @Course_ID
    select
        @TeachID  = e.Teach_ID,
        @score      = e.score,
        @date       = e.ExamDate,
        @start_time = e.StartTime
    from dbo.exam e
    where e.ExamID = @examid;

    if @course_id is null
    begin
        raiserror(N'examid not found.', 16, 1);
        return;
    end

    declare @startdt datetime2(0) =
        dateadd(day, datediff(day, 0, @date), cast(@start_time as datetime2(0)));

    if getdate() >= @startdt
    begin
        raiserror(N'cannot modify questions for an exam that has started.', 16, 1);
        return;
    end

    declare @maxdegree int, @targettotal int;

    select @maxdegree = c.maxdegree
    from dbo.course c
    where c.courseid = @course_id;

    if @maxdegree is null
    begin
        raiserror(N'course.maxdegree not set.', 16, 1);
        return;
    end

    select @targettotal =
        case
            when @score is null then @maxdegree
            when @score > @maxdegree then @maxdegree
            else @score
        end;

        ;WITH allowed AS (
        SELECT DISTINCT
               TRY_CONVERT(INT, TRIM(value)) AS TypeID
        FROM STRING_SPLIT(@allowedtypes, N',')
        WHERE TRY_CONVERT(INT, TRIM(value)) IS NOT NULL
    ),
    pool AS (
        SELECT q.QPID
        FROM dbo.questionpool q
        WHERE q.course_id = @course_id
          AND q.Qtype_ID IN (SELECT TypeID FROM allowed)
    )
    select top (@questioncount) QPID
    into #picked
    from pool
    order by newid();

    declare @pickedcount int;
    select @pickedcount = count(*) from #picked;

    if @pickedcount < @questioncount
    begin
        drop table if exists #picked;
        raiserror(N'not enough questions for the requested filters/count.', 16, 1);
        return;
    end

    declare @base int = @targettotal / @questioncount,
            @rem  int = @targettotal % @questioncount;

    begin tran;

    delete from dbo.ExamQuestions
    where exam_id = @examid;

    ;with numbered as (
        select QPID, row_number() over (order by QPID) as rn
        from #picked
    )
    insert into dbo.ExamQuestions (exam_id, qp_id, degree)
    select
        @examid,
        QPID,
        @base + case when rn <= @rem then 1 else 0 end
    from numbered;

    commit tran;

    drop table if exists #picked;
end;
go
----------------------------------------------------------
CREATE OR ALTER PROCEDURE ProcessFinishedExamsAndArchive
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- 1️⃣ Identify finished exams
        SELECT e.ExamID, e.Teach_ID
        INTO #Finished
        FROM dbo.Exam e
        WHERE (e.Archived = 0 OR e.Archived IS NULL)
          AND GETDATE() >= (CAST(e.ExamDate AS datetime) + CAST(e.EndTime AS datetime));

        IF NOT EXISTS (SELECT 1 FROM #Finished)
        BEGIN
            SELECT 'No finished exams found to process.' AS Message;
            COMMIT;
            RETURN;
        END

        -- 2️⃣ Calculate total per (Student, Exam)
        SELECT sa.Student_ID,
               sa.Exam_ID,
               SUM(ISNULL(sa.QScore, 0)) AS TotalScore
        INTO #Totals
        FROM dbo.StudentAnswer sa
        JOIN #Finished f ON f.ExamID = sa.Exam_ID
        GROUP BY sa.Student_ID, sa.Exam_ID;

        -- 3️⃣ Get passing thresholds
        SELECT f.ExamID,
               ISNULL(c.MinDegree, 0) AS MinRequired
        INTO #Thresholds
        FROM #Finished f
        JOIN dbo.Exam e ON e.ExamID = f.ExamID
        JOIN dbo.Course c ON c.CourseID = e.Course_ID;

        -- 4️⃣ Insert results if not already present
        INSERT INTO dbo.StudentExamResult (Student_ID, Exam_ID, TotalScore, IsPass, CalculatedAt)
        SELECT t.Student_ID,
               t.Exam_ID,
               t.TotalScore,
               CASE WHEN t.TotalScore >= th.MinRequired THEN 1 ELSE 0 END,
               GETDATE()
        FROM #Totals t
        JOIN #Thresholds th ON th.ExamID = t.Exam_ID
        WHERE NOT EXISTS (
            SELECT 1
            FROM dbo.StudentExamResult ser
            WHERE ser.Student_ID = t.Student_ID AND ser.Exam_ID = t.Exam_ID
        );

        -- 5️⃣ Mark exams as archived
        UPDATE e
        SET e.Archived = 1
        FROM dbo.Exam e
        WHERE EXISTS (SELECT 1 FROM #Finished f WHERE f.ExamID = e.ExamID);

        -- 6️⃣ Cleanup
        DROP TABLE IF EXISTS #Finished, #Totals, #Thresholds;

        COMMIT;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO

----------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.StudentAnswer_PROCEDURE
    @Student_ID     INT,
    @exam_id        INT,
    @question_id    INT,
    @student_answer NVARCHAR(2000)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE
            @CourseID        INT           = NULL,
            @QType           NVARCHAR(10)  = NULL,
            @Degree          INT           = NULL,
            @CorrectOptionID INT           = NULL,
            @ChosenOptionID  INT           = NULL,
            @QScore          INT           = NULL;

        -- Exam → Course
        select @CourseID = t.Course_ID from Exam e join Teach t on e.Teach_ID = t.TeachID where e.ExamID = @exam_ID

        IF @CourseID IS NULL
        BEGIN
            RAISERROR(N'Invalid Exam_ID.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        -- Question belongs to course → type
        SELECT @QType = qp.Qtype_ID
        FROM dbo.QuestionPool qp
        WHERE qp.QPID = @question_id
          AND qp.Course_ID = @CourseID;

        IF @QType IS NULL
        BEGIN
            RAISERROR(N'Invalid Question_ID for this exam''s course.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        -- Degree on this exam
        SELECT @Degree = EQ.Degree
        FROM dbo.ExamQuestions EQ
        WHERE EQ.Exam_ID = @exam_id
          AND EQ.QP_ID   = @question_id;

        IF @Degree IS NULL
        BEGIN
            RAISERROR(N'This question is not assigned to the specified exam.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        /*========================
          MCQ / TrueFalse
        ========================*/
        IF @QType IN (1,2)
        BEGIN
            DECLARE @ans NVARCHAR(20) = UPPER(LTRIM(RTRIM(ISNULL(@student_answer, N''))));

            -- Try numeric first
            SET @ChosenOptionID = TRY_CAST(@ans AS INT);
            IF @ChosenOptionID IS NULL
            BEGIN
                SET @ChosenOptionID =
                    CASE @ans
                        WHEN N'A' THEN 1 WHEN N'B' THEN 2 WHEN N'C' THEN 3 WHEN N'D' THEN 4
                        WHEN N'T' THEN 1 WHEN N'TRUE'  THEN 1 WHEN N'Y' THEN 1 WHEN N'YES' THEN 1
                        WHEN N'F' THEN 2 WHEN N'FALSE' THEN 2 WHEN N'N' THEN 2 WHEN N'NO'  THEN 2
                        WHEN N'0' THEN 2 WHEN N'1' THEN 1
                    END;
            END

            IF @ChosenOptionID IS NULL
            BEGIN
                RAISERROR(N'Invalid answer format for MCQ/TrueFalse.', 16, 1);
                ROLLBACK TRANSACTION; RETURN;
            END

            IF NOT EXISTS (
                SELECT 1
                FROM dbo.AnswersMCQ
                WHERE QP_ID = @question_id AND OptionID = @ChosenOptionID
            )
            BEGIN
                RAISERROR(N'Chosen option does not exist for this question.', 16, 1);
                ROLLBACK TRANSACTION; RETURN;
            END

            SELECT @CorrectOptionID = am.OptionID
            FROM dbo.AnswersMCQ am
            WHERE am.QP_ID = @question_id AND am.IS_Correct = 1;

            IF @CorrectOptionID IS NULL
            BEGIN
                RAISERROR(N'No correct option configured for this question.', 16, 1);
                ROLLBACK TRANSACTION; RETURN;
            END

            SET @QScore = CASE WHEN @ChosenOptionID = @CorrectOptionID THEN @Degree ELSE 0 END;
            SET @student_answer = CONVERT(NVARCHAR(5), @ChosenOptionID);
        END

        /*========================
          Text (≥ 4-word overlap)
        ========================*/
        ELSE IF @QType = 3
        BEGIN
            DECLARE @ModelAnswer NVARCHAR(1000) = NULL;
            SELECT @ModelAnswer = at.Answer
            FROM dbo.AnswerText at
            WHERE at.QP_ID = @question_id;

            IF @ModelAnswer IS NULL OR @student_answer IS NULL
            BEGIN
                SET @QScore = NULL;
            END
            ELSE
            BEGIN
                -- Normalize (case, punctuation incl. Arabic, simple Arabic unifications)
                DECLARE @Punct NVARCHAR(100) = N'.,;:!?"()[]{}''-_/|\،؛؟';
                DECLARE @stu NVARCHAR(2000) = LOWER(@student_answer);
                DECLARE @mod NVARCHAR(2000) = LOWER(@ModelAnswer);

                -- unify alef variants + drop tatweel
                SET @stu = REPLACE(REPLACE(REPLACE(@stu, N'أ', N'ا'), N'إ', N'ا'), N'آ', N'ا');
                SET @mod = REPLACE(REPLACE(REPLACE(@mod, N'أ', N'ا'), N'إ', N'ا'), N'آ', N'ا');
                SET @stu = REPLACE(@stu, NCHAR(1600), N''); -- tatweel
                SET @mod = REPLACE(@mod, NCHAR(1600), N'');

                -- strip punctuation by translating to spaces (lengths match)
                SET @stu = TRANSLATE(@stu, @Punct, REPLICATE(N' ', LEN(@Punct)));
                SET @mod = TRANSLATE(@mod, @Punct, REPLICATE(N' ', LEN(@Punct)));

                -- collapse multiple spaces
                WHILE CHARINDEX(N'  ', @stu) > 0 SET @stu = REPLACE(@stu, N'  ', N' ');
                WHILE CHARINDEX(N'  ', @mod) > 0 SET @mod = REPLACE(@mod, N'  ', N' ');

                DECLARE @StudentWords TABLE(word NVARCHAR(100) PRIMARY KEY);
                DECLARE @ModelWords   TABLE(word NVARCHAR(100) PRIMARY KEY);

                INSERT INTO @StudentWords(word)
                SELECT DISTINCT LTRIM(RTRIM(value))
                FROM STRING_SPLIT(@stu, N' ')
                WHERE LEN(LTRIM(RTRIM(value))) > 0;

                INSERT INTO @ModelWords(word)
                SELECT DISTINCT LTRIM(RTRIM(value))
                FROM STRING_SPLIT(@mod, N' ')
                WHERE LEN(LTRIM(RTRIM(value))) > 0;

                DECLARE @Matches INT;
                SELECT @Matches = COUNT(*)
                FROM @StudentWords s
                JOIN @ModelWords   m ON m.word = s.word;

                SET @QScore = CASE WHEN @Matches >= 4 THEN @Degree ELSE 0 END;
            END
        END
        ELSE
        BEGIN
            RAISERROR(N'Unknown question type.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END
        declare @ExamQuestionID int;
        select @ExamQuestionID = ExamQuestionID from ExamQuestions where Exam_ID = @exam_id and QP_ID = @question_id;
        /* Upsert */
        IF EXISTS (
            SELECT 1
            FROM dbo.StudentAnswer
            WHERE Student_ID = @Student_ID AND ExamQuestion_ID = @ExamQuestionID
        )
        BEGIN
            UPDATE dbo.StudentAnswer
            SET Student_Answer = @student_answer,
                QScore         = @QScore
            WHERE Student_ID = @Student_ID AND ExamQuestion_ID = @ExamQuestionID;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.StudentAnswer(Student_ID, ExamQuestion_ID, Student_Answer, QScore)
            VALUES(@Student_ID, @ExamQuestionID, @student_answer, @QScore);
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO