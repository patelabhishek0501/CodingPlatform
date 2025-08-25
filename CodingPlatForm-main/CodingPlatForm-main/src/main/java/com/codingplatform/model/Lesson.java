package com.codingplatform.model;

import java.time.LocalDateTime;

public class Lesson {
    private int lessonId;
    private int moduleId;
    private String lessonName;
    private String description;
    private String videoUrl; // Original URL from DB
    private String pdfUrl;   // Original URL from DB
    private int lessonOrder;
    private boolean isPremiumContent;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // NEW FIELDS: These are for VIEW PURPOSES ONLY. Not persisted in DB.
    private String embedVideoUrl; // Optimized URL for iframe embedding
    private String embedPdfUrl;   // Optimized URL for iframe embedding

    public Lesson() {}

    public Lesson(int lessonId, int moduleId, String lessonName, String description, String videoUrl, String pdfUrl, int lessonOrder, boolean isPremiumContent, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.lessonId = lessonId;
        this.moduleId = moduleId;
        this.lessonName = lessonName;
        this.description = description;
        this.videoUrl = videoUrl;
        this.pdfUrl = pdfUrl;
        this.lessonOrder = lessonOrder;
        this.isPremiumContent = isPremiumContent;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters (existing ones unchanged)
    public int getLessonId() { return lessonId; }
    public void setLessonId(int lessonId) { this.lessonId = lessonId; }

    public int getModuleId() { return moduleId; }
    public void setModuleId(int moduleId) { this.moduleId = moduleId; }

    public String getLessonName() { return lessonName; }
    public void setLessonName(String lessonName) { this.lessonName = lessonName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getVideoUrl() { return videoUrl; }
    public void setVideoUrl(String videoUrl) { this.videoUrl = videoUrl; }

    public String getPdfUrl() { return pdfUrl; }
    public void setPdfUrl(String pdfUrl) { this.pdfUrl = pdfUrl; }

    public int getLessonOrder() { return lessonOrder; }
    public void setLessonOrder(int lessonOrder) { this.lessonOrder = lessonOrder; }

    public boolean isPremiumContent() { return isPremiumContent; }
    public void setPremiumContent(boolean premiumContent) { isPremiumContent = premiumContent; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // NEW Getters and Setters for embeddable URLs
    public String getEmbedVideoUrl() { return embedVideoUrl; }
    public void setEmbedVideoUrl(String embedVideoUrl) { this.embedVideoUrl = embedVideoUrl; }

    public String getEmbedPdfUrl() { return embedPdfUrl; }
    public void setEmbedPdfUrl(String embedPdfUrl) { this.embedPdfUrl = embedPdfUrl; }

    @Override
    public String toString() {
        return "Lesson{" + "lessonId=" + lessonId + ", lessonName='" + lessonName + '\'' + ", lessonOrder=" + lessonOrder + '}';
    }
}
