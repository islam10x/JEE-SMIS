<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <% //Check if user is logged in
                if (session.getAttribute("user")==null) {
                response.sendRedirect(request.getContextPath() + "/login" ); return; } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>SMIS - Students</title>
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
                                    <h2><i class="bi bi-people-fill me-2"></i>Students Management</h2>
                                    <a href="${pageContext.request.contextPath}/students?action=new"
                                        class="btn btn-primary">
                                        <i class="bi bi-person-plus-fill me-2"></i>Add New Student
                                    </a>
                                </div>

                                <!-- Students Table -->
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Major</th>
                                                <th>Enrollment Date</th>
                                                <th>GPA</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="student" items="${students}">
                                                <tr>
                                                    <td>${student.id}</td>
                                                    <td>${student.name}</td>
                                                    <td>${student.email}</td>
                                                    <td><span class="badge bg-info">${student.major}</span></td>
                                                    <td>${student.enrollmentDate}</td>
                                                    <td>
                                                        <c:if test="${student.gpa != null}">
                                                            <span class="badge bg-success">${student.gpa}</span>
                                                        </c:if>
                                                        <c:if test="${student.gpa == null}">
                                                            <span class="text-muted">Not Set</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/students?action=edit&id=${student.id}"
                                                            class="btn btn-sm btn-success me-1">
                                                            <i class="bi bi-pencil-fill"></i> Edit
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/students?action=delete&id=${student.id}"
                                                            class="btn btn-sm btn-danger"
                                                            onclick="return confirm('Are you sure you want to delete this student?')">
                                                            <i class="bi bi-trash-fill"></i> Delete
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty students}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-4">
                                                        <i class="bi bi-info-circle-fill text-muted fs-1 mb-2"></i>
                                                        <p class="text-muted mb-0">No students found. <a
                                                                href="${pageContext.request.contextPath}/students?action=new">Add
                                                                the first student</a>.</p>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Statistics -->
                                <div class="row mt-4">
                                    <div class="col-md-4">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <h4 class="text-primary">${students.size()}</h4>
                                                <p class="mb-0">Total Students</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <h4 class="text-success">
                                                    <c:set var="withGpa" value="0" />
                                                    <c:forEach var="student" items="${students}">
                                                        <c:if test="${student.gpa != null}">
                                                            <c:set var="withGpa" value="${withGpa + 1}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    ${withGpa}
                                                </h4>
                                                <p class="mb-0">With GPA</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <c:set var="avgGpa" value="0" />
                                                <c:set var="count" value="0" />
                                                <c:forEach var="student" items="${students}">
                                                    <c:if test="${student.gpa != null}">
                                                        <c:set var="avgGpa" value="${avgGpa + student.gpa}" />
                                                        <c:set var="count" value="${count + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                <h4 class="text-info">
                                                    <c:if test="${count > 0}">
                                                        <fmt:formatNumber value="${avgGpa / count}"
                                                            maxFractionDigits="2" />
                                                    </c:if>
                                                    <c:if test="${count == 0}">N/A</c:if>
                                                </h4>
                                                <p class="mb-0">Average GPA</p>
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