package com.codingplatform.controller;

import com.codingplatform.dao.UserDAO;
import com.codingplatform.model.User;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // Import HttpSession

/**
 * Servlet for handling user login requests.
 */
@WebServlet("/login") // Maps this servlet to the /login URL
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    /**
     * Constructor: Initializes the UserDAO.
     */
    public LoginServlet() {
        super();
        this.userDAO = new UserDAO();
    }

    /**
     * Handles GET requests to /login.
     * Typically, this means a user is trying to access the login page directly.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false); // false means don't create new session if none exists
        if (session != null && session.getAttribute("loggedInUser") != null) {
            // User is already logged in, redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        // If not logged in, forward to login.jsp to display the form
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * Handles POST requests from the login form.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String identifier = request.getParameter("identifier"); // Username or Email
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter username/email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User authenticatedUser = null;
        try {
            authenticatedUser = userDAO.authenticateUser(identifier, password);
        } catch (Exception e) { // Catch any unexpected exceptions from DAO
            LOGGER.log(Level.SEVERE, "Login error for identifier: " + identifier, e);
            request.setAttribute("errorMessage", "An unexpected error occurred during login. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (authenticatedUser != null) {
            // Login successful!
            HttpSession session = request.getSession(); // Get existing session or create a new one
            session.setAttribute("loggedInUser", authenticatedUser); // Store the User object in session
            session.setMaxInactiveInterval(30 * 60); // Session timeout: 30 minutes (optional)
            LOGGER.info("User '" + authenticatedUser.getUsername() + "' logged in successfully. User ID: " + authenticatedUser.getUserId());

            // Redirect to the dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            // Login failed
            request.setAttribute("errorMessage", "Invalid username/email or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
