package com.codingplatform.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Course {
    private int courseId;
    private String courseName;
    private String description;
    private BigDecimal price;
    private boolean isPublished;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Course() {}

    public Course(int courseId, String courseName, String description, BigDecimal price, boolean isPublished, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.description = description;
        this.price = price;
        this.isPublished = isPublished;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public boolean isPublished() { return isPublished; }
    public void setPublished(boolean published) { isPublished = published; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Course{" + "courseId=" + courseId + ", courseName='" + courseName + '\'' + ", price=" + price + '}';
    }
}
