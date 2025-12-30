# 🎓 ITI Examination System & Academic Intelligence Platform
### ITI Graduation Project | Business Intelligence Track

![Project Banner](https://github.com/user-attachments/assets/2f086c80-b533-429f-9015-d2cac83368ca)

![Status](https://img.shields.io/badge/Status-Completed-success)
![Stack](https://img.shields.io/badge/Stack-SQL%20%7C%20PowerBI%20%7C%20SSRS%20%7C%20Web-blue)


## 📖 Overview
The **ITI Examination System** is a comprehensive digital solution designed to automate the academic lifecycle at the Information Technology Institute (ITI). The system ensures accuracy, efficiency, and scalability by covering the full data cycle—from Database Design and ETL processing to Interactive Dashboards.

**The solution serves four key pillars:**
1.  **Academic Management:** Streamlining complex relationships between Students, Courses, and Instructors using a highly normalized Database Design.
2.  **Assessment Automation:** Providing a secure environment for automated exam generation and result processing.
3.  **Career Intelligence (Unique Feature):** Bridging the gap between education and employment by tracking Student Freelance Jobs and Hiring Data to measure the true ROI of education.
4.  **Decision Support System:** Empowering management with a **Galaxy Schema Data Warehouse** to visualize Intake Growth, Exam Quality, and Educational ROI.

---

## 🛠️ Tools & Technologies
The project utilizes a robust stack to handle data from creation to visualization:
* **Database & Backend:** Microsoft SQL Server (2022), T-SQL.
* **ETL & Warehousing:** SSIS, Galaxy Schema Modeling.
* **Reporting & BI:** Power BI, SSRS (SQL Server Reporting Services).
* **Web Application:** HTML5, CSS3, JavaScript, Visual Studio.
* **Design & Planning:** Canva, Draw.io.

---

## 🔄 Project Workflow
The technical framework of the project follows an end-to-end data engineering pipeline:
1.  **Analysis & Modeling:** System Analysis $\rightarrow$ ERD $\rightarrow$ Mapping.
2.  **DB Implementation:** Database Design $\rightarrow$ Data Generation $\rightarrow$ Stored Procedures.
3.  **Data Warehousing:** Designing the Data Warehouse (OLAP).
4.  **Presentation Layer:** Reports $\rightarrow$ Dashboards $\rightarrow$ Web Interface.

---

## 1️⃣ Analysis & Modeling (OLTP)
We started by designing a transactional database (OLTP) to handle the daily operations of the examination system.
* **ERD:** A highly normalized schema handling complex relationships (Many-to-Many) between Students, Exams, Questions, and Instructors.
* **Logic:** Implemented complex business logic using **Stored Procedures** and **Triggers** for:
    * `CreateExam`: Automated randomization of questions.
    * `StudentAnswer`: capturing student responses in real-time.
    * `ProcessFinishedExams`: Automating grading and archiving.

---

## 2️⃣ Operational Reporting (SSRS)
Using **SQL Server Reporting Services (SSRS)**, we developed pixel-perfect reports for official and operational use:
* **Student Certificates:** Automated generation of graduation certificates.
* **Exam Questions Report:** Reviewing question pools and difficulty levels.
* **Instructor Workload:** Tracking teaching hours and assigned courses.
* **Hiring & Freelance Reports:** Detailed lists of students hired or working as freelancers.

---

## 3️⃣ Data Warehousing (OLAP)
To enable high-performance analytics, we migrated data from the transactional system to a Data Warehouse designed with a **Galaxy Schema**.

![Galaxy Schema Diagram](https://github.com/user-attachments/assets/a8a7ed08-6d1e-4f85-8317-03b9b7755144)

**Key Components:**
* **Fact Tables:** `Fact_Exam`, `Fact_StudentAnswer`, `Fact_StudentResult`, `Fact_StudentFreelance` (Revenue tracking), `Fact_Hiring`.
* **Conformed Dimensions:** `Dim_Student`, `Dim_Course`, `Dim_Branch`, `Dim_Instructor`, `Dim_Date`.
* **ETL:** Extracting data from the SQL Engine, transforming it, and loading it into the Warehouse for analysis.

---

## 4️⃣ Business Intelligence (Power BI)
We created a massive interactive dashboard comprising over **20 pages** to provide 360-degree insights.

![Power BI Home Dashboard](https://github.com/user-attachments/assets/5fd22063-13a2-4d45-8ff2-4de41ebed17c)

### 📊 Dashboard Modules:
* **Student Overview:** Demographics, age distribution, and geographical analysis (Governorates).
* **Faculty & University Analysis:** Analyzing top-performing universities and faculties feeding into ITI.
* **Hiring & Salary:** Tracking post-graduation employment rates, top hiring companies, and average salaries by job role.
* **Freelance Intelligence (Unique):**
    * Analysis of freelance jobs secured by students *during* the intake.
    * Total Revenue generated ($34M+ simulated).
    * Top freelance platforms (Upwork, Freelancer) and skills in demand.
* **Certifications:** Tracking external certifications (Coursera, Udemy, etc.) earned by students.
* **Exam & Track Performance:** Detailed pass rates, average scores, and "Highest/Lowest" performing tracks and courses.
* **Instructor Analysis:** Correlation between instructor experience/salary and student performance.

---

## 5️⃣ Web Interface
A web-based interface allows users to interact with the system based on their roles:
* **Admin:** Manage branches, tracks, intakes, and student profiles (CRUD).
* **Instructor:** Create exams, monitor schedules, and view course analytics.
* **Student:** Take exams, view results, and log freelance/career achievements.

---

## 🚀 Conclusion & Future Roadmap
This project successfully migrated a raw transactional system into a sophisticated decision-support engine.

**Future Enhancements:**
* [ ] **Predictive Analytics:** Using ML to predict student dropout rates and exam failure risks.
* [ ] **Cloud Scalability:** Migrating the infrastructure to Microsoft Azure.
* [ ] **Mobile Integration:** Developing a dedicated mobile app for students.

---
*Built with ❤️ by the ITI BI Team*
