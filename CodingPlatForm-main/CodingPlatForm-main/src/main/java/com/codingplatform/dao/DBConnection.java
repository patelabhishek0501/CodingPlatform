package com.codingplatform.dao;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    // --- Database Connection Parameters ---
    // IMPORTANT: Update these with your MySQL server details
    // Changed database name to 'dsa_db' as per your new schema
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/dsa_db?useSSL=false&serverTimezone=UTC";
    private static final String JDBC_USER = "root"; // Your MySQL username
    private static final String JDBC_PASSWORD = "0000"; // Your MySQL password

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    public static Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            LOGGER.info("Successfully connected to the database: dsa_db!");

        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found!", e);
            throw new SQLException("Database driver not found: " + e.getMessage(), e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to connect to the database: " + e.getMessage(), e);
            throw e;
        }
        return connection;
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                LOGGER.info("Database connection closed.");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing database connection: " + e.getMessage(), e);
            }
        }
    }
}