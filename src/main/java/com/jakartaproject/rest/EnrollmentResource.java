package com.jakartaproject.rest;

import com.jakartaproject.service.EnrollmentService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.HashMap;
import java.util.Map;

@Path("/enrollments")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EnrollmentResource {

    @Inject
    private EnrollmentService enrollmentService;

    @POST
    public Response enrollStudent(Map<String, Long> enrollmentData) {
        try {
            Long studentId = enrollmentData.get("studentId");
            Long courseId = enrollmentData.get("courseId");

            if (studentId == null || courseId == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("studentId and courseId are required").build();
            }

            enrollmentService.enrollStudentInCourse(studentId, courseId);

            Map<String, String> response = new HashMap<>();
            response.put("message", "Student enrolled successfully");
            return Response.status(Response.Status.CREATED).entity(response).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(e.getMessage()).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error enrolling student: " + e.getMessage()).build();
        }
    }
}
