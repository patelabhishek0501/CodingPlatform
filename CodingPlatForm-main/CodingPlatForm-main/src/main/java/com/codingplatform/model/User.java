package com.codingplatform.model;


import java.time.LocalDateTime; // For registration_date

/**
 * Represents a user from the 'users' table in 'dsa_db'.
 * This is a Plain Old Java Object (POJO) that holds user data.
 */
public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash; // Stores the BCrypt hashed password
    private LocalDateTime registrationDate; // Use LocalDateTime for TIMESTAMP

    // --- Constructors ---
    public User() {
    }

    public User(int userId, String username, String email, String passwordHash, LocalDateTime registrationDate) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.registrationDate = registrationDate;
    }

    // Constructor without userId (for new users before DB insert)
    public User(String username, String email, String passwordHash) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        // registrationDate will be set by DB default or during DAO save
    }

    // --- Getters and Setters ---
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public LocalDateTime getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(LocalDateTime registrationDate) {
        this.registrationDate = registrationDate;
    }

    @Override
    public String toString() {
        return "User{" +
               "userId=" + userId +
               ", username='" + username + '\'' +
               ", email='" + email + '\'' +
               ", passwordHash='[PROTECTED]'" + // Don't print hash for security
               ", registrationDate=" + registrationDate +
               '}';
    }
}
