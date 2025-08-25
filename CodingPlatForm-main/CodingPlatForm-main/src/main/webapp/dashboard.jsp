<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DSA Problem Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Specific CSS for the "No Problems Found" message (already existing) */
        .no-problems-message {
            background-color: var(--bg-medium);
            border: 2px dashed var(--border-color);
            border-radius: var(--border-radius-md);
            padding: var(--spacing-xl);
            text-align: center;
            margin-top: var(--spacing-xl);
            font-size: 1.2em;
            color: var(--text-muted);
            animation: fadeIn 0.8s ease-out; /* Simple fade-in animation */
        }

        .no-problems-message strong {
            color: var(--accent-red);
            display: block;
            font-size: 1.5em;
            margin-bottom: var(--spacing-md);
        }
        .no-problems-message p {
            margin-bottom: var(--spacing-sm);
        }
        .no-problems-message a {
            color: var(--accent-blue);
            text-decoration: none;
            font-weight: bold;
        }
        .no-problems-message a:hover {
            text-decoration: underline;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* NEW: Course/Module/Lesson List Styling */
        .course-list-section, .module-list-section, .lesson-list-section {
            margin-top: var(--spacing-xl);
        }

        .course-card, .module-card {
            background-color: var(--bg-medium);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-md);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-md);
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .course-card:hover, .module-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
        }

        .course-card h3, .module-card h3 {
            color: var(--accent-green);
            font-size: 1.8em;
            margin-bottom: var(--spacing-sm);
        }
        .course-card p, .module-card p {
            color: var(--text-muted);
            font-size: 0.95em;
            line-height: 1.4;
            margin-bottom: var(--spacing-sm);
        }
        .course-card .price {
            font-weight: bold;
            color: var(--accent-orange);
            font-size: 1.1em;
        }
        .course-card .details-link, .module-card .details-link {
            background-color: var(--accent-blue);
            color: white;
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius-sm);
            text-decoration: none;
            font-size: 0.9em;
            margin-top: var(--spacing-md);
            align-self: flex-start;
            transition: background-color 0.2s ease;
        }
        .course-card .details-link:hover, .module-card .details-link:hover {
            background-color: #0056b3;
        }

        /* Lesson specific styles */
        .lesson-item {
            background-color: var(--bg-medium);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-md);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-md);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .lesson-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
        }
        .lesson-item h4 {
            color: var(--text-light);
            font-size: 1.4em;
            margin-bottom: var(--spacing-xs);
        }
        .lesson-item .lesson-header {
            display: flex;
            align-items: center;
            margin-bottom: var(--spacing-sm);
        }
        .lesson-item .lesson-order {
            color: var(--accent-green);
            font-weight: bold;
            margin-right: var(--spacing-sm);
        }
        .lesson-item .premium-tag {
            background-color: var(--accent-orange);
            color: white;
            padding: 3px 8px;
            border-radius: var(--border-radius-sm);
            font-size: 0.75em;
            margin-left: var(--spacing-sm);
            white-space: nowrap;
        }
        .lesson-item .resource-links-group {
            display: flex;
            gap: var(--spacing-sm);
            margin-top: var(--spacing-md);
            flex-wrap: wrap; /* Allow links to wrap */
        }
        .lesson-item .resource-link {
            background-color: var(--accent-blue);
            color: white;
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius-sm);
            text-decoration: none;
            font-size: 0.9em;
            transition: background-color 0.2s ease;
        }
        .lesson-item .resource-link:hover {
            background-color: #0056b3;
        }
        .lesson-item .resource-link-disabled {
            background-color: var(--bg-light);
            color: var(--text-muted);
            cursor: not-allowed;
        }
        .lesson-item .resource-link-disabled:hover {
            background-color: var(--bg-light); /* Prevent hover effect on disabled */
        }

        /* Video/PDF Viewer Styling */
        .media-viewer {
            background-color: black;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-md);
            overflow: hidden;
            margin-bottom: var(--spacing-xl);
            position: relative; /* For aspect ratio */
            padding-top: 56.25%; /* 16:9 Aspect Ratio (9/16 * 100) */
        }
        .media-viewer iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }
        .media-viewer .viewer-placeholder {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--text-muted);
            font-size: 1.2em;
            background-color: var(--bg-dark);
        }
        .media-viewer .viewer-placeholder strong {
            color: var(--accent-blue);
        }
    </style>
