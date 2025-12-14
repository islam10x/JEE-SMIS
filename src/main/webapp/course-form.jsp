<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>SMIS - ${empty course.id ? 'Add New Course' : 'Edit Course'}</title>
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
                    <!-- Sidebar -->
                    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

                    <!-- Main Content -->
                    <main class="col-md-10 p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2>
                                <i class="bi bi-book${empty course.id ? '-plus' : ''}-fill me-2"></i>
                                ${empty course.id ? 'Add New Course' : 'Edit Course'}
                            </h2>
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-secondary">
                                <i class="bi bi-arrow-left me-2"></i>Back to Courses
                            </a>
                        </div>

                        <div class="card border-0 shadow-sm">
                            <div class="card-body p-4">
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger" role="alert">
                                        ${error}
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/courses" method="post">
                                    <input type="hidden" name="action" value="${empty course.id ? 'create' : 'update'}">
                                    <c:if test="${not empty course.id}">
                                        <input type="hidden" name="id" value="${course.id}">
                                    </c:if>

                                    <div class="mb-3">
                                        <label for="name" class="form-label">Course Name</label>
                                        <input type="text" class="form-control" id="name" name="name"
                                            value="${course.name}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="instructor" class="form-label">Instructor</label>
                                        <input type="text" class="form-control" id="instructor" name="instructor"
                                            value="${course.instructor}" required>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="credits" class="form-label">Credits</label>
                                            <input type="number" class="form-control" id="credits" name="credits"
                                                value="${course.credits}" min="1" max="10" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="capacity" class="form-label">Capacity</label>
                                            <input type="number" class="form-control" id="capacity" name="capacity"
                                                value="${course.capacity}" min="1" required>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                                        <a href="${pageContext.request.contextPath}/courses"
                                            class="btn btn-light me-2">Cancel</a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-save me-2"></i>Save Course
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>