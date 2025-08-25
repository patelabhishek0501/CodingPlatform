package com.codingplatform.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserEnrollmentDAO {
    private static final Logger LOGGER = Logger.getLogger(UserEnrollmentDAO.class.getName());

    /**
     * Checks if a user is enrolled in a specific course.
     * @param userId The ID of the user.
     * @param courseId The ID of the course.
     * @return true if the user is actively enrolled, false otherwise.
     */
    public boolean isUserEnrolledInCourse(int userId, int courseId) {
        String sql = "SELECT COUNT(*) FROM user_enrollments WHERE user_id = ? AND course_id = ? AND is_active = TRUE";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking enrollment for user " + userId + " in course " + courseId + ": " + e.getMessage(), e);
        }
        return false;
    }
}
