Introduction to Databases (SQL Focus)
What is a Database?

A database is an organized collection of data that allows us to store, manage, and retrieve information efficiently. Unlike storing data in files or spreadsheets, databases provide:

Persistence: Data remains available over time.

Speed & reliability: Optimized for fast queries and secure access.

Consistency: Ensures data is accurate and does not conflict.

Example:
The difference between a simple website with static pages and a database-driven website is that databases allow you to separate data from presentation, and fetch different pieces of information dynamically.

Why Do We Need Databases?

Without databases, data is usually stored in:

Files (text, CSV, etc.)

Spreadsheets (e.g., Excel)

Problems with spreadsheets or raw files:

Update anomaly: If a student’s email changes, you must update it in multiple places → risk of inconsistency.

Deletion anomaly: If you delete a student’s name, you may lose their entire row (including unrelated info like courses or grades).

Insertion anomaly: Adding new data (e.g., a new course) may require incomplete or duplicate rows.

Databases solve these problems by enforcing data integrity.

Data Integrity & Data Models

Data integrity depends on how we design the schema (data model).

A schema defines how data is structured (tables, columns, relationships).

Entities are represented as tables, and their properties are represented as columns (attributes).

Good design avoids redundancy, inconsistency, and anomalies.

Entities & Attributes

An Entity is something we store data about.
An Attribute is a property of that entity.

Example 1: Students & Courses

Student entity: StudentID, Name, Email, Grades

Course entity: CourseID, CourseName, MaxEnrollment, Professor

Relationships:

Student ↔ Course: Many-to-Many (N:N) – one student can take many courses, and one course can have many students.

Course ↔ Professor: Many-to-One (N:1) – many courses can be taught by one professor.

ERD (Entity-Relationship Diagram)

We use ERDs to visualize entities and their relationships.

⚠️ Rule: Multi-valued attributes are not allowed.
If an attribute has multiple values (e.g., multiple songs in an album), create a separate entity.

Example 2: Music Database

Artist: ArtistID, Name, Genre, Type

Album: AlbumID, Title, Year, ArtistID

Song: SongID, Title, AlbumID

User: UserID, Name, Tracklist

Relationships:

Album ↔ Song = One-to-Many

Song ↔ User (playlist) = Many-to-Many → must use a junction table (e.g., UserSong with UserID + SongID).

Many-to-Many Problem

M:N relationships cannot exist directly in relational models.

They must be broken into two One-to-Many relationships using a junction/association table.

Example:
StudentCourse (StudentID, CourseID) → resolves the N:N between Students and Courses.

Keys & Identifiers

Each table must have a Primary Key (unique identifier) to ensure each row can be referenced.
Examples:

Student: StudentID

Course: CourseID

Song: SongID

Foreign keys are used to link relationships between tables.


ERD modeling ensures we avoid many-to-many issues and preserve data integrity.

------------------------------------
Anomolies means some of the rows are empty and is empty.

------------------------
A UML diagram is a visual tool that uses the standardized Unified Modeling Language (UML) to represent the structure, behavior, and interaction of a system, such as a software application or a business process. UML diagrams help engineers, project managers, and other professionals understand, design, and document complex systems by breaking them down into manageable components and relationships, acting as a "blueprint" for development.UML, or Unified Modeling Language, in the context of databases, refers to the use of UML diagrams to visually represent and model the structure and relationships within a database system
=======each record with all attributes will be  called instance. 
whole record in a table = instance 
+=========
composite : tarkib do ta entity
-----
updating -repating is matters in entity.
----
the reason that we called it Primary key is : each instance would be uniquely identified in that table.
