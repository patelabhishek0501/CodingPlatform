package com.codingplatform.dao;

import com.codingplatform.model.Problem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object (DAO) for the 'problems' table.
 * Handles database operations related to Problem objects.
 * No longer handles 'is_solved' status directly.
 */
public class ProblemDAO {

    private static final Logger LOGGER = Logger.getLogger(ProblemDAO.class.getName());

    /**
     * Retrieves all problems from the 'problems' table.
     * Note: 'is_solved' column is no longer part of 'problems' table directly.
     *
     * @return A List of Problem objects. Returns an empty list if no problems are found or on error.
     */
    public List<Problem> getAllProblems() {
        List<Problem> problems = new ArrayList<>();
        // Select all relevant columns from the problems table
        String sql = "SELECT id, day, series, title, resource_free_link, resource_paid_link, difficulty FROM problems ORDER BY day, id";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                Problem problem = new Problem();
                problem.setId(resultSet.getInt("id"));
                problem.setDay(resultSet.getInt("day")); // CORRECTED: Get INT from "day" column
                problem.setSeries(resultSet.getString("series")); // CORRECTED: Get STRING from "series" column
                problem.setTitle(resultSet.getString("title"));
                problem.setResourceFreeLink(resultSet.getString("resource_free_link"));
                problem.setResourcePaidLink(resultSet.getString("resource_paid_link"));
                problem.setDifficulty(resultSet.getString("difficulty"));

                problems.add(problem);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all problems from the database: " + e.getMessage(), e);
        }
        return problems;
    }

    /**
     * REMOVED: public boolean updateProblemSolvedStatus(...)
     * This functionality will be moved to UserProgressDAO.
     */
}
