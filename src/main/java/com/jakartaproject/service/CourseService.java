package com.jakartaproject.service;

import com.jakartaproject.entity.Course;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;

import java.util.List;

@ApplicationScoped
@Transactional
public class CourseService {

    @PersistenceContext(unitName = "smisPU")
    private EntityManager em;

    public Course findById(Long id) {
        return em.find(Course.class, id);
    }

    public List<Course> findAll() {
        TypedQuery<Course> query = em.createNamedQuery("Course.findAll", Course.class);
        return query.getResultList();
    }

    public List<Course> findByInstructor(String instructor) {
        TypedQuery<Course> query = em.createNamedQuery("Course.findByInstructor", Course.class);
        query.setParameter("instructor", instructor);
        return query.getResultList();
    }

    public void create(Course course) {
        em.persist(course);
    }

    public void update(Course course) {
        em.merge(course);
    }

    public void delete(Long id) {
        Course course = em.find(Course.class, id);
        if (course != null) {
            em.remove(course);
        }
    }

    public boolean isCourseFull(Long courseId) {
        Course course = findById(courseId);
        return course != null && course.isFull();
    }

    public long count() {
        return em.createQuery("SELECT COUNT(c) FROM Course c", Long.class).getSingleResult();
    }
}
