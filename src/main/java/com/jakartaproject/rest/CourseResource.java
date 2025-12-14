package com.jakartaproject.rest;

import com.jakartaproject.entity.Course;
import com.jakartaproject.service.CourseService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/courses")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CourseResource {

    @Inject
    private CourseService courseService;

    @GET
    public Response getAllCourses() {
        try {
            List<Course> courses = courseService.findAll();
            return Response.ok(courses).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving courses: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/{id}")
    public Response getCourseById(@PathParam("id") Long id) {
        try {
            Course course = courseService.findById(id);
            if (course != null) {
                return Response.ok(course).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("Course not found with id: " + id).build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving course: " + e.getMessage()).build();
        }
    }

    @POST
    public Response createCourse(Course course) {
        try {
            courseService.create(course);
            return Response.status(Response.Status.CREATED).entity(course).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error creating course: " + e.getMessage()).build();
        }
    }
}
