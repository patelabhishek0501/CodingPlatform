package com.codingplatform.filter;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet Filter to authenticate user access to protected resources.
 * If a user is not logged in, they are redirected to the login page.
 */
@WebFilter(
    urlPatterns = {"/dashboard/*"}, // Protects dashboard and any sub-paths
    servletNames = {"DashboardServlet"} // Also explicitly applies to DashboardServlet
)
public class AuthFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(AuthFilter.class.getName());

    /**
     * @see Filter#init(FilterConfig)
     */
    public void init(FilterConfig fConfig) throws ServletException {
        LOGGER.info("AuthFilter initialized.");
    }

    /**
     * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
     */
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Log the incoming request
        LOGGER.info("AuthFilter: Intercepting request for URI: " + requestURI);

        // Paths that are explicitly allowed without authentication (whitelist)
        // It's crucial to allow login.jsp, login servlet, signup.jsp, signup servlet, and CSS.
        // If you add JS or images, they also need to be whitelisted or placed outside protected paths.
        boolean isLoginOrSignupPage = requestURI.endsWith("/login.jsp") ||
                                      requestURI.endsWith("/signup.jsp");
        boolean isLoginOrSignupServlet = requestURI.equals(contextPath + "/login") ||
                                         requestURI.equals(contextPath + "/signup");
        boolean isCssOrJs = requestURI.contains("/css/") ||
                            requestURI.contains("/js/") ||
                            requestURI.contains("/images/"); // Add if you use an /images folder

        if (isLoginOrSignupPage || isLoginOrSignupServlet || isCssOrJs) {
            // Allow request to proceed to login/signup pages/servlets or static resources
            chain.doFilter(request, response);
            return;
        }

        // Check if the user is logged in
        HttpSession session = httpRequest.getSession(false); // Do NOT create a new session if one doesn't exist

        boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);

        if (isLoggedIn) {
            // User is authenticated, proceed with the request
            LOGGER.info("AuthFilter: User authenticated. Proceeding with request for " + requestURI);
            chain.doFilter(request, response);
        } else {
            // User is NOT authenticated, redirect to login page
            LOGGER.warning("AuthFilter: User not authenticated. Redirecting to login for " + requestURI);
            httpResponse.sendRedirect(contextPath + "/login");
        }
    }

    /**
     * @see Filter#destroy()
     */
    public void destroy() {
        LOGGER.info("AuthFilter destroyed.");
    }
}
