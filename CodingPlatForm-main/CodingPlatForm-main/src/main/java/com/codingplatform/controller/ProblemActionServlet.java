package com.codingplatform.controller;

import com.codingplatform.dao.UserProgressDAO;
import com.codingplatform.model.User;
import com.codingplatform.model.UserProgress;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet to handle actions related to individual problems,
 * specifically updating problem status for a specific user.
 * Revision flag functionality has been removed.
 */
@WebServlet("/problemAction")
public class ProblemActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserProgressDAO userProgressDAO;
    private static final Logger LOGGER = Logger.getLogger(ProblemActionServlet.class.getName());

    public ProblemActionServlet() {
        super();
        this.userProgressDAO = new UserProgressDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User loggedInUser = null;
        int userId = -1;

        if (session != null) {
            loggedInUser = (User) session.getAttribute("loggedInUser");
            if (loggedInUser != null) {
                userId = loggedInUser.getUserId();
            }
        }

        if (userId == -1) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\":\"error\", \"message\":\"User not logged in or session expired. Please login again.\"}");
            LOGGER.warning("ProblemActionServlet: Attempt to update problem status by unauthenticated user.");
            return;
        }

        int problemId = 0;
        // Removed actionType as only status update is handled now

        try {
            String problemIdStr = request.getParameter("problemId");
            String isCheckedStr = request.getParameter("isChecked"); // For status checkbox
            // String isRevisionToggledStr = request.getParameter("isRevisionToggled"); // REMOVED THIS PARAMETER

            if (problemIdStr != null && !problemIdStr.isEmpty()) {
                problemId = Integer.parseInt(problemIdStr);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\", \"message\":\"Missing problemId parameter.\"}");
                LOGGER.warning("ProblemActionServlet: Missing problemId parameter for user " + userId + ".");
                return;
            }

            // --- Simplified logic: Only handle status update ---
            if (isCheckedStr == null) { // If isChecked is not provided, it's a bad request for status update
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\", \"message\":\"Missing isChecked parameter for status update.\"}");
                LOGGER.warning("ProblemActionServlet: Missing isChecked parameter for user " + userId + " problem " + problemId + ".");
                return;
            }

            // Retrieve existing progress to get current status (if any)
            UserProgress userProgress = userProgressDAO.getUserProgress(userId, problemId);
            String currentStatus = "Not Started"; // Default if no existing progress

            if (userProgress != null) {
                currentStatus = userProgress.getStatus();
                // currentIsRevision = userProgress.isRevision(); // REMOVED
            } else {
                // If no existing progress, create a new UserProgress object with defaults
                // Removed isRevision parameter from constructor
                userProgress = new UserProgress(userId, problemId, currentStatus);
            }

            boolean success = false;
            boolean isChecked = Boolean.parseBoolean(isCheckedStr);
            String newStatus = isChecked ? "Completed" : "Not Started";
            userProgress.setStatus(newStatus); // Update only status
            // userProgress.setRevision(currentIsRevision); // REMOVED: Preserve revision as it's gone
            success = userProgressDAO.saveOrUpdateUserProgress(userProgress);
            LOGGER.info("User " + userId + ": Problem ID " + problemId + " status updated to: " + newStatus);


            if (success) {
                out.print("{\"status\":\"success\", \"message\":\"Problem status updated successfully.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"status\":\"error\", \"message\":\"Failed to update problem status in DB.\"}");
                LOGGER.log(Level.WARNING, "ProblemActionServlet: Failed to update user " + userId + " problem status for ID " + problemId + ".");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"Invalid problemId format.\"}");
            LOGGER.log(Level.WARNING, "ProblemActionServlet: Invalid problemId format '" + request.getParameter("problemId") + "' for user " + userId + ".", e);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"An unexpected error occurred: " + e.getMessage() + "\"}");
            LOGGER.log(Level.SEVERE, "ProblemActionServlet: Unexpected error during problem status update for user " + userId + ".", e);
        }
    }
}
