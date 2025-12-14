<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>SMIS - Enroll in New Course</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
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
            </style>
        </head>

        <body>
            <div class="container-fluid">
                <div class="row">
                    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
                    <main class="col-md-10 p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2><i class="bi bi-journal-plus me-2"></i>Available Courses</h2>
                            <a href="${pageContext.request.contextPath}/enrollments" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-2"></i>Back to My Enrollments
                            </a>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                            </div>
                        </c:if>

                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Course Name</th>
                                                <th>Instructor</th>
                                                <th>Credits</th>
                                                <th>Capacity</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="course" items="${courses}">
                                                <tr>
                                                    <td>
                                                        <strong>${course.name}</strong>
                                                    </td>
                                                    <td>
                                                        <i class="bi bi-person-fill me-1"></i>${course.instructor}
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-secondary">${course.credits}
                                                            Credits</span>
                                                    </td>
                                                    <td>${course.currentEnrollmentCount} / ${course.capacity}</td>
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
                                                        <c:choose>
                                                            <c:when test="${course.full}">
                                                                <button class="btn btn-sm btn-secondary"
                                                                    disabled>Full</button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form
                                                                    action="${pageContext.request.contextPath}/enrollments"
                                                                    method="post">
                                                                    <input type="hidden" name="action" value="add">
                                                                    <input type="hidden" name="courseId"
                                                                        value="${course.id}">
                                                                    <button type="submit"
                                                                        class="btn btn-sm btn-primary">
                                                                        <i class="bi bi-plus-circle me-1"></i> Enroll
                                                                    </button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty courses}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-4 text-muted">
                                                        No courses available at this time.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>