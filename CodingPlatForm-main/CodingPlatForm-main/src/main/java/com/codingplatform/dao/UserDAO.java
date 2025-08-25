package com.codingplatform.dao;


import org.mindrot.jbcrypt.BCrypt; // Import BCrypt for password hashing

import com.codingplatform.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp; // For converting LocalDateTime to Timestamp
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object (DAO) for the 'users' table.
 * Handles user registration, login authentication, and retrieval.
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    /**
     * Registers a new user in the database.
     * The password provided in the User object should be plain text; it will be hashed.
     *
     * @param user The User object containing username, email, and plain text password.
     * @return The User object with the generated userId from the database, or null if registration fails.
     */
    public User registerUser(User user) {
        // SQL query to insert a new user. registration_date has a default in DB.
        String sql = "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)";
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet generatedKeys = null;

        try {
            connection = DBConnection.getConnection();
            // Use Statement.RETURN_GENERATED_KEYS to get the auto-incremented user_id
            preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            // Hash the plain text password before storing it
            String hashedPassword = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());

            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, hashedPassword);

            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                // Retrieve the auto-generated user_id
                generatedKeys = preparedStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    user.setUserId(generatedKeys.getInt(1)); // Set the generated ID back to the user object
                    // Set registration date from DB if needed, or rely on DB default
                    LOGGER.info("User registered successfully: " + user.getUsername());
                    return user; // Return the user object with the new ID
                }
            }
        } catch (SQLException e) {
            // Check for duplicate entry errors (e.g., username or email already exists)
            if (e.getSQLState().startsWith("23")) { // SQLState for integrity constraint violation
                LOGGER.log(Level.WARNING, "Registration failed: Duplicate username or email for user: " + user.getUsername(), e);
            } else {
                LOGGER.log(Level.SEVERE, "Error registering user: " + user.getUsername(), e);
            }
        } finally {
            // Ensure all resources are closed
            DBConnection.closeConnection(connection);
            try { if (preparedStatement != null) preparedStatement.close(); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Error closing PreparedStatement", e); }
            try { if (generatedKeys != null) generatedKeys.close(); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Error closing ResultSet", e); }
        }
        return null; // Registration failed
    }

    /**
     * Authenticates a user based on their username/email and plain text password.
     *
     * @param identifier The username or email of the user trying to log in.
     * @param plainPassword The plain text password provided by the user.
     * @return The authenticated User object if credentials are valid, otherwise null.
     */
    public User authenticateUser(String identifier, String plainPassword) {
        User user = getUserByUsernameOrEmail(identifier); // Find user first
        if (user != null) {
            // Verify the provided plain password against the stored hashed password
            if (BCrypt.checkpw(plainPassword, user.getPasswordHash())) {
                LOGGER.info("User authenticated successfully: " + user.getUsername());
                return user; // Authentication successful
            } else {
                LOGGER.info("Authentication failed for user '" + identifier + "': Incorrect password.");
            }
        } else {
            LOGGER.info("Authentication failed: User '" + identifier + "' not found.");
        }
        return null; // Authentication failed
    }

    /**
     * Retrieves a user by their username or email.
     * @param identifier The username or email to search for.
     * @return The User object if found, otherwise null.
     */
    public User getUserByUsernameOrEmail(String identifier) {
        String sql = "SELECT user_id, username, email, password_hash, registration_date FROM users WHERE username = ? OR email = ?";
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        User user = null;

        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, identifier);
            preparedStatement.setString(2, identifier);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                user = new User();
                user.setUserId(resultSet.getInt("user_id"));
                user.setUsername(resultSet.getString("username"));
                user.setEmail(resultSet.getString("email"));
                user.setPasswordHash(resultSet.getString("password_hash")); // This is the HASH, not plain text
                // Convert SQL Timestamp to Java 8 LocalDateTime
                Timestamp ts = resultSet.getTimestamp("registration_date");
                if (ts != null) {
                    user.setRegistrationDate(ts.toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user by identifier: " + identifier, e);
        } finally {
            DBConnection.closeConnection(connection);
            try { if (preparedStatement != null) preparedStatement.close(); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Error closing PreparedStatement", e); }
            try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Error closing ResultSet", e); }
        }
        return user;
    }
}