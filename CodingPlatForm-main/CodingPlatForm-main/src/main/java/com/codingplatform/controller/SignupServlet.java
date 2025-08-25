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

/**
 * Servlet for handling user registration (signup) requests.
 */
@WebServlet("/signup") // Maps this servlet to the /signup URL
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(SignupServlet.class.getName());

    /**
     * Constructor: Initializes the UserDAO.
     */
    public SignupServlet() {
        super();
        this.userDAO = new UserDAO();
    }

    /**
     * Handles GET requests to /signup.
     * Displays the signup form.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/signup.jsp").forward(request, response);
    }

    /**
     * Handles POST requests from the signup form.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // --- Basic Server-Side Validation ---
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // Simple email format check (more robust validation should be done with regex or dedicated library)
        if (!email.matches("^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$")) {
            request.setAttribute("errorMessage", "Please enter a valid email address.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // Password strength check (example: at least 6 characters)
        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // Create a User object (password is still plain text here; DAO will hash it)
        User newUser = new User(username, email, password);

        try {
            User registeredUser = userDAO.registerUser(newUser);

            if (registeredUser != null) {
                // Registration successful
                LOGGER.info("New user registered: " + username + " (ID: " + registeredUser.getUserId() + ")");
                request.setAttribute("successMessage", "Registration successful! You can now log in.");
                request.getRequestDispatcher("/login.jsp").forward(request, response); // Then login to go to dashboard// Redirect to login page
            } else {
                // Registration failed, likely due to duplicate username/email (handled in UserDAO)
                request.setAttribute("errorMessage", "Registration failed. Username or Email might already exist. Please try again with different credentials.");
                request.getRequestDispatcher("/signup.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Catch any unexpected database or system errors
            LOGGER.log(Level.SEVERE, "Error during user registration for username: " + username, e);
            request.setAttribute("errorMessage", "An unexpected error occurred during registration. Please try again.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }
}
