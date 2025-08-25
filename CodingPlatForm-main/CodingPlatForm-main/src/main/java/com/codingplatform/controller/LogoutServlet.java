package com.codingplatform.controller;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling user logout.
 * Invalidates the user's session and redirects to the login page.
 */
@WebServlet("/logout") // Maps this servlet to the /logout URL
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    public LogoutServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Get existing session if it exists

        if (session != null) {
            String username = (session.getAttribute("loggedInUser") != null) ?
                               ((com.codingplatform.model.User)session.getAttribute("loggedInUser")).getUsername() : "unknown user";
            session.invalidate(); // Invalidate the session, removing all attributes
            LOGGER.info("User '" + username + "' logged out successfully.");
        } else {
            LOGGER.warning("Logout attempt by a user without an active session.");
        }

        // Redirect to the login page after logout
        response.sendRedirect(request.getContextPath() + "/login");
    }

    // Often doPost is not strictly necessary for logout, but can be added if desired
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
