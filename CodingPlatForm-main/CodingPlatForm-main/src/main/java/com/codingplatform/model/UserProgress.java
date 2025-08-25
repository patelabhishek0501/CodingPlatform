package com.codingplatform.model;

import java.time.LocalDateTime;

/**
 * Represents a user's progress on a specific problem from the 'user_progress' table.
 */
public class UserProgress {
    private int userProgressId;
    private int userId;
    private int problemId;
    private String status; // e.g., "Not Started", "In Progress", "Completed", "Skipped"
    // private boolean isRevision; // REMOVED THIS FIELD
    private LocalDateTime lastUpdated;

    // --- Constructors ---
    public UserProgress() {
    }

    // REMOVED 'isRevision' parameter from this constructor
    public UserProgress(int userProgressId, int userId, int problemId, String status, LocalDateTime lastUpdated) {
        this.userProgressId = userProgressId;
        this.userId = userId;
        this.problemId = problemId;
        this.status = status;
        this.lastUpdated = lastUpdated;
    }

    // REMOVED 'isRevision' parameter from this constructor
    public UserProgress(int userId, int problemId, String status) {
        this.userId = userId;
        this.problemId = problemId;
        this.status = status;
    }


    // --- Getters and Setters ---
    public int getUserProgressId() { return userProgressId; }
    public void setUserProgressId(int userProgressId) { this.userProgressId = userProgressId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProblemId() { return problemId; }
    public void setProblemId(int problemId) { this.problemId = problemId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // REMOVED THESE METHODS:
    // public boolean isRevision() { return isRevision; }
    // public void setRevision(boolean revision) { isRevision = revision; }

    public LocalDateTime getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(LocalDateTime lastUpdated) { this.lastUpdated = lastUpdated; }

    public boolean isCompleted() { return "Completed".equals(this.status); }

    @Override
    public String toString() {
        return "UserProgress{" +
               "userProgressId=" + userProgressId +
               ", userId=" + userId +
               ", problemId=" + problemId +
               ", status='" + status + '\'' +
               ", lastUpdated=" + lastUpdated +
               '}';
    }
}
