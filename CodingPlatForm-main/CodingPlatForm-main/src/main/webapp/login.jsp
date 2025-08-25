<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DSA Platform</title>
    <link rel="stylesheet" href="css/style.css"> <style>
        /* Specific styles for the login page to center the form */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: var(--bg-dark); /* Ensure dark background */
            color: var(--text-light);
        }

        .login-container {
            background-color: var(--bg-medium);
            padding: var(--spacing-xl);
            border-radius: var(--border-radius-md);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.4);
            width: 100%;
            max-width: 400px; /* Max width for the form container */
            text-align: center;
            border: 1px solid var(--border-color);
        }

        .login-container h2 {
            color: var(--accent-green);
            margin-bottom: var(--spacing-xl);
            font-size: 2em;
        }

        .form-group {
            margin-bottom: var(--spacing-md);
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: var(--spacing-xs);
            color: var(--text-light);
            font-size: 0.95em;
        }

        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 100%;
            padding: var(--spacing-sm) var(--spacing-md);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-sm);
            background-color: var(--bg-light);
            color: var(--text-light);
            font-size: 1em;
            outline: none; /* Remove outline on focus */
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="password"]:focus {
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25); /* Focus highlight */
        }

        .login-btn {
            width: 100%;
            padding: var(--spacing-md);
            background-color: var(--accent-blue);
            color: white;
            border: none;
            border-radius: var(--border-radius-sm);
            cursor: pointer;
            font-size: 1.1em;
            font-weight: bold;
            transition: background-color 0.2s ease, transform 0.1s ease;
            margin-top: var(--spacing-md);
        }

        .login-btn:hover {
            background-color: #0056b3;
            transform: translateY(-1px);
        }
        .login-btn:active {
            transform: translateY(0);
        }

        .error-message {
            color: var(--accent-red);
            margin-top: var(--spacing-md);
            margin-bottom: var(--spacing-md);
            font-size: 0.9em;
        }

        .signup-link {
            margin-top: var(--spacing-lg);
            font-size: 0.9em;
            color: var(--text-muted);
        }

        .signup-link a {
            color: var(--accent-blue);
            text-decoration: none;
            font-weight: bold;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login to DSA Platform</h2>

        <%-- Display error message if present --%>
        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

        <form action="login" method="post"> <%-- This form will submit to our LoginServlet --%>
            <div class="form-group">
                <label for="identifier">Username or Email</label>
                <input type="text" id="identifier" name="identifier" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="login-btn">Login</button>
        </form>

        <p class="signup-link">Don't have an account? <a href="signup.jsp">Sign Up</a></p>
    </div>
</body>
</html>