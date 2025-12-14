package com.jakartaproject.rest;

import com.jakartaproject.entity.Student;
import com.jakartaproject.service.StudentService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/students")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class StudentResource {

    @Inject
    private StudentService studentService;

    @GET
    public Response getAllStudents() {
        try {
            List<Student> students = studentService.findAll();
            return Response.ok(students).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving students: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/{id}")
    public Response getStudentById(@PathParam("id") Long id) {
        try {
            Student student = studentService.findById(id);
            if (student != null) {
                return Response.ok(student).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("Student not found with id: " + id).build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving student: " + e.getMessage()).build();
        }
    }

    @POST
    public Response createStudent(Student student) {
        try {
            studentService.create(student);
            return Response.status(Response.Status.CREATED).entity(student).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error creating student: " + e.getMessage()).build();
        }
    }
}
