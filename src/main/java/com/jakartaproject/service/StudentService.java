package com.jakartaproject.service;

import com.jakartaproject.entity.Student;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;

import java.util.List;

@ApplicationScoped
@Transactional
public class StudentService {

    @PersistenceContext(unitName = "smisPU")
    private EntityManager em;

    public Student findById(Long id) {
        return em.find(Student.class, id);
    }

    public List<Student> findAll() {
        TypedQuery<Student> query = em.createNamedQuery("Student.findAll", Student.class);
        return query.getResultList();
    }

    public Student findByEmail(String email) {
        TypedQuery<Student> query = em.createNamedQuery("Student.findByEmail", Student.class);
        query.setParameter("email", email);
        List<Student> students = query.getResultList();
        return students.isEmpty() ? null : students.get(0);
    }

    public void create(Student student) {
        em.persist(student);
    }

    public void update(Student student) {
        em.merge(student);
    }

    public void delete(Long id) {
        Student student = em.find(Student.class, id);
        if (student != null) {
            em.remove(student);
        }
    }

    public long count() {
        return em.createQuery("SELECT COUNT(s) FROM Student s", Long.class).getSingleResult();
    }

}
