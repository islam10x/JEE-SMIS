<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>SMIS - My Enrollments</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
                                <h2><i class="bi bi-journal-check me-2"></i>My Enrollments</h2>
                                <c:if test="${sessionScope.role == 'STUDENT'}">
                                    <a href="${pageContext.request.contextPath}/enrollments?action=enroll"
                                        class="btn btn-primary">
                                        <i class="bi bi-plus-circle me-2"></i>Enroll in New Course
                                    </a>
                                </c:if>
                            </div>

                            <div class="card border-0 shadow-sm">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Course</th>
                                                    <th>Instructor</th>
                                                    <th>Date Enrolled</th>
                                                    <th>Grade</th>
                                                    <th>Status</th>
                                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                                        <th>Student</th>
                                                    </c:if>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="enrollment" items="${enrollments}">
                                                    <tr>
                                                        <td>
                                                            <strong>${enrollment.course.name}</strong><br>
                                                            <small class="text-muted">${enrollment.course.credits}
                                                                Credits</small>
                                                        </td>
                                                        <td>${enrollment.course.instructor}</td>
                                                        <td>${enrollment.enrollmentDate}</td>
                                                        <td>
                                                            <c:if test="${enrollment.grade != null}">
                                                                <span
                                                                    class="badge bg-success">${enrollment.grade}</span>
                                                            </c:if>
                                                            <c:if test="${enrollment.grade == null}">
                                                                <span class="text-muted">N/A</span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-info">Enrolled</span>
                                                        </td>
                                                        <c:if test="${sessionScope.role == 'ADMIN'}">
                                                            <td>
                                                                <strong>${enrollment.student.name}</strong><br>
                                                                <small class="text-muted"><a
                                                                        href="mailto:${enrollment.student.email}">${enrollment.student.email}</a></small>
                                                            </td>
                                                        </c:if>
                                                        <td>
                                                            <c:if test="${sessionScope.role == 'STUDENT'}">
                                                                <a href="${pageContext.request.contextPath}/enrollments?action=unenroll&studentId=${enrollment.student.id}&courseId=${enrollment.course.id}"
                                                                    class="btn btn-sm btn-outline-danger"
                                                                    onclick="return confirm('Are you sure you want to drop this course?')">
                                                                    <i class="bi bi-x-circle"></i> Drop
                                                                </a>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty enrollments}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-4 text-muted">
                                                            You are not enrolled in any courses yet.
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