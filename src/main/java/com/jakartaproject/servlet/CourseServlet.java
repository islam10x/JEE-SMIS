package com.jakartaproject.servlet;

import com.jakartaproject.entity.Course;
import com.jakartaproject.service.CourseService;
import jakarta.enterprise.inject.spi.CDI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/courses")
public class CourseServlet extends HttpServlet {

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

        // Check authorization
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("edit".equals(action) && idParam != null && !idParam.isBlank()) {
            Long id = Long.parseLong(idParam);
            Course course = getCourseService().findById(id);
            request.setAttribute("course", course);
            request.getRequestDispatcher("/course-form.jsp").forward(request, response);

        } else if ("delete".equals(action) && idParam != null && !idParam.isBlank()) {
            Long id = Long.parseLong(idParam);
            getCourseService().delete(id);
            response.sendRedirect(request.getContextPath() + "/courses");

        } else if ("new".equals(action)) {
            // Add new course
            request.setAttribute("course", new Course());
            request.getRequestDispatcher("/course-form.jsp").forward(request, response);

        } else {
            // List all courses
            List<Course> courses = getCourseService().findAll();
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/courses.jsp").forward(request, response);
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
                createCourse(request);
            } else if ("update".equals(action)) {
                updateCourse(request);
            }

            response.sendRedirect(request.getContextPath() + "/courses");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/course-form.jsp").forward(request, response);
        }
    }

    private void createCourse(HttpServletRequest request) {
        String name = request.getParameter("name");
        String instructor = request.getParameter("instructor");
        String creditsStr = request.getParameter("credits");
        String capacityStr = request.getParameter("capacity");

        Integer credits = creditsStr != null && !creditsStr.isBlank() ? Integer.parseInt(creditsStr) : 0;
        Integer capacity = capacityStr != null && !capacityStr.isBlank() ? Integer.parseInt(capacityStr) : 0;

        Course course = new Course(name, instructor, credits, capacity);
        getCourseService().create(course);
    }

    private void updateCourse(HttpServletRequest request) {
        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        String instructor = request.getParameter("instructor");
        String creditsStr = request.getParameter("credits");
        String capacityStr = request.getParameter("capacity");

        Integer credits = creditsStr != null && !creditsStr.isBlank() ? Integer.parseInt(creditsStr) : 0;
        Integer capacity = capacityStr != null && !capacityStr.isBlank() ? Integer.parseInt(capacityStr) : 0;

        Course course = getCourseService().findById(id);
        if (course != null) {
            course.setName(name);
            course.setInstructor(instructor);
            course.setCredits(credits);
            course.setCapacity(capacity);

            getCourseService().update(course);
        }
    }
}
