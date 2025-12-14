package com.jakartaproject.servlet;

import com.jakartaproject.entity.Student;
import com.jakartaproject.service.StudentService;
import jakarta.enterprise.inject.spi.CDI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    private StudentService getStudentService() {
        return CDI.current().select(StudentService.class).get();
    }

    private com.jakartaproject.service.UserService getUserService() {
        return CDI.current().select(com.jakartaproject.service.UserService.class).get();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check Authorization
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("edit".equals(action) && idParam != null && !idParam.isBlank()) {

            Long id = Long.parseLong(idParam);
            Student student = getStudentService().findById(id);
            request.setAttribute("student", student);
            request.getRequestDispatcher("/student-form.jsp").forward(request, response);

        } else if ("delete".equals(action) && idParam != null && !idParam.isBlank()) {

            Long id = Long.parseLong(idParam);
            getStudentService().delete(id);
            response.sendRedirect(request.getContextPath() + "/students");

        } else if ("new".equals(action)) {

            // ADD new student
            request.setAttribute("student", new Student());
            request.getRequestDispatcher("/student-form.jsp").forward(request, response);

        } else {
            // List all students
            List<Student> students = getStudentService().findAll();
            request.setAttribute("students", students);
            request.getRequestDispatcher("/students.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                createStudent(request);
            } else if ("update".equals(action)) {
                updateStudent(request);
            }

            response.sendRedirect(request.getContextPath() + "/students");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/student-form.jsp").forward(request, response);
        }
    }

    private void createStudent(HttpServletRequest request) {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        String enrollmentDateStr = request.getParameter("enrollmentDate");

        LocalDate enrollmentDate = LocalDate.parse(enrollmentDateStr, DateTimeFormatter.ISO_LOCAL_DATE);

        // 1. Create Student Profile
        Student student = new Student(name, email, enrollmentDate, major);
        getStudentService().create(student);

        // 2. Create User Login Account
        // Default password: password123
        // Username: email (to ensure uniqueness)
        com.jakartaproject.entity.User user = new com.jakartaproject.entity.User(email, "password123", email,
                "STUDENT");
        getUserService().createUser(user);
    }

    private void updateStudent(HttpServletRequest request) {

        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        String enrollmentDateStr = request.getParameter("enrollmentDate");
        String gpaStr = request.getParameter("gpa");

        Student student = getStudentService().findById(id);
        if (student != null) {

            student.setName(name);
            student.setEmail(email);
            student.setMajor(major);
            student.setEnrollmentDate(
                    LocalDate.parse(enrollmentDateStr, DateTimeFormatter.ISO_LOCAL_DATE));

            if (gpaStr != null && !gpaStr.isBlank()) {
                student.setGpa(BigDecimal.valueOf(Double.parseDouble(gpaStr)));
            }

            getStudentService().update(student);
        }
    }
}
