package com.jakartaproject.service;

import com.jakartaproject.entity.Enrollment;
import com.jakartaproject.entity.Student;
import com.jakartaproject.entity.Course;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@ApplicationScoped
@Transactional
public class EnrollmentService {

    @PersistenceContext(unitName = "smisPU")
    private EntityManager em;

    public Enrollment findById(Long id) {
        return em.find(Enrollment.class, id);
    }

    public List<Enrollment> findAll() {
        TypedQuery<Enrollment> query = em.createNamedQuery("Enrollment.findAll", Enrollment.class);
        return query.getResultList();
    }

    public List<Enrollment> findByStudent(Long studentId) {
        TypedQuery<Enrollment> query = em.createNamedQuery("Enrollment.findByStudent", Enrollment.class);
        query.setParameter("studentId", studentId);
        return query.getResultList();
    }

    public List<Enrollment> findByCourse(Long courseId) {
        TypedQuery<Enrollment> query = em.createNamedQuery("Enrollment.findByCourse", Enrollment.class);
        query.setParameter("courseId", courseId);
        return query.getResultList();
    }

    public Enrollment findByStudentAndCourse(Long studentId, Long courseId) {
        TypedQuery<Enrollment> query = em.createNamedQuery("Enrollment.findByStudentAndCourse", Enrollment.class);
        query.setParameter("studentId", studentId);
        query.setParameter("courseId", courseId);
        List<Enrollment> enrollments = query.getResultList();
        return enrollments.isEmpty() ? null : enrollments.get(0);
    }

    public void enrollStudentInCourse(Long studentId, Long courseId) {
        Student student = em.find(Student.class, studentId);
        Course course = em.find(Course.class, courseId);

        if (student == null || course == null) {
            throw new IllegalArgumentException("Student or Course not found");
        }

        // Check if student is already enrolled
        Enrollment existing = findByStudentAndCourse(studentId, courseId);
        if (existing != null) {
            throw new IllegalArgumentException("Student is already enrolled in this course");
        }

        // Check if course is full
        if (course.isFull()) {
            throw new IllegalArgumentException("Course is full");
        }

        Enrollment enrollment = new Enrollment(student, course, LocalDate.now());
        em.persist(enrollment);
    }

    public void unenrollStudentFromCourse(Long studentId, Long courseId) {
        Enrollment enrollment = findByStudentAndCourse(studentId, courseId);
        if (enrollment != null) {
            em.remove(enrollment);
        }
    }

    public void updateGrade(Long enrollmentId, BigDecimal grade) {
        Enrollment enrollment = em.find(Enrollment.class, enrollmentId);
        if (enrollment != null) {
            enrollment.setGrade(grade);
            em.merge(enrollment);
        }
    }

    public long count() {
        return em.createQuery("SELECT COUNT(e) FROM Enrollment e", Long.class).getSingleResult();
    }

}