</head>
<body>
    <header class="global-header">
        <div class="header-content">
            <div class="site-branding">
                <a href="dashboard?contentType=problems" class="site-logo">!</a>
                <span class="site-title">Coding</span>
                <a href="dashboard?contentType=problems" class="site-logo">!</a>
            </div>
            <nav class="header-nav">
                <ul>
                    <li><a href="dashboard?contentType=problems&series=All%20Series">All Problems</a></li>
                    <!-- <li><a href="dashboard?contentType=problems&series=String%20Series">String Series</a></li>
                    <li><a href="dashboard?contentType=problems&series=Binary%20Search%20Series">Binary Search</a></li> -->
                    <li><a href="dashboard?contentType=courses">Courses</a></li>
                </ul>
            </nav>
            <div class="user-info-header">
                <c:if test="${not empty loggedInUser}">
                    <span>Hello, <span style="color: var(--accent-green); font-weight: bold;">${loggedInUser.username}</span>!</span>
                    <a href="logout" class="logout-link">Logout</a>
                </c:if>
                <c:if test="${empty loggedInUser}">
                    <a href="login.jsp" class="login-link">Login</a>
                    <a href="signup.jsp" class="signup-link">Sign Up</a>
                </c:if>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="sidebar">
            <h2>Playlist</h2>


            <div class="collapsible-section sidebar-section ${contentType == 'problems' ? 'expanded' : ''}">
                <h3 class="section-header" onclick="toggleCollapsible(this)">
                    DSA Problems Menu <span class="toggle-icon">▼</span>
                </h3>
                <div class="collapsible-content">
                    <ul>
                        <c:set var="seriesNames" value="${allSeriesNames}"/>
                        <c:forEach var="seriesName" items="${seriesNames}">
                            <li class="${(contentType == 'problems' && selectedSeries == seriesName) ? 'active' : ''}">
                                <a href="dashboard?contentType=problems&series=${fn:replace(seriesName, ' ', '%20')}">${seriesName}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>

            <div class="collapsible-section sidebar-section ${contentType == 'courses' || contentType == 'modules' || contentType == 'lessons' ? 'expanded' : ''}">
                <h3 class="section-header" onclick="toggleCollapsible(this)">
                    Courses <span class="toggle-icon">▼</span>
                </h3>
                <div class="collapsible-content">
                    <ul>
                        <li class="${(contentType == 'courses') ? 'active' : ''}">
                            <a href="dashboard?contentType=courses">All Courses</a>
                        </li>
                        <c:forEach var="course" items="${allCourses}">
                            <li class="${(contentType == 'modules' || contentType == 'lessons') && selectedCourse.courseId == course.courseId ? 'active' : ''}">
                                <a href="dashboard?contentType=modules&course=${fn:replace(course.courseName, ' ', '%20')}">${course.courseName}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>

            <%-- Other top-level menus could go here if not collapsible or static --%>

        </div>

        <div class="main-content">
            <h1>${mainContentTitle}
                <c:if test="${contentType == 'problems' && not empty selectedSeries && selectedSeries != 'All Series'}">  ${selectedSeries}</c:if>
                <c:if test="${contentType == 'modules' && not empty selectedCourse}">
                    <br><small style="font-size: 0.6em; color: var(--text-muted);">in ${selectedCourse.courseName}</small>
                </c:if>
                <c:if test="${contentType == 'lessons' && not empty selectedModule}">
                    <br><small style="font-size: 0.6em; color: var(--text-muted);">from ${selectedModule.moduleName} in ${parentCourse.courseName}</small>
                </c:if>
            </h1>

            <div class="note-section">
                <strong>Welcome to DSA Master Hub!</strong>
                <p>This platform provides a structured path to master Data Structures and Algorithms. You'll find a curated list of problems to practice and track your progress.</p>
                <p>Remember to mark problems as 'Completed' to update your progress bars. Happy coding!</p>
            </div>

            <c:if test="${contentType == 'problems'}">
                <div class="progress-container">
                    <c:set var="totalPercentage" value="${(totalProblems > 0) ? (totalSolved / totalProblems) * 100 : 0}"/>
                    <c:set var="easyPercentage" value="${(easyProblems > 0) ? (easySolved / easyProblems) * 100 : 0}"/>
                    <c:set var="mediumPercentage" value="${(mediumProblems > 0) ? (mediumSolved / mediumProblems) * 100 : 0}"/>
                    <c:set var="hardPercentage" value="${(hardProblems > 0) ? (hardSolved / hardProblems) * 100 : 0}"/>

                    <div class="progress-item">
                        <span class="progress-label">Total Progress</span>
                        <div class="progress-bar-bg"><div class="progress-bar" id="total-progress-bar" style="width: <fmt:formatNumber value="${totalPercentage}" maxFractionDigits="0"/>%;"></div></div>
                        <span class="progress-text" id="total-progress-text">${totalSolved}/${totalProblems} (<fmt:formatNumber value="${totalPercentage}" maxFractionDigits="0"/>%)</span>
                    </div>
                    <div class="progress-item">
                        <span class="progress-label">Easy</span>
                        <div class="progress-bar-bg"><div class="progress-bar easy" id="easy-progress-bar" style="width: <fmt:formatNumber value="${easyPercentage}" maxFractionDigits="0"/>%;"></div></div>
                        <span class="progress-text" id="easy-progress-text">${easySolved}/${easyProblems} (<fmt:formatNumber value="${easyPercentage}" maxFractionDigits="0"/>%)</span>
                    </div>
                    <div class="progress-item">
                        <span class="progress-label">Medium</span>
                        <div class="progress-bar-bg"><div class="progress-bar medium" id="medium-progress-bar" style="width: <fmt:formatNumber value="${mediumPercentage}" maxFractionDigits="0"/>%;"></div></div>
                        <span class="progress-text" id="medium-progress-text">${mediumSolved}/${mediumProblems} (<fmt:formatNumber value="${mediumPercentage}" maxFractionDigits="0"/>%)</span>
                    </div>
                    <div class="progress-item">
                        <span class="progress-label">Hard</span>
                        <div class="progress-bar-bg"><div class="progress-bar hard" id="hard-progress-bar" style="width: <fmt:formatNumber value="${hardPercentage}" maxFractionDigits="0"/>%;"></div></div>
                        <span class="progress-text" id="hard-progress-text">${hardSolved}/${hardProblems} (<fmt:formatNumber value="${hardPercentage}" maxFractionDigits="0"/>%)</span>
                    </div>
                    <!-- <button class="pick-random-btn">⚡ Pick Random</button> -->
                </div>
            </c:if>

            <div class="filters-options">
                <button class="btn-all-problems">All Problems</button>
                <button class="btn-revision">Revision</button>
                <div class="dropdown">
                    <button class="dropbtn">Difficulty ▼</button>
                    <div class="dropdown-content">
                        <a href="#">Easy</a>
                        <a href="#">Medium</a>
                        <a href="#">Hard</a>
                    </div>
                </div>
                <div class="dropdown">
                    <button class="dropbtn">Status ▼</button>
                    <div class="dropdown-content">
                        <a href="#">Not Started</a>
                        <a href="#">In Progress</a>
                        <a href="#">Completed</a>
                    </div>
                </div>
                <button class="btn-shuffle">⤢ Shuffle</button>
            </div>

            <div class="dynamic-content-area">
                <c:choose>
                    <c:when test="${contentType == 'problems'}">
                        <div class="problem-list">
                            <c:if test="${empty problemsByDifficulty}">
                                <div class="no-problems-message">
                                    <strong>No Problems Found!</strong>
                                    <p>No problems are available for the selected series: "<span style="color: var(--accent-green); font-weight: bold;">${selectedSeries}</span>".</p>
                                    <p>Please select another series or <a href="dashboard?series=All%20Series">view all problems</a>.</p>
                                </div>
                            </c:if>

                            <c:if test="${not empty problemsByDifficulty}">
                                <c:forEach var="entry" items="${problemsByDifficulty}" varStatus="loop">
                                    <c:set var="difficultyLevel" value="${entry.key}"/>
                                    <c:set var="problemsForThisDifficulty" value="${entry.value}"/>

                                    <c:set var="difficultySolvedCount" value="0"/>
                                    <c:forEach var="problem" items="${problemsForThisDifficulty}">
                                        <c:if test="${problem.userStatus == 'Completed'}">
                                            <c:set var="difficultySolvedCount" value="${difficultySolvedCount + 1}"/>
                                        </c:if>
                                    </c:forEach>

                                    <div class="collapsible-section">
                                        <h2 class="section-header" onclick="toggleCollapsible(this)"
                                            data-difficulty="${difficultyLevel.toLowerCase()}">
                                            ${difficultyLevel} Problems <span id="${difficultyLevel.toLowerCase()}-section-count">${difficultySolvedCount}/${problemsForThisDifficulty.size()}</span>
                                            <span class="toggle-icon">▼</span>
                                        </h2>
                                        <div class="collapsible-content">
                                            <table>
                                                <thead>
                                                    <tr>
                                                        <th>Status</th>
                                                        <th>Problem</th>
                                                        <th>Practice</th>
                                                        <th>Difficulty</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="problem" items="${problemsForThisDifficulty}">
                                                        <tr data-problem-difficulty="${problem.difficulty.toLowerCase()}" data-problem-id="${problem.id}">
                                                            <td>
                                                                <input type="checkbox"
                                                                       data-problem-id="${problem.id}"
                                                                       <c:if test="${problem.userStatus == 'Completed'}">checked</c:if>
                                                                       onchange="updateProblemStatus(this)">
                                                                <span id="status-display-${problem.id}" style="color:
                                                                    <c:choose>
                                                                        <c:when test="${problem.userStatus == 'Completed'}">var(--accent-green)</c:when>
                                                                        <c:when test="${problem.userStatus == 'In Progress'}">var(--accent-orange)</c:when>
                                                                        <c:otherwise>var(--text-light)</c:otherwise>
                                                                    </c:choose>">
                                                                    <c:choose>
                                                                        <c:when test="${problem.userStatus == 'Completed'}">✓</c:when>
                                                                        <c:when test="${problem.userStatus == 'In Progress'}">...</c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </td>
                                                            <td>${problem.title}</td>
                                                            <td><a href="${problem.resourceFreeLink}" target="_blank">↪️ Solve</a></td>
                                                            <td><span class="difficulty-${problem.difficulty.toLowerCase()}">${problem.difficulty}</span></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                            <%-- Placeholder for difficulties that might not have problems yet (only in problems view) --%>
                            <c:set var="displayedDifficultyKeys" value=""/>
                            <c:forEach var="entry" items="${problemsByDifficulty}"><c:set var="displayedDifficultyKeys" value="${displayedDifficultyKeys},${entry.key}"/></c:forEach>

                            <c:if test="${!fn:contains(displayedDifficultyKeys, 'Easy') && easyProblems == 0}">
                                 <div class="collapsible-section">
                                    <h2 class="section-header" onclick="toggleCollapsible(this)" data-difficulty="easy">
                                        Easy Problems <span id="easy-section-count">0/0</span>
                                        <span class="toggle-icon">▼</span>
                                    </h2>
                                    <div class="collapsible-content">
                                        <p style="color: var(--text-muted); text-align: center; padding: 20px;">No Easy problems available yet.</p>
                                    </div>
                                 </div>
                            </c:if>
                            <c:if test="${!fn:contains(displayedDifficultyKeys, 'Medium') && mediumProblems == 0}">
                                 <div class="collapsible-section">
                                    <h2 class="section-header" onclick="toggleCollapsible(this)" data-difficulty="medium">
                                        Medium Problems <span id="medium-section-count">0/0</span>
                                        <span class="toggle-icon">▼</span>
                                    </h2>
                                    <div class="collapsible-content">
                                        <p style="color: var(--text-muted); text-align: center; padding: 20px;">No Medium problems available yet.</p>
                                    </div>
                                 </div>
                            </c:if>
                            <c:if test="${!fn:contains(displayedDifficultyKeys, 'Hard') && hardProblems == 0}">
                                 <div class="collapsible-section">
                                    <h2 class="section-header" onclick="toggleCollapsible(this)" data-difficulty="hard">
                                        Hard Problems <span id="hard-section-count">0/0</span>
                                        <span class="toggle-icon">▼</span>
                                    </h2>
                                    <div class="collapsible-content">
                                        <p style="color: var(--text-muted); text-align: center; padding: 20px;">No Hard problems available yet.</p>
                                    </div>
                                 </div>
                            </c:if>
                        </div> <%-- End of problem-list --%>
                    </c:when>

                    <c:when test="${contentType == 'courses'}">
                        <div class="course-list-section">
                            <c:if test="${not empty mainContentTitle}">
                                <h2 style="color: var(--text-light); margin-top: var(--spacing-md);">${mainContentTitle}</h2>
                            </c:if>
                            <c:if test="${empty coursesList}">
                                <div class="no-problems-message">
                                    <strong>No Courses Found!</strong>
                                    <p>There are currently no courses available.</p>
                                </div>
                            </c:if>
                            <c:forEach var="course" items="${coursesList}">
                                <div class="course-card">
                                    <h3>${course.courseName}</h3>
                                    <p>${course.description}</p>
                                    <p class="price">Price: $<fmt:formatNumber value="${course.price}" pattern="0.00"/></p>
                                    <a href="dashboard?contentType=modules&course=${fn:replace(course.courseName, ' ', '%20')}" class="details-link">View Course Modules</a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>

                    <c:when test="${contentType == 'modules'}">
                        <div class="module-list-section">
                            <a href="dashboard?contentType=courses" style="color: var(--accent-blue); text-decoration: none; margin-bottom: var(--spacing-md); display: inline-block;">← Back to Courses</a>
                            <h2 style="color: var(--text-light); margin-top: var(--spacing-md);">${selectedCourse.courseName} Overview</h2>
                            <p style="color: var(--text-muted); margin-bottom: var(--spacing-xl);">${selectedCourse.description}</p>

                            <c:if test="${empty modulesList}">
                                <div class="no-problems-message">
                                    <strong>No Modules Found!</strong>
                                    <p>This course currently has no modules.</p>
                                </div>
                            </c:if>
                            <c:forEach var="module" items="${modulesList}">
                                <div class="module-card">
                                    <h3><span class="module-order">${module.moduleOrder}.</span> ${module.moduleName}</h3>
                                    <p>${module.description}</p>
                                    <a href="dashboard?contentType=lessons&module=${fn:replace(module.moduleName, ' ', '%20')}" class="details-link">View Lessons</a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>

                    <c:when test="${contentType == 'lessons'}">
                        <div class="lesson-list-section">
                            <a href="dashboard?contentType=modules&course=${fn:replace(parentCourse.courseName, ' ', '%20')}" style="color: var(--accent-blue); text-decoration: none; margin-bottom: var(--spacing-md); display: inline-block;">← Back to Modules in ${parentCourse.courseName}</a>
                            <h2 style="color: var(--text-light); margin-top: var(--spacing-md);">${selectedModule.moduleName} Lessons</h2>
                            <p style="color: var(--text-muted); margin-bottom: var(--spacing-xl);">${selectedModule.description}</p>

                            <div class="media-viewer">
                                <c:choose>
                                    <c:when test="${not empty currentLessonVideoUrl}">
                                        <iframe src="${currentLessonVideoUrl}" frameborder="0" allowfullscreen></iframe>
                                    </c:when>
                                    <c:when test="${not empty currentLessonPdfUrl}">
                                        <iframe src="${currentLessonPdfUrl}" frameborder="0"></iframe>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="viewer-placeholder">
                                            <strong>Select a lesson to view content.</strong>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>


                            <c:if test="${empty lessonsList}">
                                <div class="no-problems-message">
                                    <strong>No Lessons Found!</strong>
                                    <p>This module currently has no lessons.</p>
                                </div>
                            </c:if>
                            <c:forEach var="lesson" items="${lessonsList}">
                                <div class="lesson-item">
                                    <div class="lesson-header">
                                        <h4><span class="lesson-order">${lesson.lessonOrder}.</span> ${lesson.lessonName}</h4>
                                        <c:if test="${lesson.isPremiumContent()}"><span class="premium-tag">Premium</span></c:if>
                                    </div>
                                    <p>${lesson.description}</p>
                                    <div class="resource-links-group">
                                        <c:if test="${not empty lesson.embedVideoUrl}">
                                            <a href="#" class="resource-link ${lesson.isPremiumContent() && !isUserEnrolled ? 'resource-link-disabled' : ''}"
                                               onclick="return loadLessonContent(this, '${lesson.embedVideoUrl}', 'video', ${lesson.isPremiumContent() && !isUserEnrolled})">
                                               Watch Video
                                            </a>
                                        </c:if>
                                        <c:if test="${not empty lesson.embedPdfUrl}">
                                            <a href="#" class="resource-link ${lesson.isPremiumContent() && !isUserEnrolled ? 'resource-link-disabled' : ''}"
                                               onclick="return loadLessonContent(this, '${lesson.embedPdfUrl}', 'pdf', ${lesson.isPremiumContent() && !isUserEnrolled})">
                                               Read PDF
                                            </a>
                                        </c:if>
                                        <c:if test="${(lesson.isPremiumContent() && !isUserEnrolled)}">
                                            <span style="color: var(--accent-red); font-size: 0.9em; margin-left: var(--spacing-sm);">Enroll to access!</span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>

                    <c:when test="${contentType == 'error'}">
                        <div class="no-problems-message">
                            <strong>Error Loading Content!</strong>
                            <p><c:out value="${errorMessage}"/></p>
                            <p>Please <a href="dashboard?contentType=problems">go back to Problems Dashboard</a> or <a href="dashboard?contentType=courses">view Courses</a>.</p>
                        </div>
                    </c:when>
                </c:choose>
            </div> <%-- End of dynamic-content-area --%>
        </div> <%-- End of main-content --%>
    </div> <%-- End of container --%>

    <script>
        // Store global problem counts by difficulty (initialized from JSP)
        const globalProblemsCount = {
            total: ${totalProblems},
            easy: ${easyProblems},
            medium: ${mediumProblems},
            hard: ${hardProblems}
        };

        // Store solved problem counts by difficulty (initialized from JSP)
        const globalSolvedCount = {
            total: ${totalSolved},
            easy: ${easySolved},
            medium: ${mediumSolved},
            hard: ${hardSolved}
        };

        // Function to update a single progress bar
        function updateProgressBar(difficulty, solvedCount, totalCount) {
            const percentage = totalCount > 0 ? (solvedCount / totalCount) * 100 : 0;
            const progressBarElement = document.getElementById(`${difficulty}-progress-bar`);
            const progressTextElement = document.getElementById(`${difficulty}-progress-text`);

            if (progressBarElement) {
                progressBarElement.style.width = `${percentage.toFixed(0)}%`;
            }
            if (progressTextElement) {
                progressTextElement.textContent = `${solvedCount}/${totalCount} (${percentage.toFixed(0)}%)`;
            }
        }

        // Function to update section count (e.g., "Easy Problems 5/10")
        function updateSectionCount(difficulty, solvedCount, totalCount) {
            const sectionCountElement = document.getElementById(`${difficulty}-section-count`);
            if (sectionCountElement) {
                sectionCountElement.textContent = `${solvedCount}/${totalCount}`;
            }
        }


        function updateProblemStatus(checkbox) {
            const problemId = checkbox.dataset.problemId;
            const isChecked = checkbox.checked;
            const problemRow = checkbox.closest('tr');
            const problemDifficulty = problemRow.dataset.problemDifficulty;

            const statusDisplayElement = document.getElementById(`status-display-${problemId}`);
            if (!statusDisplayElement) { // Safety check to prevent null error
                console.error("Missing status display element for problemId:", problemId);
                return;
            }

            const originalStatusText = statusDisplayElement.textContent;
            const originalStatusColor = statusDisplayElement.style.color;
            const originalCheckedState = !isChecked;

            statusDisplayElement.textContent = '...';
            statusDisplayElement.style.color = '#ffeb3b';

            fetch('problemAction', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `problemId=${problemId}&isChecked=${isChecked}`
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(err.message || 'Server error'); });
                }
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    statusDisplayElement.textContent = isChecked ? '✓' : '-';
                    statusDisplayElement.style.color = isChecked ? 'var(--accent-green)' : 'var(--text-light)';

                    if (isChecked) {
                        globalSolvedCount.total++;
                        globalSolvedCount[problemDifficulty]++;
                    } else {
                        globalSolvedCount.total--;
                        globalSolvedCount[problemDifficulty]--;
                    }

                    updateProgressBar('total', globalSolvedCount.total, globalProblemsCount.total);
                    updateProgressBar('easy', globalSolvedCount.easy, globalProblemsCount.easy);
                    updateProgressBar('medium', globalSolvedCount.medium, globalProblemsCount.medium);
                    updateProgressBar('hard', globalSolvedCount.hard, globalProblemsCount.hard);

                    const totalProblemsInDifficulty = globalProblemsCount[problemDifficulty];
                    const currentSolvedInDifficulty = globalSolvedCount[problemDifficulty];
                    updateSectionCount(problemDifficulty, currentSolvedInDifficulty, totalProblemsInDifficulty);

                    console.log(`Problem ${problemId} status updated to ${isChecked ? 'Completed' : 'Not Started'}. Progress updated.`);

                } else {
                    checkbox.checked = originalCheckedState;
                    statusDisplayElement.textContent = originalStatusText;
                    statusDisplayElement.style.color = originalStatusColor;
                    console.error(`Failed to update problem ${problemId}: ${data.message}`);
                    alert(`Error: ${data.message}`);
                }
            })
            .catch(error => {
                checkbox.checked = originalCheckedState;
                statusDisplayElement.textContent = originalStatusText;
                statusDisplayElement.style.color = originalStatusColor;
                console.error('Network or unexpected error:', error);
                alert('An unexpected error occurred. Please try again.');
            });
        }

        // JavaScript for Collapsible Sections
        function toggleCollapsible(headerElement) {
            const section = headerElement.closest('.collapsible-section');
            if (!section) return;

            const content = section.querySelector('.collapsible-content');
            const toggleIcon = headerElement.querySelector('.toggle-icon');

            if (section.classList.contains('expanded')) {
                content.style.maxHeight = '0px';
                section.classList.remove('expanded');
                toggleIcon.textContent = '▼';
            } else {
                content.style.maxHeight = content.scrollHeight + "px";
                section.classList.add('expanded');
                toggleIcon.textContent = '▲';
            }
        }

        // Optional: Expand first section by default on load
        document.addEventListener('DOMContentLoaded', (event) => {
            // Determine which section to expand by default
            let headerToExpand = null;
            const contentType = "<c:out value='${contentType}'/>"; // Get content type from JSP variable

            if (contentType === 'problems') {
                headerToExpand = document.querySelector('.collapsible-section:not(.sidebar-section) .section-header');
            } else if (contentType === 'courses') {
                // For courses view, maybe expand the Courses sidebar menu
                headerToExpand = document.querySelector('.sidebar-section.expanded .section-header');
            } else if (contentType === 'modules') {
                 // For modules view, maybe expand the Courses sidebar menu
                 headerToExpand = document.querySelector('.sidebar-section.expanded .section-header');
                 // Also expand the parent course card if necessary, though it's not a collapsible-section
            } else if (contentType === 'lessons') {
                // For lessons view, expand the Modules in the sidebar
                headerToExpand = document.querySelector('.sidebar-section.expanded .section-header');
                // And the lesson viewer itself needs to display content, not collapse
            }

            if (headerToExpand) {
                // Only toggle if it's not already expanded by a previous load (e.g. from server-side 'expanded' class)
                const section = headerToExpand.closest('.collapsible-section');
                if (!section.classList.contains('expanded')) {
                     toggleCollapsible(headerToExpand);
                }
            }
        });

        // NEW: JavaScript to load lesson content into the viewer
        function loadLessonContent(linkElement, embedUrl, contentType, isPremiumAndNotEnrolled) {
            if (isPremiumAndNotEnrolled) {
                alert('This is premium content. Please enroll in the course to access.');
                return false; // Prevent default link action
            }

            const mediaViewer = document.querySelector('.media-viewer');
            if (mediaViewer) {
                mediaViewer.innerHTML = `<iframe src="${embedUrl}" frameborder="0" allowfullscreen></iframe>`;
                // Optional: Scroll to viewer
                mediaViewer.scrollIntoView({ behavior: 'smooth', block: 'start' });
            } else {
                console.error("Media viewer element not found!");
            }
            return false; // Prevent default link action (opening in new tab)
        }
    </script>
    
    
    
</body>
</html>
