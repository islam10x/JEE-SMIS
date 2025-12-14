package com.jakartaproject.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "enrollments", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"student_id", "course_id"})
})
@NamedQueries({
    @NamedQuery(name = "Enrollment.findAll", query = "SELECT e FROM Enrollment e ORDER BY e.enrollmentDate DESC"),
    @NamedQuery(name = "Enrollment.findByStudent", query = "SELECT e FROM Enrollment e WHERE e.student.id = :studentId"),
    @NamedQuery(name = "Enrollment.findByCourse", query = "SELECT e FROM Enrollment e WHERE e.course.id = :courseId"),
    @NamedQuery(name = "Enrollment.findByStudentAndCourse", query = "SELECT e FROM Enrollment e WHERE e.student.id = :studentId AND e.course.id = :courseId")
})
public class Enrollment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "Student is required")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @NotNull(message = "Course is required")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @DecimalMin(value = "0.0", message = "Grade cannot be negative")
    @DecimalMax(value = "4.0", message = "Grade cannot be more than 4.0")
    @Column(precision = 3, scale = 2, columnDefinition = "DECIMAL(3,2)")
    private BigDecimal grade;

    @NotNull(message = "Enrollment date is required")
    @Column(name = "enrollment_date", nullable = false)
    private LocalDate enrollmentDate;

    // Constructors
    public Enrollment() {}

    public Enrollment(Student student, Course course, LocalDate enrollmentDate) {
        this.student = student;
        this.course = course;
        this.enrollmentDate = enrollmentDate;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public BigDecimal getGrade() {
        return grade;
    }

    public void setGrade(BigDecimal grade) {
        this.grade = grade;
    }

    public LocalDate getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(LocalDate enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }

    // Helper methods
    public String getGradeLetter() {
        if (grade == null) return "Not Graded";

        double gradeValue = grade.doubleValue();
        if (gradeValue >= 4.0) return "A+";
        if (gradeValue >= 3.7) return "A";
        if (gradeValue >= 3.3) return "A-";
        if (gradeValue >= 3.0) return "B+";
        if (gradeValue >= 2.7) return "B";
        if (gradeValue >= 2.3) return "B-";
        if (gradeValue >= 2.0) return "C+";
        if (gradeValue >= 1.7) return "C";
        if (gradeValue >= 1.3) return "C-";
        if (gradeValue >= 1.0) return "D";
        return "F";
    }

    public boolean isPassed() {
        return grade != null && grade.compareTo(BigDecimal.valueOf(1.0)) >= 0;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Enrollment)) return false;
        Enrollment that = (Enrollment) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }

    @Override
    public String toString() {
        return "Enrollment{" +
                "id=" + id +
                ", student=" + (student != null ? student.getName() : null) +
                ", course=" + (course != null ? course.getName() : null) +
                ", grade=" + grade +
                ", enrollmentDate=" + enrollmentDate +
                '}';
    }
}
