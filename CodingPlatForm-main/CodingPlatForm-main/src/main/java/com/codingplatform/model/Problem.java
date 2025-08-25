package com.codingplatform.model;

public class Problem {
    private int id;
    private int day;
    private String series;
    private String title;
    private String resourceFreeLink;
    private String resourcePaidLink;
    private String difficulty;
    private String userStatus; // Not in DB directly, set by DAO based on user_problems table

    // private boolean isRevisionForUser; // REMOVE THIS FIELD

    // --- Constructors (no change needed in params, as it was view-only) ---
    public Problem() { }

    public Problem(int id, int day, String series, String title, String resourceFreeLink, String resourcePaidLink, String difficulty) {
        this.id = id;
        this.day = day;
        this.series = series;
        this.title = title;
        this.resourceFreeLink = resourceFreeLink;
        this.resourcePaidLink = resourcePaidLink;
        this.difficulty = difficulty;
    }

    // --- Getters and Setters (only remove revision specific ones) ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDay() { return day; }
    public void setDay(int day) { this.day = day; }

    public String getSeries() { return series; }
    public void setSeries(String series) { this.series = series; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getResourceFreeLink() { return resourceFreeLink; }
    public void setResourceFreeLink(String resourceFreeLink) { this.resourceFreeLink = resourceFreeLink; }

    public String getResourcePaidLink() { return resourcePaidLink; }
    public void setResourcePaidLink(String resourcePaidLink) { this.resourcePaidLink = resourcePaidLink; }

    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

    public String getUserStatus() { return userStatus; }
    public void setUserStatus(String userStatus) { this.userStatus = userStatus; }

    // REMOVE THESE METHODS:
    // public boolean isRevisionForUser() { return isRevisionForUser; }
    // public void setRevisionForUser(boolean revisionForUser) { isRevisionForUser = revisionForUser; }

    @Override
    public String toString() {
        return "Problem{" +
               "id=" + id +
               ", day=" + day +
               ", series='" + series + '\'' +
               ", title='" + title + '\'' +
               ", resourceFreeLink='" + resourceFreeLink + '\'' +
               ", resourcePaidLink='" + resourcePaidLink + '\'' +
               ", difficulty='" + difficulty + '\'' +
               ", userStatus='" + userStatus + '\'' +
               // ", isRevisionForUser=" + isRevisionForUser + // REMOVE THIS LINE
               '}';
    }
}
