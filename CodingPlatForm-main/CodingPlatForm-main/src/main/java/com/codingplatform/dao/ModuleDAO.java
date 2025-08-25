package com.codingplatform.dao;

import com.codingplatform.model.Module;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ModuleDAO {
    private static final Logger LOGGER = Logger.getLogger(ModuleDAO.class.getName());

    public List<Module> getModulesByCourseId(int courseId) {
        List<Module> modules = new ArrayList<>();
        String sql = "SELECT module_id, course_id, module_name, description, module_order, created_at, updated_at FROM modules WHERE course_id = ? ORDER BY module_order";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Module module = new Module();
                    module.setModuleId(rs.getInt("module_id"));
                    module.setCourseId(rs.getInt("course_id"));
                    module.setModuleName(rs.getString("module_name"));
                    module.setDescription(rs.getString("description"));
                    module.setModuleOrder(rs.getInt("module_order"));
                    module.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    module.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    modules.add(module);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting modules for course ID " + courseId + ": " + e.getMessage(), e);
        }
        return modules;
    }

    public Module getModuleById(int moduleId) {
        String sql = "SELECT module_id, course_id, module_name, description, module_order, created_at, updated_at FROM modules WHERE module_id = ?";
        Module module = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    module = new Module();
                    module.setModuleId(rs.getInt("module_id"));
                    module.setCourseId(rs.getInt("course_id"));
                    module.setModuleName(rs.getString("module_name"));
                    module.setDescription(rs.getString("description"));
                    module.setModuleOrder(rs.getInt("module_order"));
                    module.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    module.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting module by ID " + moduleId + ": " + e.getMessage(), e);
        }
        return module;
    }
}