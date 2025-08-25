package com.codingplatform.model;

import java.time.LocalDateTime;

public class UserEnrollment {
    private int enrollmentId;
    private int userId;
    private int courseId;
    private LocalDateTime enrollmentDate;
    private boolean isActive;

    public UserEnrollment() {}

    public UserEnrollment(int enrollmentId, int userId, int courseId, LocalDateTime enrollmentDate, boolean isActive) {
        this.enrollmentId = enrollmentId;
        this.userId = userId;
        this.courseId = courseId;
        this.enrollmentDate = enrollmentDate;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getEnrollmentId() { return enrollmentId; }
    public void setEnrollmentId(int enrollmentId) { this.enrollmentId = enrollmentId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public LocalDateTime getEnrollmentDate() { return enrollmentDate; }
    public void setEnrollmentDate(LocalDateTime enrollmentDate) { this.enrollmentDate = enrollmentDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    @Override
    public String toString() {
        return "UserEnrollment{" + "enrollmentId=" + enrollmentId + ", userId=" + userId + ", courseId=" + courseId + '}';
    }
}
