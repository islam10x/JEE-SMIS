package com.jakartaproject.servlet;

import com.jakartaproject.entity.Enrollment;
import com.jakartaproject.entity.Student;
import com.jakartaproject.service.EnrollmentService;
import com.jakartaproject.service.StudentService;
import com.jakartaproject.service.CourseService;
import jakarta.enterprise.inject.spi.CDI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/enrollments")
public class EnrollmentServlet extends HttpServlet {

    private EnrollmentService getEnrollmentService() {
        return CDI.current().select(EnrollmentService.class).get();
    }

    private StudentService getStudentService() {
        return CDI.current().select(StudentService.class).get();
    }

    private CourseService getCourseService() {
        return CDI.current().select(CourseService.class).get();
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

        String action = request.getParameter("action");
        String role = (String) session.getAttribute("role");

        if ("enroll".equals(action) && "STUDENT".equals(role)) {
            // Show available courses for student to enroll
            request.setAttribute("courses", getCourseService().findAll());
            // Forward to the FORM page
            request.getRequestDispatcher("/enrollment-form.jsp").forward(request, response);
        } else if ("unenroll".equals(action)) {
            Long studentId = Long.parseLong(request.getParameter("studentId"));
            Long courseId = Long.parseLong(request.getParameter("courseId"));
            getEnrollmentService().unenrollStudentFromCourse(studentId, courseId);
            response.sendRedirect(request.getContextPath() + "/enrollments");
        } else if ("grade".equals(action) && "ADMIN".equals(role)) {
            Long enrollmentId = Long.parseLong(request.getParameter("id"));
            String gradeStr = request.getParameter("grade");
            if (gradeStr != null && !gradeStr.trim().isEmpty()) {
                BigDecimal grade = BigDecimal.valueOf(Double.parseDouble(gradeStr));
                getEnrollmentService().updateGrade(enrollmentId, grade);
            }
            response.sendRedirect(request.getContextPath() + "/enrollments");
        } else {
            // LIST enrollments
            List<Enrollment> enrollments;
            
            if ("STUDENT".equals(role)) {
                // Find the student entity for this user
                com.jakartaproject.entity.User user = (com.jakartaproject.entity.User) session.getAttribute("user");
                Student student = getStudentService().findByEmail(user.getEmail());
                if (student != null) {
                    enrollments = getEnrollmentService().findByStudent(student.getId());
                } else {
                    enrollments = List.of();
                }
            } else {
                // Admin sees all
                enrollments = getEnrollmentService().findAll();
            }

            request.setAttribute("enrollments", enrollments);
            request.getRequestDispatcher("/enrollments.jsp").forward(request, response);
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
        String role = (String) session.getAttribute("role");

        try {
            if ("add".equals(action) && "STUDENT".equals(role)) {
                // Determine student ID from logged-in user's email
                com.jakartaproject.entity.User user = (com.jakartaproject.entity.User) session.getAttribute("user");
                String userEmail = user.getEmail();

                Student student = getStudentService().findByEmail(userEmail);
                if (student == null) {
                    throw new Exception("No Student profile found for user: " + userEmail);
                }

                Long courseId = Long.parseLong(request.getParameter("courseId"));
                getEnrollmentService().enrollStudentInCourse(student.getId(), courseId);

                // Redirect to the LIST page to see the new enrollment
                response.sendRedirect(request.getContextPath() + "/enrollments");
                return;

            } else if ("enroll".equals(action)) {
                // Admin manually enrolling a student
                Long studentId = Long.parseLong(request.getParameter("studentId"));
                Long courseId = Long.parseLong(request.getParameter("courseId"));
                getEnrollmentService().enrollStudentInCourse(studentId, courseId);
                response.sendRedirect(request.getContextPath() + "/enrollments");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/enrollments");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            // If failed during student enrollment, show the form again
            if ("add".equals(action)) {
                request.setAttribute("courses", getCourseService().findAll());
                request.getRequestDispatcher("/enrollment-form.jsp").forward(request, response);
            } else {
                // Admin error
                response.sendRedirect(request.getContextPath() + "/enrollments"); 
            }
        }
    }
}
