<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <% // Check if user is logged in
                if (session.getAttribute("user")==null) {
                response.sendRedirect(request.getContextPath() + "/login" ); return; } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>SMIS - Dashboard</title>
                    <!-- Bootstrap CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <!-- Bootstrap Icons -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        .sidebar {
                            min-height: 100vh;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                        }

                        .sidebar .nav-link {
                            color: rgba(255, 255, 255, 0.8);
                            transition: all 0.3s;
                        }

                        .sidebar .nav-link:hover {
                            color: white;
                            background-color: rgba(255, 255, 255, 0.1);
                            border-radius: 5px;
                        }

                        .sidebar .nav-link.active {
                            color: white;
                            background-color: rgba(255, 255, 255, 0.2);
                            border-radius: 5px;
                        }

                        .card {
                            border: none;
                            border-radius: 15px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                            transition: transform 0.3s;
                        }

                        .card:hover {
                            transform: translateY(-5px);
                        }

                        .stats-card {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                        }

                        .btn-primary {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            border: none;
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
                            <!-- Sidebar -->
                            <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

                            <!-- Main Content -->
                            <main class="col-md-10 p-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2><i class="bi bi-house-door-fill me-2"></i>Dashboard</h2>
                                    <div class="text-muted">
                                        <%= new java.util.Date() %>
                                    </div>
                                </div>

                                <!-- Stats Cards -->
                                <div class="row mb-4">
                                    <div class="col-md-3 mb-3">
                                        <div class="card stats-card text-white h-100">
                                            <div class="card-body text-center">
                                                <i class="bi bi-people-fill fs-1 mb-2"></i>
                                                <h3>${studentCount}</h3>
                                                <p class="mb-0">Total Students</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <div class="card stats-card text-white h-100">
                                            <div class="card-body text-center">
                                                <i class="bi bi-book-fill fs-1 mb-2"></i>
                                                <h3>${courseCount}</h3>
                                                <p class="mb-0">Total Courses</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <div class="card stats-card text-white h-100">
                                            <div class="card-body text-center">
                                                <i class="bi bi-journal-check fs-1 mb-2"></i>
                                                <h3>${enrollmentCount}</h3>
                                                <p class="mb-0">Enrollments</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <div class="card stats-card text-white h-100">
                                            <div class="card-body text-center">
                                                <i class="bi bi-trophy-fill fs-1 mb-2"></i>
                                                <h3>95%</h3>
                                                <p class="mb-0">Avg. Pass Rate</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Quick Actions -->
                                <div class="row">
                                    <div class="col-md-6 mb-4">
                                        <div class="card">
                                            <div class="card-header">
                                                <h5 class="mb-0"><i class="bi bi-lightning-charge-fill me-2"></i>Quick
                                                    Actions</h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="d-grid gap-2">
                                                    <c:choose>
                                                        <c:when test="${sessionScope.role == 'ADMIN'}">
                                                            <a href="${pageContext.request.contextPath}/students?action=new"
                                                                class="btn btn-primary">
                                                                <i class="bi bi-person-plus-fill me-2"></i>Add New
                                                                Student
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/courses?action=new"
                                                                class="btn btn-primary">
                                                                <i class="bi bi-book-half me-2"></i>Add New Course
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/enrollments"
                                                                class="btn btn-primary">
                                                                <i class="bi bi-journal-check me-2"></i>View Enrollments
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${sessionScope.role == 'STUDENT'}">
                                                            <a href="${pageContext.request.contextPath}/enrollments?action=enroll"
                                                                class="btn btn-primary">
                                                                <i class="bi bi-journal-plus me-2"></i>Enroll in New
                                                                Course
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/enrollments"
                                                                class="btn btn-outline-primary">
                                                                <i class="bi bi-journal-text me-2"></i>My Enrollments
                                                            </a>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-4">
                                        <div class="card">
                                            <div class="card-header">
                                                <h5 class="mb-0"><i class="bi bi-info-circle-fill me-2"></i>System Info
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <p class="mb-2"><strong>Role:</strong>
                                                    <%= session.getAttribute("role") %>
                                                </p>
                                                <p class="mb-2"><strong>Session ID:</strong>
                                                    <%= session.getId() %>
                                                </p>
                                                <p class="mb-0"><strong>Last Login:</strong>
                                                    <%= new java.util.Date(session.getLastAccessedTime()) %>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </main>
                        </div>
                    </div>

                    <!-- Bootstrap JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>