<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <nav class="col-md-2 sidebar p-3">
            <div class="d-flex flex-column">
                <h5 class="mb-4">
                    <i class="bi bi-mortarboard-fill me-2"></i>SMIS
                </h5>

                <ul class="nav flex-column">
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="bi bi-house-door-fill me-2"></i>Dashboard
                        </a>
                    </li>
                    <c:if test="${sessionScope.role == 'ADMIN'}">
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/students">
                                <i class="bi bi-people-fill me-2"></i>Students
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/courses">
                                <i class="bi bi-book-fill me-2"></i>Courses
                            </a>
                        </li>
                    </c:if>
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
                            <strong>
                                <c:out value="${sessionScope.username}" />
                            </strong>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm w-100">
                        <i class="bi bi-box-arrow-right me-2"></i>Logout
                    </a>
                </div>
            </div>
        </nav>