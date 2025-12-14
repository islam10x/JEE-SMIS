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
                    <title>SMIS - Courses</title>
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

                        .table-responsive {
                            border-radius: 10px;
                            overflow: hidden;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                        }

                        .btn-primary {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            border: none;
                        }

                        .btn-primary:hover {
                            background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
                        }

                        .btn-success:hover {
                            background-color: #198754;
                            transform: scale(1.05);
                        }

                        .btn-danger:hover {
                            background-color: #dc3545;
                            transform: scale(1.05);
                        }

                        .capacity-badge {
                            position: relative;
                        }

                        .capacity-badge.full {
                            opacity: 0.6;
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
                                    <h2><i class="bi bi-book-fill me-2"></i>Courses Management</h2>
                                    <a href="${pageContext.request.contextPath}/courses?action=new"
                                        class="btn btn-primary">
                                        <i class="bi bi-book-half me-2"></i>Add New Course
                                    </a>
                                </div>

                                <!-- Courses Table -->
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Course Name</th>
                                                <th>Instructor</th>
                                                <th>Credits</th>
                                                <th>Capacity</th>
                                                <th>Enrolled</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="course" items="${courses}">
                                                <tr>
                                                    <td>${course.id}</td>
                                                    <td>
                                                        <strong>${course.name}</strong>
                                                    </td>
                                                    <td>
                                                        <i class="bi bi-person-fill me-1"></i>${course.instructor}
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-primary">${course.credits} credits</span>
                                                    </td>
                                                    <td>${course.capacity}</td>
                                                    <td>${course.currentEnrollmentCount}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${course.full}">
                                                                <span class="badge bg-danger">Full</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-success">Available</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/courses?action=edit&id=${course.id}"
                                                            class="btn btn-sm btn-success me-1">
                                                            <i class="bi bi-pencil-fill"></i> Edit
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/courses?action=delete&id=${course.id}"
                                                            class="btn btn-sm btn-danger"
                                                            onclick="return confirm('Are you sure you want to delete this course?')">
                                                            <i class="bi bi-trash-fill"></i> Delete
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty courses}">
                                                <tr>
                                                    <td colspan="8" class="text-center py-4">
                                                        <i class="bi bi-info-circle-fill text-muted fs-1 mb-2"></i>
                                                        <p class="text-muted mb-0">No courses found. <a
                                                                href="${pageContext.request.contextPath}/courses?action=new">Add
                                                                the first course</a>.</p>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Statistics -->
                                <div class="row mt-4">
                                    <div class="col-md-3">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <h4 class="text-primary">${courses.size()}</h4>
                                                <p class="mb-0">Total Courses</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <c:set var="totalCapacity" value="0" />
                                                <c:forEach var="course" items="${courses}">
                                                    <c:set var="totalCapacity"
                                                        value="${totalCapacity + course.capacity}" />
                                                </c:forEach>
                                                <h4 class="text-info">${totalCapacity}</h4>
                                                <p class="mb-0">Total Capacity</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <c:set var="totalEnrolled" value="0" />
                                                <c:forEach var="course" items="${courses}">
                                                    <c:set var="totalEnrolled"
                                                        value="${totalEnrolled + course.currentEnrollmentCount}" />
                                                </c:forEach>
                                                <h4 class="text-success">${totalEnrolled}</h4>
                                                <p class="mb-0">Total Enrolled</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <c:set var="fullCourses" value="0" />
                                                <c:forEach var="course" items="${courses}">
                                                    <c:if test="${course.full}">
                                                        <c:set var="fullCourses" value="${fullCourses + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                <h4 class="text-warning">${fullCourses}</h4>
                                                <p class="mb-0">Full Courses</p>
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