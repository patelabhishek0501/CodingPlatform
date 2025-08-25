<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to DSA Platform</title>
    <link rel="stylesheet" href="css/style.css"> <style>
        /* Specific styles for the home/index page */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: var(--bg-dark);
            color: var(--text-light);
            text-align: center;
        }

        .home-container {
            background-color: var(--bg-medium);
            padding: var(--spacing-xl);
            border-radius: var(--border-radius-md);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.4);
            width: 100%;
            max-width: 600px;
            border: 1px solid var(--border-color);
        }

        .home-container h1 {
            color: var(--accent-green);
            font-size: 2.5em;
            margin-bottom: var(--spacing-lg);
        }

        .home-container p {
            font-size: 1.1em;
            margin-bottom: var(--spacing-xl);
            color: var(--text-muted);
        }

        .home-links a {
            display: inline-block;
            background-color: var(--accent-blue);
            color: white;
            padding: var(--spacing-md) var(--spacing-xl);
            border-radius: var(--border-radius-sm);
            text-decoration: none;
            font-weight: bold;
            font-size: 1.1em;
            margin: 0 var(--spacing-sm);
            transition: background-color 0.2s ease, transform 0.1s ease;
        }

        .home-links a:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
        .home-links a:active {
            transform: translateY(0);
        }

        .home-links a.signup-btn {
            background-color: var(--accent-green); /* Green for signup button */
        }
        .home-links a.signup-btn:hover {
            background-color: #388e3c;
        }
    </style>
</head>
<body>
    <div class="home-container">
        <h1>Welcome to the DSA Practice Platform!</h1>
        <p>Master Data Structures and Algorithms with a structured learning path.</p>
        <div class="home-links">
            <a href="login.jsp">Login</a>
            <a href="signup.jsp" class="signup-btn">Sign Up</a>
        </div>
        <p style="margin-top: 30px; font-size: 0.85em; color: var(--text-muted);">
            If you are already logged in, you can go directly to your <a href="dashboard" style="color: var(--accent-blue);">Dashboard</a>.
        </p>
    </div>
</body>
</html>