<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - DSA Platform</title>
    <link rel="stylesheet" href="css/style.css"> <style>
        /* Specific styles for the signup page to center the form */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: var(--bg-dark); /* Ensure dark background */
            color: var(--text-light);
        }

        .signup-container {
            background-color: var(--bg-medium);
            padding: var(--spacing-xl);
            border-radius: var(--border-radius-md);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.4);
            width: 100%;
            max-width: 450px; /* Slightly wider than login for more fields */
            text-align: center;
            border: 1px solid var(--border-color);
        }

        .signup-container h2 {
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
        .form-group input[type="email"],
        .form-group input[type="password"] {
            width: 100%;
            padding: var(--spacing-sm) var(--spacing-md);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-sm);
            background-color: var(--bg-light);
            color: var(--text-light);
            font-size: 1em;
            outline: none;
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="email"]:focus,
        .form-group input[type="password"]:focus {
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
        }

        .signup-btn {
            width: 100%;
            padding: var(--spacing-md);
            background-color: var(--accent-green); /* Green for signup */
            color: white;
            border: none;
            border-radius: var(--border-radius-sm);
            cursor: pointer;
            font-size: 1.1em;
            font-weight: bold;
            transition: background-color 0.2s ease, transform 0.1s ease;
            margin-top: var(--spacing-md);
        }

        .signup-btn:hover {
            background-color: #388e3c; /* Darker green on hover */
            transform: translateY(-1px);
        }
        .signup-btn:active {
            transform: translateY(0);
        }

        .message-success {
            color: var(--accent-green);
            margin-top: var(--spacing-md);
            margin-bottom: var(--spacing-md);
            font-size: 0.9em;
        }
        .message-error {
            color: var(--accent-red);
            margin-top: var(--spacing-md);
            margin-bottom: var(--spacing-md);
            font-size: 0.9em;
        }

        .login-link {
            margin-top: var(--spacing-lg);
            font-size: 0.9em;
            color: var(--text-muted);
        }

        .login-link a {
            color: var(--accent-blue);
            text-decoration: none;
            font-weight: bold;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2>Create Your DSA Platform Account</h2>

        <%-- Display messages if present --%>
        <c:if test="${not empty successMessage}">
            <p class="message-success">${successMessage}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p class="message-error">${errorMessage}</p>
        </c:if>

        <form action="signup" method="post"> <%-- This form will submit to our SignupServlet --%>
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="signup-btn">Sign Up</button>
        </form>

        <p class="login-link">Already have an account? <a href="login.jsp">Login Here</a></p>
    </div>
</body>
</html>
