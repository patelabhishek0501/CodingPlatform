package com.codingplatform.dao;

import com.codingplatform.model.Course;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CourseDAO {
    private static final Logger LOGGER = Logger.getLogger(CourseDAO.class.getName());

    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT course_id, course_name, description, price, is_published, created_at, updated_at FROM courses WHERE is_published = TRUE ORDER BY course_name";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setDescription(rs.getString("description"));
                course.setPrice(rs.getBigDecimal("price"));
                course.setPublished(rs.getBoolean("is_published"));
                course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                course.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                courses.add(course);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all courses: " + e.getMessage(), e);
        }
        return courses;
    }

    public Course getCourseById(int courseId) {
        String sql = "SELECT course_id, course_name, description, price, is_published, created_at, updated_at FROM courses WHERE course_id = ?";
        Course course = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    course = new Course();
                    course.setCourseId(rs.getInt("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setDescription(rs.getString("description"));
                    course.setPrice(rs.getBigDecimal("price"));
                    course.setPublished(rs.getBoolean("is_published"));
                    course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    course.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting course by ID " + courseId + ": " + e.getMessage(), e);
        }
        return course;
    }

    public Course getCourseByName(String courseName) {
        String sql = "SELECT course_id, course_name, description, price, is_published, created_at, updated_at FROM courses WHERE course_name = ?";
        Course course = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, courseName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    course = new Course();
                    course.setCourseId(rs.getInt("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setDescription(rs.getString("description"));
                    course.setPrice(rs.getBigDecimal("price"));
                    course.setPublished(rs.getBoolean("is_published"));
                    course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    course.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting course by name " + courseName + ": " + e.getMessage(), e);
        }
        return course;
    }
}
