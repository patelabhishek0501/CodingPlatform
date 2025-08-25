package com.codingplatform.controller;

import com.codingplatform.dao.ProblemDAO;
import com.codingplatform.dao.UserProgressDAO;
import com.codingplatform.dao.CourseDAO;
import com.codingplatform.dao.ModuleDAO;
import com.codingplatform.dao.LessonDAO;
import com.codingplatform.dao.UserEnrollmentDAO;

import com.codingplatform.model.Problem;
import com.codingplatform.model.User;
import com.codingplatform.model.UserProgress;
import com.codingplatform.model.Course;
import com.codingplatform.model.Module;
import com.codingplatform.model.Lesson;
import com.codingplatform.model.UserEnrollment;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher; // NEW Import
import java.util.regex.Pattern;  // NEW Import
import java.util.stream.Collectors;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProblemDAO problemDAO;
    private UserProgressDAO userProgressDAO;
    private CourseDAO courseDAO;
    private ModuleDAO moduleDAO;
    private LessonDAO lessonDAO;
    private UserEnrollmentDAO userEnrollmentDAO;

    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());

    // Regex patterns for URL conversion
    private static final Pattern YOUTUBE_VIDEO_ID_PATTERN = Pattern.compile("(?<=watch\\?v=|/videos/|embed\\/|youtu.be\\/|\\/v\\/|\\/e\\/|watch\\?v%3D|watch\\?feature=player_embedded&v=|%2Fvideos%2F|embedBFF|youtu.be%2F|%2Fv%2F)[^#\\&\\?]*");
    private static final Pattern GOOGLE_DRIVE_FILE_ID_PATTERN = Pattern.compile("drive\\.google\\.com\\/file\\/d\\/([a-zA-Z0-9_-]+)(?:\\/view|\\/preview|\\/edit|\\?usp=sharing)?");


    public DashboardServlet() {
        super();
        this.problemDAO = new ProblemDAO();
        this.userProgressDAO = new UserProgressDAO();
        this.courseDAO = new CourseDAO();
        this.moduleDAO = new ModuleDAO();
        this.lessonDAO = new LessonDAO();
        this.userEnrollmentDAO = new UserEnrollmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedInUser = null;
        if (session != null) {
            loggedInUser = (User) session.getAttribute("loggedInUser");
        }

        if (loggedInUser == null) {
            LOGGER.warning("DashboardServlet accessed without loggedInUser in session. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String contentType = request.getParameter("contentType");
        if (contentType == null || contentType.trim().isEmpty()) {
            contentType = "problems";
        }
        request.setAttribute("contentType", contentType);

        String selectedSeries = request.getParameter("series");
        String courseName = request.getParameter("course");
        String moduleName = request.getParameter("module");

        if (selectedSeries == null || selectedSeries.trim().isEmpty()) {
            selectedSeries = "String Series";
        }
        request.setAttribute("selectedSeries", selectedSeries);


        try {
            List<String> allSeriesNames = Arrays.asList(
                "String Series", "Array Series", "Binary Search Series",
                "Linked List Series", "Recursion Series", "Stack and Queue Series",
                "Tree Series", "Graph Series", "DP Series", "All Series"
            );
            request.setAttribute("allSeriesNames", allSeriesNames);

            List<Course> allCourses = courseDAO.getAllCourses();
            request.setAttribute("allCourses", allCourses);


            if ("problems".equals(contentType)) {
                List<Problem> allProblems = problemDAO.getAllProblems();
                LOGGER.info("DashboardServlet: Retrieved " + allProblems.size() + " problems in total from ProblemDAO.");

                final String finalSelectedSeries = selectedSeries;
                List<Problem> filteredProblems;
                if ("All Series".equals(finalSelectedSeries)) {
                    filteredProblems = allProblems;
                } else {
                    filteredProblems = allProblems.stream()
                            .filter(p -> finalSelectedSeries.equals(p.getSeries()))
                            .collect(Collectors.toList());
                }
                LOGGER.info("DashboardServlet: Filtered down to " + filteredProblems.size() + " problems for series: " + finalSelectedSeries);


                Map<Integer, UserProgress> userProgressMap = userProgressDAO.getAllUserProgress(loggedInUser.getUserId());
                LOGGER.info("DashboardServlet: Retrieved " + userProgressMap.size() + " user progress entries for user ID: " + loggedInUser.getUserId());

                long totalSolved = 0;
                long easyProblems = 0, easySolved = 0;
                long mediumProblems = 0, mediumSolved = 0;
                long hardProblems = 0, hardSolved = 0;

                for (Problem problem : filteredProblems) {
                    UserProgress progress = userProgressMap.get(problem.getId());
                    if (progress != null) {
                        problem.setUserStatus(progress.getStatus());
                    } else {
                        problem.setUserStatus("Not Started");
                    }

                    if (problem.getUserStatus().equals("Completed")) {
                        totalSolved++;
                    }

                    switch (problem.getDifficulty()) {
                        case "Easy":
                            easyProblems++;
                            if (problem.getUserStatus().equals("Completed")) {
                                easySolved++;
                            }
                            break;
                        case "Medium":
                            mediumProblems++;
                            if (problem.getUserStatus().equals("Completed")) {
                                mediumSolved++;
                            }
                            break;
                        case "Hard":
                            hardProblems++;
                            if (problem.getUserStatus().equals("Completed")) {
                                hardSolved++;
                            }
                            break;
                    }
                }

                Map<String, Integer> difficultyOrder = new HashMap<>();
                difficultyOrder.put("Easy", 1);
                difficultyOrder.put("Medium", 2);
                difficultyOrder.put("Hard", 3);

                Map<String, List<Problem>> problemsByDifficulty = filteredProblems.stream()
                        .collect(Collectors.groupingBy(Problem::getDifficulty))
                        .entrySet().stream()
                        .sorted(Comparator.comparing(entry -> difficultyOrder.getOrDefault(entry.getKey(), 99)))
                        .collect(Collectors.toMap(
                                Map.Entry::getKey,
                                Map.Entry::getValue,
                                (oldValue, newValue) -> oldValue,
                                LinkedHashMap::new
                        ));

                request.setAttribute("problemsByDifficulty", problemsByDifficulty);
                request.setAttribute("allProblemsCount", (long) filteredProblems.size());
                request.setAttribute("totalSolved", totalSolved);
                request.setAttribute("totalProblems", (long) filteredProblems.size());
                request.setAttribute("easyProblems", easyProblems);
                request.setAttribute("easySolved", easySolved);
                request.setAttribute("mediumProblems", mediumProblems);
                request.setAttribute("mediumSolved", mediumSolved);
                request.setAttribute("hardProblems", hardProblems);
                request.setAttribute("hardSolved", hardSolved);

            } else if ("courses".equals(contentType)) {
                request.setAttribute("mainContentTitle", "Available Courses");
                List<Course> coursesList = courseDAO.getAllCourses();
                request.setAttribute("coursesList", coursesList);

            } else if ("modules".equals(contentType) && courseName != null && !courseName.trim().isEmpty()) {
                Course selectedCourse = courseDAO.getCourseByName(courseName);
                if (selectedCourse != null) {
                    request.setAttribute("selectedCourse", selectedCourse);
                    request.setAttribute("mainContentTitle", selectedCourse.getCourseName() + " Modules");

                    List<Module> modulesList = moduleDAO.getModulesByCourseId(selectedCourse.getCourseId());
                    request.setAttribute("modulesList", modulesList);

                    boolean isEnrolled = userEnrollmentDAO.isUserEnrolledInCourse(loggedInUser.getUserId(), selectedCourse.getCourseId());
                    request.setAttribute("isUserEnrolled", isEnrolled);

                    LOGGER.info("DashboardServlet: User " + loggedInUser.getUsername() + " is enrolled in " + selectedCourse.getCourseName() + ": " + isEnrolled);

                } else {
                    request.setAttribute("errorMessage", "Course not found: " + courseName);
                    contentType = "error";
                }

            } else if ("lessons".equals(contentType) && moduleName != null && !moduleName.trim().isEmpty()) {
                // Note: In a real app, you'd navigate by Module ID for uniqueness
                // For simplicity, we'll try to find module by name and then course
                Module selectedModule = null;
                // Fetch all modules to find by name - not efficient for large scale, but fine for small data
                List<Module> allModules = new ArrayList<>();
                for(Course course : allCourses) {
                    allModules.addAll(moduleDAO.getModulesByCourseId(course.getCourseId()));
                }

                for (Module module : allModules) {
                    if (moduleName.equals(module.getModuleName())) {
                        selectedModule = module;
                        break;
                    }
                }

                if (selectedModule != null) {
                    request.setAttribute("selectedModule", selectedModule);
                    request.setAttribute("mainContentTitle", selectedModule.getModuleName() + " Lessons");

                    Course parentCourse = courseDAO.getCourseById(selectedModule.getCourseId());
                    request.setAttribute("parentCourse", parentCourse);

                    List<Lesson> lessonsList = lessonDAO.getLessonsByModuleId(selectedModule.getModuleId());

                    boolean isEnrolledInCourse = false;
                    if (parentCourse != null) {
                        isEnrolledInCourse = userEnrollmentDAO.isUserEnrolledInCourse(loggedInUser.getUserId(), parentCourse.getCourseId());
                    }
                    request.setAttribute("isUserEnrolled", isEnrolledInCourse);

                    // --- NEW: Convert URLs to Embeddable Formats and apply Gating ---
                    for (Lesson lesson : lessonsList) {
                        // Convert video URL for embedding
                        if (lesson.getVideoUrl() != null && !lesson.getVideoUrl().isEmpty()) {
                            String embedUrl = convertVideoUrlToEmbed(lesson.getVideoUrl());
                            lesson.setEmbedVideoUrl(embedUrl);
                        }
                        // Convert PDF URL for embedding (Google Drive Preview)
                        if (lesson.getPdfUrl() != null && !lesson.getPdfUrl().isEmpty()) {
                            String embedUrl = convertPdfUrlToEmbed(lesson.getPdfUrl());
                            lesson.setEmbedPdfUrl(embedUrl);
                        }

                        // Apply Content Gating
                        if (lesson.isPremiumContent() && !isEnrolledInCourse) {
                            lesson.setEmbedVideoUrl(null); // Clear embeddable URL if not authorized
                            lesson.setPdfUrl(null);   // Also clear original PDF URL to prevent direct download
                            lesson.setEmbedPdfUrl(null); // Clear embeddable PDF URL
                            lesson.setDescription("Premium Content. Please enroll in " + (parentCourse != null ? parentCourse.getCourseName() : "this course") + " to access.");
                        }
                    }
                    request.setAttribute("lessonsList", lessonsList);

                } else {
                    request.setAttribute("errorMessage", "Module not found: " + moduleName);
                    contentType = "error";
                }
            } else {
                request.setAttribute("errorMessage", "Invalid content type or missing parameters.");
                contentType = "error";
            }

            request.setAttribute("loggedInUser", loggedInUser);


            RequestDispatcher dispatcher = request.getRequestDispatcher("/dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "DashboardServlet: Error during data preparation or forwarding for user " + loggedInUser.getUserId() + " with contentType: " + contentType + ", series: " + selectedSeries + ", course: " + courseName + ", module: " + moduleName, e);
            request.setAttribute("errorMessage", "An error occurred while loading the content: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // --- NEW Helper Methods for URL Conversion ---
    private String convertVideoUrlToEmbed(String videoUrl) {
        // Convert YouTube URL to embed format
        Matcher youtubeMatcher = YOUTUBE_VIDEO_ID_PATTERN.matcher(videoUrl);
        if (youtubeMatcher.find()) {
            String videoId = youtubeMatcher.group();
            return "https://drive.google.com/drive/folders/1Blfv-H9lWk1ldq2SXT0oDKjbnzBY0d2-?usp=drive_link" + videoId + "?autoplay=1"; // Autoplay for direct embed
        }

        // Convert Google Drive video URL to embed format
        Matcher driveMatcher = GOOGLE_DRIVE_FILE_ID_PATTERN.matcher(videoUrl);
        if (driveMatcher.find()) {
            String fileId = driveMatcher.group(1); // Group 1 captures the file ID
            return "https://drive.google.com/drive/folders/1Blfv-H9lWk1ldq2SXT0oDKjbnzBY0d2-?usp=drive_link" + fileId + "/preview"; // Google Drive embed/preview
        }

        LOGGER.warning("Unsupported video URL format for embedding: " + videoUrl);
        return videoUrl; // Return original if not recognized
    }

    private String convertPdfUrlToEmbed(String pdfUrl) {
        // Convert Google Drive PDF URL to embed format
        Matcher driveMatcher = GOOGLE_DRIVE_FILE_ID_PATTERN.matcher(pdfUrl);
        if (driveMatcher.find()) {
            String fileId = driveMatcher.group(1);
            // For PDF, Google Viewer is generally used for embedding
            return "https://docs.google.com/viewer?url=https://drive.google.com/uc?export=download&id=" + fileId + "&embedded=true";
            // Alternative directly if shareable link works for embedding:
            // return "https://drive.google.com/file/d/" + fileId + "/preview";
        }
        LOGGER.warning("Unsupported PDF URL format for embedding: " + pdfUrl);
        return pdfUrl; // Return original if not recognized
    }
}
