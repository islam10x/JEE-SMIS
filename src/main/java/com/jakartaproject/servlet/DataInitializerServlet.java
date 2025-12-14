package com.jakartaproject.servlet;

import com.jakartaproject.entity.User;
import com.jakartaproject.entity.Student;
import com.jakartaproject.entity.Course;
import com.jakartaproject.service.UserService;
import com.jakartaproject.service.StudentService;
import com.jakartaproject.service.CourseService;

import jakarta.enterprise.inject.spi.CDI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet(value = "/init-data", loadOnStartup = 1)
public class DataInitializerServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            initializeSampleData();
            System.out.println("Sample data initialized successfully!");
        } catch (Exception e) {
            System.err.println("Error initializing data: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            initializeSampleData();
            response.getWriter().write("Sample data initialized successfully! (Re-run)");
        } catch (Exception e) {
            response.getWriter().write("Error initializing data: " + e.getMessage());
        }
    }

    private void initializeSampleData() {

        UserService userService = CDI.current().select(UserService.class).get();
        StudentService studentService = CDI.current().select(StudentService.class).get();
        CourseService courseService = CDI.current().select(CourseService.class).get();

        // Create sample users
        if (userService.findByUsername("admin") == null) {
            userService.createUser(
                    new User("admin", "admin123", "admin@university.edu", "ADMIN"));
        }

        if (userService.findByUsername("student") == null) {
            userService.createUser(
                    new User("student", "student123", "student@university.edu", "STUDENT"));
        }

        // Create sample students
        if (studentService.findByEmail("student@university.edu") == null) {
            Student student1 = new Student("islam boubaker", "student@university.edu",
                    LocalDate.of(2023, 9, 1), "Computer Science");
            student1.setGpa(BigDecimal.valueOf(3.8));
            studentService.create(student1);
        }

        if (studentService.findByEmail("absd@university.edu") == null) {
            Student student2 = new Student("abcd", "abcd@university.edu",
                    LocalDate.of(2023, 9, 1),
                    "Information Technology");
            student2.setGpa(BigDecimal.valueOf(3.6));
            studentService.create(student2);
        }

        if (studentService.findByEmail("aziz@university.edu") == null) {
            Student s = new Student(
                    "aziz abdallah",
                    "aziz@university.edu",
                    LocalDate.of(2023, 9, 1),
                    "Software Engineering");
            s.setGpa(BigDecimal.valueOf(3.9));
            studentService.create(s);
        }

        // Create sample courses
        if (courseService.findAll().isEmpty()) {
            courseService.create(new Course("Introduction to Programming", "Dr. Ahmed", 3, 50));
            courseService.create(new Course("Data Structures and Algorithms", "Dr. Fatima", 4, 40));
            courseService.create(new Course("Database Systems", "Dr. Omar", 3, 45));
            courseService.create(new Course("Web Development", "Dr. Sarah", 3, 35));
            courseService.create(new Course("Software Engineering", "Dr. Mohammed", 4, 30));
        }
    }
}
