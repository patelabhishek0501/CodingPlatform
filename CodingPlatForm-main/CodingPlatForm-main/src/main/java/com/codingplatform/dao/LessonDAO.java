package com.codingplatform.dao;

import com.codingplatform.model.Lesson;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LessonDAO {
    private static final Logger LOGGER = Logger.getLogger(LessonDAO.class.getName());

    public List<Lesson> getLessonsByModuleId(int moduleId) {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT lesson_id, module_id, lesson_name, description, video_url, pdf_url, lesson_order, is_premium_content, created_at, updated_at FROM lessons WHERE module_id = ? ORDER BY lesson_order";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setLessonId(rs.getInt("lesson_id"));
                    lesson.setModuleId(rs.getInt("module_id"));
                    lesson.setLessonName(rs.getString("lesson_name"));
                    lesson.setDescription(rs.getString("description"));
                    lesson.setVideoUrl(rs.getString("video_url"));
                    lesson.setPdfUrl(rs.getString("pdf_url"));
                    lesson.setLessonOrder(rs.getInt("lesson_order"));
                    lesson.setPremiumContent(rs.getBoolean("is_premium_content"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    lesson.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    lessons.add(lesson);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting lessons for module ID " + moduleId + ": " + e.getMessage(), e);
        }
        return lessons;
    }
}
