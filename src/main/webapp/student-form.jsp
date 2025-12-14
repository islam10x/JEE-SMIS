<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SMIS - ${student != null ? 'Edit' : 'Add'} Student</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover {
            color: white;
            background-color: rgba(255,255,255,0.1);
            border-radius: 5px;
        }
        .sidebar .nav-link.active {
            color: white;
            background-color: rgba(255,255,255,0.2);
            border-radius: 5px;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-2 sidebar p-3">
                <div class="d-flex flex-column">
                    <h5 class="mb-4">
                        <i class="bi bi-mortarboard-fill me-2"></i>SMIS
                    </h5>

                    <ul class="nav flex-column">
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/dashboard.jsp">
                                <i class="bi bi-house-door-fill me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/students">
                                <i class="bi bi-people-fill me-2"></i>Students
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/courses">
                                <i class="bi bi-book-fill me-2"></i>Courses
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/enrollments">
                                <i class="bi bi-journal-check me-2"></i>Enrollments
                            </a>
                        </li>
                    </ul>

                    <hr class="my-4">

                    <div class="mt-auto">
                        <div class="d-flex align-items-center mb-3">
                            <i class="bi bi-person-circle fs-4 me-2"></i>
                            <div>
                                <small>Welcome,</small><br>
                                <strong><%= session.getAttribute("username") %></strong>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm w-100">
                            <i class="bi bi-box-arrow-right me-2"></i>Logout
                        </a>
                    </div>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>
                        <i class="bi bi-${student != null ? 'pencil' : 'person-plus'}-fill me-2"></i>
                        ${student != null ? 'Edit' : 'Add'} Student
                    </h2>
                    <a href="${pageContext.request.contextPath}/students" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Back to Students
                    </a>
                </div>

                <!-- Form Card -->
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-body p-4">
                                <% if (request.getAttribute("error") != null) { %>
                                    <div class="alert alert-danger" role="alert">
                                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                        <%= request.getAttribute("error") %>
                                    </div>
                                <% } %>

                                <form action="${pageContext.request.contextPath}/students" method="post">
                                    <input type="hidden" name="action" value="${student != null ? 'update' : 'create'}">
                                    <c:if test="${student != null}">
                                        <input type="hidden" name="id" value="${student.id}">
                                    </c:if>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="name" class="form-label">
                                                <i class="bi bi-person-fill me-2"></i>Full Name *
                                            </label>
                                            <input type="text" class="form-control" id="name" name="name"
                                                   value="${student.name}" required maxlength="100">
                                        </div>

                                        <div class="col-md-6 mb-3">
                                            <label for="email" class="form-label">
                                                <i class="bi bi-envelope-fill me-2"></i>Email Address *
                                            </label>
                                            <input type="email" class="form-control" id="email" name="email"
                                                   value="${student.email}" required maxlength="100">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="major" class="form-label">
                                                <i class="bi bi-mortarboard-fill me-2"></i>Major *
                                            </label>
                                            <select class="form-control" id="major" name="major" required>
                                                <option value="">Select Major</option>
                                                <option value="Computer Science" ${student.major == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                                                <option value="Information Technology" ${student.major == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                                                <option value="Software Engineering" ${student.major == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                                                <option value="Data Science" ${student.major == 'Data Science' ? 'selected' : ''}>Data Science</option>
                                                <option value="Cybersecurity" ${student.major == 'Cybersecurity' ? 'selected' : ''}>Cybersecurity</option>
                                                <option value="Business Administration" ${student.major == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
                                                <option value="Mathematics" ${student.major == 'Mathematics' ? 'selected' : ''}>Mathematics</option>
                                                <option value="Physics" ${student.major == 'Physics' ? 'selected' : ''}>Physics</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6 mb-3">
                                            <label for="enrollmentDate" class="form-label">
                                                <i class="bi bi-calendar-event-fill me-2"></i>Enrollment Date *
                                            </label>
                                            <input type="date" class="form-control" id="enrollmentDate" name="enrollmentDate"
                                                   value="${student.enrollmentDate}" required>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="gpa" class="form-label">
                                            <i class="bi bi-graph-up me-2"></i>GPA (Optional)
                                        </label>
                                        <input type="number" class="form-control" id="gpa" name="gpa"
                                               value="${student.gpa}" min="0.0" max="4.0" step="0.01"
                                               placeholder="Enter GPA (0.0 - 4.0)">
                                        <div class="form-text">Leave empty if GPA is not yet calculated</div>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <a href="${pageContext.request.contextPath}/students" class="btn btn-outline-secondary me-md-2">
                                            <i class="bi bi-x-circle me-2"></i>Cancel
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-check-circle me-2"></i>
                                            ${student != null ? 'Update' : 'Create'} Student
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set default date for new students
        document.addEventListener('DOMContentLoaded', function() {
            const enrollmentDate = document.getElementById('enrollmentDate');
            if (!enrollmentDate.value) {
                const today = new Date();
                const formattedDate = today.toISOString().split('T')[0];
                enrollmentDate.value = formattedDate;
            }
        });
    </script>
</body>
</html>
