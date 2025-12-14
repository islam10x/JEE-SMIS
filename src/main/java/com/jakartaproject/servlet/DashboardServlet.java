package com.jakartaproject.servlet;

import com.jakartaproject.service.CourseService;
import com.jakartaproject.service.EnrollmentService;
import com.jakartaproject.service.StudentService;
import jakarta.enterprise.inject.spi.CDI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private StudentService getStudentService() {
        return CDI.current().select(StudentService.class).get();
    }

    private CourseService getCourseService() {
        return CDI.current().select(CourseService.class).get();
    }

    private EnrollmentService getEnrollmentService() {
        return CDI.current().select(EnrollmentService.class).get();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("studentCount", getStudentService().count());
        request.setAttribute("courseCount", getCourseService().count());
        request.setAttribute("enrollmentCount", getEnrollmentService().count());

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
