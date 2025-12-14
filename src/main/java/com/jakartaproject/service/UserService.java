package com.jakartaproject.service;

import com.jakartaproject.entity.User;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@ApplicationScoped
@Transactional
public class UserService {

    @PersistenceContext(unitName = "smisPU")
    private EntityManager em;

    public User authenticate(String username, String password) {
        TypedQuery<User> query = em.createNamedQuery("User.findByUsername", User.class);
        query.setParameter("username", username);

        List<User> users = query.getResultList();
        if (!users.isEmpty()) {
            User user = users.get(0);
            // In a real application, you would hash the password
            // For demo purposes, we're doing simple string comparison
            if (password.equals(user.getPassword())) {
                return user;
            }
        }
        return null;
    }

    public User findById(Long id) {
        return em.find(User.class, id);
    }

    public User findByUsername(String username) {
        TypedQuery<User> query = em.createNamedQuery("User.findByUsername", User.class);
        query.setParameter("username", username);
        List<User> users = query.getResultList();
        return users.isEmpty() ? null : users.get(0);
    }

    public void updateLastLogin(Long userId) {
        User user = em.find(User.class, userId);
        if (user != null) {
            user.setLastLogin(LocalDateTime.now());
            em.merge(user);
        }
    }

    public void createUser(User user) {
        em.persist(user);
    }

    public List<User> findAll() {
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u ORDER BY u.username", User.class);
        return query.getResultList();
    }

}
