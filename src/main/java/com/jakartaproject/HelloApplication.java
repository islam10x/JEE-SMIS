package com.jakartaproject;

import com.jakartaproject.rest.StudentResource;
import com.jakartaproject.rest.CourseResource;
import com.jakartaproject.rest.EnrollmentResource;
import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import java.util.HashSet;
import java.util.Set;

@ApplicationPath("/api")
public class HelloApplication extends Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<>();
        classes.add(StudentResource.class);
        classes.add(CourseResource.class);
        classes.add(EnrollmentResource.class);
        return classes;
    }
}