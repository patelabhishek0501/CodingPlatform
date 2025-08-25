package com.codingplatform.dao;

import com.codingplatform.model.UserProgress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object (DAO) for the 'user_progress' table.
 * Handles operations to save, update, and retrieve user-specific problem progress.
 * Now without 'is_revision' status.
 */
public class UserProgressDAO {

    private static final Logger LOGGER = Logger.getLogger(UserProgressDAO.class.getName());

    /**
     * Retrieves the progress of a specific user on a specific problem.
     *
     * @param userId    The ID of the user.
     * @param problemId The ID of the problem.
     * @return The UserProgress object if found, otherwise null.
     */
    public UserProgress getUserProgress(int userId, int problemId) {
        // Removed is_revision from SELECT statement
        String sql = "SELECT user_progress_id, user_id, problem_id, status, last_updated FROM user_progress WHERE user_id = ? AND problem_id = ?";
        UserProgress userProgress = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, problemId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    userProgress = new UserProgress();
                    userProgress.setUserProgressId(resultSet.getInt("user_progress_id"));
                    userProgress.setUserId(resultSet.getInt("user_id"));
                    userProgress.setProblemId(resultSet.getInt("problem_id"));
                    userProgress.setStatus(resultSet.getString("status"));
                    // userProgress.setRevision(resultSet.getBoolean("is_revision")); // REMOVED THIS LINE
                    Timestamp ts = resultSet.getTimestamp("last_updated");
                    if (ts != null) {
                        userProgress.setLastUpdated(ts.toLocalDateTime());
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user progress for user " + userId + " and problem " + problemId + ": " + e.getMessage(), e);
        }
        return userProgress;
    }

    /**
     * Saves new user progress or updates existing user progress for a problem.
     * This method now handles only status.
     *
     * @param userProgress The UserProgress object containing user_id, problem_id, and status.
     * @return true if the operation was successful, false otherwise.
     */
    public boolean saveOrUpdateUserProgress(UserProgress userProgress) {
        // First, check if an entry already exists for this user and problem
        UserProgress existingProgress = getUserProgress(userProgress.getUserId(), userProgress.getProblemId());

        if (existingProgress == null) {
            // If no existing entry, insert new progress
            return insertUserProgress(userProgress);
        } else {
            // If entry exists, update its status
            userProgress.setUserProgressId(existingProgress.getUserProgressId()); // Ensure we update the correct row
            return updateUserProgress(userProgress);
        }
    }

    /**
     * Inserts a new user progress record.
     * @param userProgress The UserProgress object to insert.
     * @return true if successful, false otherwise.
     */
    private boolean insertUserProgress(UserProgress userProgress) {
        // Removed is_revision from INSERT statement
        String sql = "INSERT INTO user_progress (user_id, problem_id, status) VALUES (?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setInt(1, userProgress.getUserId());
            preparedStatement.setInt(2, userProgress.getProblemId());
            preparedStatement.setString(3, userProgress.getStatus());
            // preparedStatement.setBoolean(4, userProgress.isRevision()); // REMOVED THIS LINE

            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        userProgress.setUserProgressId(generatedKeys.getInt(1));
                    }
                }
                LOGGER.info("Inserted new progress for user " + userProgress.getUserId() + ", problem " + userProgress.getProblemId() + " with status: " + userProgress.getStatus());
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting user progress for user " + userProgress.getUserId() + ", problem " + userProgress.getProblemId() + ": " + e.getMessage(), e);
        }
        return false;
    }

    /**
     * Updates the status of an existing user progress record.
     * @param userProgress The UserProgress object to update (must have userProgressId set).
     * @return true if successful, false otherwise.
     */
    private boolean updateUserProgress(UserProgress userProgress) {
        // Removed is_revision from UPDATE statement
        String sql = "UPDATE user_progress SET status = ?, last_updated = CURRENT_TIMESTAMP WHERE user_progress_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, userProgress.getStatus());
            // preparedStatement.setBoolean(2, userProgress.isRevision()); // REMOVED THIS LINE
            preparedStatement.setInt(2, userProgress.getUserProgressId()); // Index shifts from 3 to 2

            int rowsAffected = preparedStatement.executeUpdate();
            LOGGER.info("Updated progress for user " + userProgress.getUserId() + ", problem " + userProgress.getProblemId() + " to status: " + userProgress.getStatus() + ". Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user progress status for ID " + userProgress.getUserProgressId() + ": " + e.getMessage(), e);
        }
        return false;
    }

    /**
     * Retrieves all user progress records for a given user,
     * returned as a Map where key is problem_id and value is UserProgress object.
     *
     * @param userId The ID of the user.
     * @return A Map of problemId to UserProgress objects. Empty map if no progress or error.
     */
    public Map<Integer, UserProgress> getAllUserProgress(int userId) {
        Map<Integer, UserProgress> userProgressMap = new HashMap<>();
        // Removed is_revision from SELECT statement
        String sql = "SELECT user_progress_id, user_id, problem_id, status, last_updated FROM user_progress WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, userId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    UserProgress userProgress = new UserProgress();
                    userProgress.setUserProgressId(resultSet.getInt("user_progress_id"));
                    userProgress.setUserId(resultSet.getInt("user_id"));
                    userProgress.setProblemId(resultSet.getInt("problem_id"));
                    userProgress.setStatus(resultSet.getString("status"));
                    // userProgress.setRevision(resultSet.getBoolean("is_revision")); // REMOVED THIS LINE
                    Timestamp ts = resultSet.getTimestamp("last_updated");
                    if (ts != null) {
                        userProgress.setLastUpdated(ts.toLocalDateTime());
                    }
                    userProgressMap.put(userProgress.getProblemId(), userProgress);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all user progress for user " + userId + ": " + e.getMessage(), e);
        }
        return userProgressMap;
    }
}
