package com.codingplatform.model;

import java.time.LocalDateTime;

public class Module {
    private int moduleId;
    private int courseId;
    private String moduleName;
    private String description;
    private int moduleOrder;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Module() {}

    public Module(int moduleId, int courseId, String moduleName, String description, int moduleOrder, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.moduleId = moduleId;
        this.courseId = courseId;
        this.moduleName = moduleName;
        this.description = description;
        this.moduleOrder = moduleOrder;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getModuleId() { return moduleId; }
    public void setModuleId(int moduleId) { this.moduleId = moduleId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getModuleName() { return moduleName; }
    public void setModuleName(String moduleName) { this.moduleName = moduleName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getModuleOrder() { return moduleOrder; }
    public void setModuleOrder(int moduleOrder) { this.moduleOrder = moduleOrder; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Module{" + "moduleId=" + moduleId + ", moduleName='" + moduleName + '\'' + ", moduleOrder=" + moduleOrder + '}';
    }
}
