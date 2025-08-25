<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - DSA Platform</title>
    <link rel="stylesheet" href="css/style.css"> <%-- Reuse your existing CSS --%>
    <style>
        /* Basic styling for the error page */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: var(--bg-dark); /* Dark background */
            color: var(--text-light);
            text-align: center;
        }
        .error-container {
            background-color: var(--bg-medium);
            padding: var(--spacing-xl);
            border-radius: var(--border-radius-md);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.4);
            width: 100%;
            max-width: 500px;
            border: 1px solid var(--border-color);
        }
        .error-container h1 {
            color: var(--accent-red);
            font-size: 2.5em;
            margin-bottom: var(--spacing-md);
        }
        .error-container p {
            font-size: 1.1em;
            margin-bottom: var(--spacing-lg);
        }
        .error-container .details {
            background-color: var(--bg-light);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-sm);
            padding: var(--spacing-md);
            margin-bottom: var(--spacing-xl);
            font-family: monospace;
            font-size: 0.9em;
            text-align: left;
            white-space: pre-wrap; /* Preserve whitespace and wrap long lines */
            word-wrap: break-word; /* Break long words */
            color: var(--text-light);
        }
        .error-container a {
            background-color: var(--accent-blue);
            color: white;
            padding: var(--spacing-md) var(--spacing-xl);
            border-radius: var(--border-radius-sm);
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.2s ease;
        }
        .error-container a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Oops! An Error Occurred.</h1>
        <p>Something went wrong on our end. We apologize for the inconvenience.</p>

        <c:if test="${not empty errorMessage}">
            <p style="color: var(--accent-red); font-weight: bold;">Details:</p>
            <div class="details">
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/dashboard">Go to Dashboard</a>
        <br><br>
        <a href="${pageContext.request.contextPath}/login">Go to Login Page</a>
    </div>
</body>
</html>
