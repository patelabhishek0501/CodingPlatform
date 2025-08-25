package com.codingplatform.controller;


import com.codingplatform.dao.ProblemDAO;
import com.codingplatform.model.Problem;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException; // For HttpServlet
import javax.servlet.annotation.WebServlet; // For annotation mapping
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet for testing database connectivity and data retrieval.
 * Accessible via /testdb URL.
 */
@WebServlet("/testdb") // This annotation maps the servlet to the URL /testdb
public class TestDBServlet extends HttpServlet {
    private static final long serialVersionUID = 1L; // Recommended for Servlets

    private ProblemDAO problemDAO; // Declare DAO instance

    // Logger for this servlet
    private static final Logger LOGGER = Logger.getLogger(TestDBServlet.class.getName());

    /**
     * Constructor: Initialize the ProblemDAO.
     */
    public TestDBServlet() {
        super();
        this.problemDAO = new ProblemDAO(); // Instantiate the DAO
    }

    /**
     * Handles GET requests to /testdb.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html"); // Set content type for browser
        PrintWriter out = response.getWriter(); // Get writer to send output to browser

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Database Test</title>");
        out.println("<style>");
        out.println("body { font-family: monospace; background-color: #1a1a1a; color: #e0e0e0; margin: 20px; }");
        out.println("h1 { color: #4CAF50; }");
        out.println("p { margin-bottom: 5px; }");
        out.println(".error { color: #f44336; font-weight: bold; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Testing Database Connection & Problem Retrieval</h1>");

        try {
            // 1. Retrieve problems using the DAO
            List<Problem> problems = problemDAO.getAllProblems();

            // 2. Check if problems were retrieved
            if (problems.isEmpty()) {
                out.println("<p class=\"error\">No problems found in the database. Please ensure you inserted sample data!</p>");
                LOGGER.info("TestDBServlet: No problems found in the database.");
            } else {
                out.println("<h2>Problems Retrieved:</h2>");
                // 3. Iterate and display each problem
                for (Problem problem : problems) {
                    out.println("<p>" + problem.toString() + "</p>"); // Using Problem's toString() method
                    System.out.println("Retrieved Problem: " + problem.toString()); // Also print to server console
                }
                LOGGER.info("TestDBServlet: Successfully retrieved " + problems.size() + " problems.");
            }

        } catch (Exception e) { // Catching a generic Exception for broader error handling at this stage
            out.println("<p class=\"error\">An error occurred while accessing the database:</p>");
            out.println("<pre class=\"error\">" + e.getMessage() + "</pre>"); // Display error message
            // Log the full stack trace for detailed debugging in the server logs
            LOGGER.log(Level.SEVERE, "TestDBServlet: Database access error", e);
        }

        out.println("</body>");
        out.println("</html>");
    }
}
