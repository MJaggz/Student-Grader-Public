# Project 2 - Rails Project to Manage Student Graders

This is a Ruby on Rails web application for managing CSE course and section data for student grader assignments. The system is designed to streamline the process of collecting course information, supporting user authentication, and preparing the application for future grader matching functionality.

—
##  Development Team

This project was developed for the course CSE 3901 at The Ohio State University by the following authors:
Mohamed Jama
Jay Koduru
Success Oguntuyi
 Kierra Smith
 Daphne Kaur

---

##  Overview

This project implements the foundation of a student grader management system using Ruby on Rails.

This application includes:

- User authentication with login, logout, and registration
- Role-based access for Students, Instructors, and Admins
- Admin approval workflow for instructor and Admin accounts
- OSU email validation using the name.#@osu.edu format
- A default Admin account
- Database storage for course and section data
- API integration with the OSU course catalog for CSE classes
- Admin only functionality to reload course catalog data into the database
- A shared course catalog view accessible to Students, Instructors, and Admins

---

##  Tech Stack

- HTML5
- CSS3
- Ruby
- Ruby on Rails
- SQLite3
- Pagy

---
## Directory Structure
```bash
GRADER_MANAGER/
│
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── courses_controller.rb
│   │   ├── home_controller.rb
│   │   ├── notifications_controller.rb
│   │   ├── sections_controller.rb
│   │   └── users_controller.rb
│   │
│   ├── models/
│   │   ├── application_record.rb
│   │   ├── course.rb
│   │   ├── section.rb
│   │   └── user.rb
│   │
│   └── views/
│       ├── courses/
│       │   ├── configuration.html.erb
│       │   ├── edit.html.erb
│       │   └── index.html.erb
│       │
│       ├── devise/
│       │   ├── confirmations/
│       │   ├── mailer/
│       │   ├── passwords/
│       │   ├── registrations/
│       │   ├── sessions/
│       │   ├── shared/
│       │   └── unlocks/
│       │
│       ├── home/
│       ├── notifications/
│       ├── sections/
│       └── users/
│
└── config/
    └── routes.rb
```
---

##  How to Run

1. Clone the repository and navigate to the project folder.
2. Install the required gems, setup the database, and start the rails server with the following commands.
- Bundle install
- bin/rails db:migrate
- bin/rails db.seed
- bin/rails server
3. Open http://localhost:3000

---

##  Default Admin Account

A default Admin Account is created through the seed file for testing and setup purposes.

- Email: admin.1@osu.edu
- Password: password123

This account can be used to:

- Browse the catalog
- Approve instructor and Admin requests
- Edit the catalog
- Reload the catalog from the OSU API

---

##  OSU API Information

This project uses the OSU course catalog API to retrieve CSE course and section data.
Base API URL:

https://contenttest.osu.edu/v2/classes/search

- Example parameters include:
- campus=col
- term=1224
- subject=cse
- academic-career=ugrad
- p=1

This application uses these results to populate the local database so the catalog can be viewed and managed within the Rails app.

---

##  Screenshots

Below are examples of the application's user interface and key functionality.

1. Home page which allows users to either log in, sign up, create a new account, or browse the course catalog if they are already authenticated. ![Home Page](<app/assets/images/home page.png>)

2. Login page where registered users can log in with their OSU email credentials. Devise handles authentication and password validation.![Login Page](<app/assets/images/login page.png>)

3. Notifications center to allow users to view notifications related to their account or course activity. ![Notifications Center](<app/assets/images/notifications.png>)

4. Settings page where users can update their passwords or deleting their account. ![Settings Page](<app/assets/images/settings.png>)


5. Admin Dashboard where after logging in as an Admin, the user can access administrative functionality. ![Admin Dashboard](<app/assets/images/admin dashboard.png>)


6. User administration page where Admins can see the status of all the users along with their approval status.![User Administration Page](<app/assets/images/user administration.png>)


7. Reload catalog page where only Admins can reload course data directly from the OSU course API. ![Reload Catalog Page](<app/assets/images/reloading catalog.png>)


8. Course catalog view where Students, Instructors, and Admins can browse the available CSE courses and their sections. ![Course Catalog](<app/assets/images/course catalog.png>)


9. View course section where users can view all avaliable sections of a selected course along with details. ![All avaliable sections](<app/assets/images/sections.png>)


10. Editing a course section which only Admins have the abilty to modify course parameters when necessary. ![Editing a course page](<app/assets/images/editing.png>)



---

##  Troubleshooting 

Below are some issues that we faced when working on the application:

1. Server will not start

If the Rails server does not start, ensure all the dependencies are installed and everything is up to date.

- Bundle install
- bin/rails db:migrate
- bin/rails server

2. Database errors or missing tables

If there are database errors, run the migrations and reseed the database. If it still persists, reset the database.

-bin/rails db:reset

3. Login issues

Ensure that the email used follows the required format:

- name.#@osu.edu
If testing with the default admin account, verify that the seed file was executed.