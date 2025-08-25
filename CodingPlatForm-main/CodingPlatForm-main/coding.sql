CREATE DATABASE dsa_db;
USE dsa_db;

CREATE TABLE problems (
    id INT AUTO_INCREMENT PRIMARY KEY,
    day INT,
    title VARCHAR(255),
    resource_free_link VARCHAR(255),
    resource_paid_link VARCHAR(255),
    difficulty ENUM('Easy', 'Medium', 'Hard'),
    is_solved BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL COMMENT 'Store hashed passwords (e.g., BCrypt)',
  `registration_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;



-- 1. Remove the 'is_solved' column from the 'problems' table
ALTER TABLE `problems` DROP COLUMN `is_solved`;

-- 2. Create the 'user_progress' table if it doesn't exist
-- This table links users to problems and tracks their individual status.
CREATE TABLE IF NOT EXISTS `user_progress` (
  `user_progress_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `problem_id` INT NOT NULL,
  `status` ENUM('Not Started', 'In Progress', 'Completed', 'Skipped') NOT NULL DEFAULT 'Not Started',
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_progress_id`),
  UNIQUE INDEX `uq_user_problem` (`user_id` ASC, `problem_id` ASC) VISIBLE, -- Ensures a user has only one entry per problem
  CONSTRAINT `fk_up_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_up_problem`
    FOREIGN KEY (`problem_id`)
    REFERENCES `problems` (`id`) -- Note: problems table has 'id'
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Optional: If you want to populate some initial user progress data for a test user:
-- Replace 'testuser1' with an actual username you registered, and get their user_id
-- Replace 'Remove outermost Parenthesis' etc. with actual problem titles to get their IDs.

-- Example: Get test user's ID
-- SET @testuser_id = (SELECT user_id FROM `users` WHERE username = 'testuser1');
-- SET @problem1_id = (SELECT id FROM `problems` WHERE title = 'Remove outermost Parenthesis');
-- SET @problem4_id = (SELECT id FROM `problems` WHERE title = 'Longest Common Prefix');

-- INSERT INTO `user_progress` (`user_id`, `problem_id`, `status`) VALUES
-- (@testuser_id, @problem1_id, 'Completed'),
-- (@testuser_id, @problem4_id, 'In Progress');

-- Verify your new table and schema:
DESCRIBE `problems`;
DESCRIBE `user_progress`;
SELECT * FROM `problems`;
SELECT * FROM `user_progress`;



ALTER TABLE `problems`
ADD COLUMN `series` VARCHAR(255) DEFAULT 'General' AFTER `day`; -- Add after 'day' column, with a default value

-- You can verify the update:
SELECT id, title, series, difficulty FROM problems WHERE series IS NOT NULL;


ALTER TABLE `user_progress`
ADD COLUMN `is_revision` BOOLEAN NOT NULL DEFAULT FALSE AFTER `status`; -- Add after 'status' column


INSERT INTO `problems` (`day`, `series`, `title`, `resource_free_link`, `resource_paid_link`, `difficulty`) VALUES
(1, 'Binary Search Series', 'Binary Search Algorithm (Iterative and Recursive)', 'https://leetcode.com/problems/binary-search/', 'https://tuf.com/plus/binary-search-algo', 'Easy'),
(1, 'Binary Search Series', 'Lower Bound', 'https://www.geeksforgeeks.org/std-lower_bound-in-cpp/', 'https://tuf.com/plus/lower-bound', 'Easy'),
(1, 'Binary Search Series', 'Upper Bound', 'https://www.geeksforgeeks.org/std-upper_bound-in-cpp/', 'https://tuf.com/plus/upper-bound', 'Easy'),
(1, 'Binary Search Series', 'Search Insert Position', 'https://leetcode.com/problems/search-insert-position/', 'https://tuf.com/plus/search-insert-position', 'Easy'),
(1, 'Binary Search Series', 'Floor and Ceil in Sorted Array', 'https://www.geeksforgeeks.org/floor-and-ceil-from-a-bst/', 'https://tuf.com/plus/floor-ceil-sorted-array', 'Medium'),
(1, 'Binary Search Series', 'First and Last occurrence of element in sorted array', 'https://leetcode.com/problems/find-first-and-last-position-of-element-in-sorted-array/', 'https://tuf.com/plus/first-last-occurrence', 'Medium'),
(1, 'Binary Search Series', 'Count Occurrences in Sorted Array', 'https://www.geeksforgeeks.org/count-occurrences-of-a-number-in-a-sorted-array-with-duplicates/', 'https://tuf.com/plus/count-occurrences-sorted-array', 'Easy'),
(1, 'Binary Search Series', 'Number of times a sorted array is rotated', 'https://www.geeksforgeeks.org/find-rotation-count-rotated-sorted-array/', 'https://tuf.com/plus/rotated-sorted-array-count-rotations', 'Medium'),
(1, 'Binary Search Series', 'Search element in a rotated sorted array', 'https://leetcode.com/problems/search-in-rotated-sorted-array/', 'https://tuf.com/plus/search-in-rotated-sorted-array', 'Medium'),
(1, 'Binary Search Series', 'Search element in a rotated sorted array II', 'https://leetcode.com/problems/search-in-rotated-sorted-array-ii/', 'https://tuf.com/plus/search-in-rotated-sorted-array-ii', 'Medium'),
(1, 'Binary Search Series', 'Find minimum in rotated sorted array', 'https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/', 'https://tuf.com/plus/find-minimum-in-rotated-sorted-array', 'Medium'),
(1, 'Binary Search Series', 'Find Peak Element', 'https://leetcode.com/problems/find-peak-element/', 'https://tuf.com/plus/find-peak-element', 'Medium'),
(1, 'Binary Search Series', 'Square Root of a number (Binary Search)', 'https://leetcode.com/problems/sqrtx/', 'https://tuf.com/plus/square-root-binary-search', 'Easy'),
(1, 'Binary Search Series', 'Nth root of a number (Binary Search)', 'https://www.geeksforgeeks.org/find-n-th-root-of-a-number-using-binary-search/', 'https://tuf.com/plus/nth-root-binary-search', 'Medium'),
(1, 'Binary Search Series', 'Koko Eating Bananas', 'https://leetcode.com/problems/koko-eating-bananas/', 'https://tuf.com/plus/koko-eating-bananas', 'Medium'),
(1, 'Binary Search Series', 'Minimum days to make M bouquets', 'https://leetcode.com/problems/minimum-days-to-make-m-bouquets/', 'https://tuf.com/plus/min-days-m-bouquets', 'Medium'),
(1, 'Binary Search Series', 'Find the Smallest Divisor Given a Threshold', 'https://leetcode.com/problems/find-the-smallest-divisor-given-a-threshold/', 'https://tuf.com/plus/smallest-divisor-threshold', 'Medium'),
(1, 'Binary Search Series', 'Capacity To Ship Packages Within D Days', 'https://leetcode.com/problems/capacity-to-ship-packages-within-d-days/', 'https://tuf.com/plus/capacity-to-ship-packages-within-d-days', 'Medium'),
(1, 'Binary Search Series', 'Kth Missing Positive Number', 'https://leetcode.com/problems/kth-missing-positive-number/', 'https://tuf.com/plus/kth-missing-positive-number', 'Easy'),
(1, 'Binary Search Series', 'Aggressive Cows', 'https://www.spoj.com/problems/AGGRCOW/', 'https://tuf.com/plus/aggressive-cows', 'Hard'),
(1, 'Binary Search Series', 'Book Allocation Problem', 'https://www.geeksforgeeks.org/allocate-minimum-number-pages/', 'https://tuf.com/plus/book-allocation-problem', 'Hard'),
(1, 'Binary Search Series', 'Split Array Largest Sum', 'https://leetcode.com/problems/split-array-largest-sum/', 'https://tuf.com/plus/split-array-largest-sum', 'Hard'),
(1, 'Binary Search Series', 'Kth element of two sorted arrays', 'https://leetcode.com/problems/kth-smallest-element-in-a-sorted-matrix/', 'https://tuf.com/plus/kth-element-two-sorted-arrays', 'Hard'),
(1, 'Binary Search Series', 'Median of two sorted arrays', 'https://leetcode.com/problems/median-of-two-sorted-arrays/', 'https://tuf.com/plus/median-of-two-sorted-arrays', 'Hard'),
(1, 'Binary Search Series', 'Row with max 1s', 'https://www.geeksforgeeks.org/find-row-with-maximum-number-of-1s/', 'https://tuf.com/plus/row-with-max-1s', 'Easy'),
(1, 'Binary Search Series', 'Search in 2D matrix', 'https://leetcode.com/problems/search-a-2d-matrix/', 'https://tuf.com/plus/search-in-2d-matrix', 'Medium'),
(1, 'Binary Search Series', 'Search in 2D matrix II', 'https://leetcode.com/problems/search-a-2d-matrix-ii/', 'https://tuf.com/plus/search-in-a-2d-matrix-ii', 'Medium'),
(1, 'Binary Search Series', 'Peak element in 2D matrix', 'https://leetcode.com/problems/find-a-peak-element-ii/', 'https://tuf.com/plus/peak-element-in-2d-matrix', 'Medium');



ALTER TABLE `user_progress`
DROP COLUMN `is_revision`;


INSERT INTO `problems` ( `day`, `series`, `title`, `resource_free_link`, `resource_paid_link`, `difficulty`)
VALUES
( 1, 'String Series', 'Longest Palindromic Substring',
 'https://leetcode.com/problems/longest-palindromic-substring/',
 'https://www.geeksforgeeks.org/longest-palindromic-substring-set-2/',
 'Medium'),

( 1, 'String Series', 'Sum of Beauty of all substring',
 'https://leetcode.com/problems/sum-of-beauty-of-all-substrings/',
 'https://www.geeksforgeeks.org/find-sum-of-beauty-of-all-substrings-in-a-given-string/',
 'Medium'),

( 1, 'String Series', 'Reverse Every Word in A String',
 'https://leetcode.com/problems/reverse-words-in-a-string/',
 'https://www.geeksforgeeks.org/reverse-words-in-a-given-string/',
 'Easy'),

( 1, 'String Series', 'Minimum number of bracket reversals needed to make an expression balanced',
 'https://practice.geeksforgeeks.org/problems/count-the-reversals0401/1',
 'https://www.geeksforgeeks.org/minimum-number-of-bracket-reversals-needed-to-make-an-expression-balanced/',
 'Medium'),

( 1, 'String Series', 'Count and say',
 'https://leetcode.com/problems/count-and-say/',
 'https://www.geeksforgeeks.org/look-and-say-sequence/',
 'Easy'),

( 1, 'String Series', 'Hashing In Strings',
 'https://www.geeksforgeeks.org/string-hashing/',
 'https://cp-algorithms.com/string/string-hashing.html',
 'Medium'),

( 1, 'String Series', 'Remove outermost Parenthesis',
 'https://leetcode.com/problems/remove-outermost-parentheses/',
 'https://www.geeksforgeeks.org/remove-outermost-parentheses/',
 'Easy'),

( 1, 'String Series', 'Reverse words in a given string / Palindrome Check',
 'https://practice.geeksforgeeks.org/problems/reverse-words-in-a-given-string5459/1',
 'https://www.geeksforgeeks.org/check-if-a-string-is-palindrome/',
 'Easy'),

( 1, 'String Series', 'Largest odd number in a string',
 'https://leetcode.com/problems/largest-odd-number-in-string/',
 'https://www.geeksforgeeks.org/find-largest-odd-number-in-string/',
 'Easy'),

( 1, 'String Series', 'Longest Common Prefix',
 'https://leetcode.com/problems/longest-common-prefix/',
 'https://www.geeksforgeeks.org/longest-common-prefix-using-trie/',
 'Easy'),

( 1, 'String Series', 'Isomorphic String',
 'https://leetcode.com/problems/isomorphic-strings/',
 'https://www.geeksforgeeks.org/check-if-two-given-strings-are-isomorphic-to-each-other/',
 'Easy'),

( 1, 'String Series', 'Check whether one string is a rotation of another',
 'https://practice.geeksforgeeks.org/problems/rotate-string-by-k/1',
 'https://www.geeksforgeeks.org/check-if-a-string-is-rotation-of-another-string/',
 'Easy'),

( 1, 'String Series', 'Check if two strings are anagram of each other',
 'https://leetcode.com/problems/valid-anagram/',
 'https://www.geeksforgeeks.org/check-whether-two-strings-are-anagram-of-each-other/',
 'Easy'),

( 1, 'String Series', 'Sort Characters by frequency',
 'https://leetcode.com/problems/sort-characters-by-frequency/',
 'https://www.geeksforgeeks.org/sort-characters-by-frequency/',
 'Medium'),

( 1, 'String Series', 'Maximum Nesting Depth of Parenthesis',
 'https://leetcode.com/problems/maximum-nesting-depth-of-the-parentheses/',
 'https://www.geeksforgeeks.org/find-maximum-depth-nested-parenthesis-expression/',
 'Easy'),

( 1, 'String Series', 'Roman Number to Integer and vice versa',
 'https://leetcode.com/problems/roman-to-integer/',
 'https://www.geeksforgeeks.org/converting-roman-numerals-decimal-lying-1-3999/',
 'Easy'),

(1, 'String Series', 'Implement Atoi',
 'https://leetcode.com/problems/string-to-integer-atoi/',
 'https://www.geeksforgeeks.org/write-your-own-atoi/',
 'Medium'),

(1, 'String Series', 'Rabin Karp',
 'https://www.geeksforgeeks.org/rabin-karp-algorithm-for-pattern-searching/',
 'https://cp-algorithms.com/string/rabin-karp.html',
 'Hard'),

( 1, 'String Series', 'Z-Function',
 'https://www.geeksforgeeks.org/z-algorithm-linear-time-pattern-searching-algorithm/',
 'https://cp-algorithms.com/string/z-function.html',
 'Hard'),

( 1, 'String Series', 'KMP algo / LPS(pi) array',
 'https://leetcode.com/problems/implement-strstr/',
 'https://www.geeksforgeeks.org/kmp-algorithm-for-pattern-searching/',
 'Hard'),

( 1, 'String Series', 'Shortest Palindrome',
 'https://leetcode.com/problems/shortest-palindrome/',
 'https://www.geeksforgeeks.org/make-string-palindrome-adding-characters-front/',
 'Hard'),

(1, 'String Series', 'Longest happy prefix',
 'https://leetcode.com/problems/longest-happy-prefix/',
 'https://www.geeksforgeeks.org/find-longest-prefix-which-is-also-suffix/',
 'Medium'),

( 1, 'String Series', 'Count palindromic subsequence in given string',
 'https://www.geeksforgeeks.org/count-palindromic-subsequence-given-string/',
 'https://practice.geeksforgeeks.org/problems/count-palindromic-subsequences/1',
 'Hard');
 
DELETE FROM problems
WHERE series = 'String Series';

SELECT * FROM problems;

INSERT INTO problems (day, series, title, resource_free_link, resource_paid_link, difficulty)
VALUES
(1, 'Array Series', 'Find Largest Element in an Array', 'https://www.geeksforgeeks.org/find-largest-element-in-an-array/', NULL, 'Easy'),
(2, 'Array Series', 'Second Largest Element in an Array', 'https://www.geeksforgeeks.org/find-second-largest-element-in-an-array/', NULL, 'Easy'),
(3, 'Array Series', 'Check if Array is Sorted', 'https://www.geeksforgeeks.org/check-if-an-array-is-sorted-and-rotated/', NULL, 'Easy'),
(4, 'Array Series', 'Remove Duplicates from Sorted Array', 'https://leetcode.com/problems/remove-duplicates-from-sorted-array/', NULL, 'Easy'),
(5, 'Array Series', 'Left Rotate an Array by One Place', 'https://www.geeksforgeeks.org/array-rotation/', NULL, 'Easy'),
(6, 'Array Series', 'Move All Zeros to End', 'https://leetcode.com/problems/move-zeroes/', NULL, 'Easy'),
(7, 'Array Series', 'Find Union of Two Sorted Arrays', 'https://www.geeksforgeeks.org/union-and-intersection-of-two-sorted-arrays/', NULL, 'Medium'),
(8, 'Array Series', 'Kadane’s Algorithm (Maximum Subarray Sum)', 'https://leetcode.com/problems/maximum-subarray/', NULL, 'Medium'),
(9, 'Array Series', 'Longest Subarray with Sum K (positives)', 'https://www.geeksforgeeks.org/longest-subarray-with-sum-k-positive-numbers/', NULL, 'Medium'),
(10, 'Array Series', 'Two Sum Problem', 'https://leetcode.com/problems/two-sum/', NULL, 'Medium'),
(11, 'Array Series', 'Sort 0s, 1s, and 2s (Dutch Flag)', 'https://leetcode.com/problems/sort-colors/', NULL, 'Medium'),
(12, 'Array Series', 'Rotate Array by k', 'https://leetcode.com/problems/rotate-array/', NULL, 'Medium'),
(13, 'Array Series', 'Check if Array is Palindrome', 'https://www.geeksforgeeks.org/check-if-an-array-is-palindrome/', NULL, 'Medium'),
(14, 'Array Series', 'Missing Number 0 to n', 'https://leetcode.com/problems/missing-number/', NULL, 'Medium'),
(15, 'Array Series', 'Count Inversions in an Array', 'https://www.geeksforgeeks.org/counting-inversions/', NULL, 'Hard'),
(16, 'Array Series', 'Merge Two Sorted Arrays Without Extra Space', 'https://www.geeksforgeeks.org/merge-two-sorted-arrays-without-extra-space-iterator-swap/', NULL, 'Hard'),
(17, 'Array Series', 'Maximum Product Subarray', 'https://leetcode.com/problems/maximum-product-subarray/', NULL, 'Hard'),
(18, 'Array Series', 'Subarray Sum Equals K (with negatives)', 'https://leetcode.com/problems/subarray-sum-equals-k/', NULL, 'Hard'),
(19, 'Array Series', 'Next Permutation', 'https://leetcode.com/problems/next-permutation/', NULL, 'Hard'),
(20, 'Array Series', 'Leaders in Array', 'https://www.geeksforgeeks.org/leaders-in-an-array/', NULL, 'Medium');


INSERT INTO problems (day, series, title, resource_free_link, resource_paid_link, difficulty)
VALUES
(1, 'Linked List Series', 'Print Middle of Linked List', 'https://leetcode.com/problems/middle-of-the-linked-list/', NULL, 'Easy'),
(2, 'Linked List Series', 'Reverse a Linked List', 'https://leetcode.com/problems/reverse-linked-list/', NULL, 'Easy'),
(3, 'Linked List Series', 'Rotate a Linked List', 'https://leetcode.com/problems/rotate-list/', NULL, 'Medium'),
(4, 'Linked List Series', 'Delete Nth Node from End', 'https://leetcode.com/problems/nth-node-from-end-of-list/', NULL, 'Easy'),
(5, 'Linked List Series', 'Detect Loop in Linked List', 'https://leetcode.com/problems/linked-list-cycle/', NULL, 'Easy'),
(6, 'Linked List Series', 'Delete Middle Node in Linked List', 'https://leetcode.com/problems/delete-the-middle-node-of-a-linked-list/', NULL, 'Easy'),
(7, 'Linked List Series', 'Reverse Nodes in k‑Group', 'https://leetcode.com/problems/reverse-nodes-in-k-group/', NULL, 'Medium'),
(8, 'Linked List Series', 'Merge Two Sorted Lists', 'https://leetcode.com/problems/merge-two-sorted-lists/', NULL, 'Easy'),
(9, 'Linked List Series', 'Check Palindrome Linked List', 'https://leetcode.com/problems/palindrome-linked-list/', NULL, 'Medium'),
(10, 'Linked List Series', 'Intersection of Two Linked Lists', 'https://leetcode.com/problems/intersection-of-two-linked-lists/', NULL, 'Medium');


INSERT INTO problems (day, series, title, resource_free_link, resource_paid_link, difficulty)
VALUES
(1, 'Stack and Queue Series', 'Implement Stack Using Array or List', 'https://www.geeksforgeeks.org/stack-data-structure/', NULL, 'Easy'),
(2, 'Stack and Queue Series', 'Evaluate Reverse Polish Notation (Postfix Expression)', 'https://leetcode.com/problems/evaluate-reverse-polish-notation/', NULL, 'Medium'),
(3, 'Stack and Queue Series', 'Next Greater Element I', 'https://leetcode.com/problems/next-greater-element-i/', NULL, 'Medium'),
(4, 'Stack and Queue Series', 'Next Greater Element II', 'https://leetcode.com/problems/next-greater-element-ii/', NULL, 'Medium'),
(5, 'Stack and Queue Series', 'Valid Parentheses', 'https://leetcode.com/problems/valid-parentheses/', NULL, 'Easy'),
(6, 'Stack and Queue Series', 'Min Stack', 'https://leetcode.com/problems/min-stack/', NULL, 'Easy'),
(7, 'Stack and Queue Series', 'Design Circular Queue', 'https://leetcode.com/problems/design-circular-queue/', NULL, 'Medium'),
(8, 'Stack and Queue Series', 'Sliding Window Maximum (Deque technique)', 'https://leetcode.com/problems/sliding-window-maximum/', NULL, 'Hard'),
(9, 'Stack and Queue Series', 'Days with Temperatures (Monotonic Stack)', 'https://leetcode.com/problems/daily-temperatures/', NULL, 'Medium'),
(10, 'Stack and Queue Series', 'Implement Queue Using Stacks', 'https://leetcode.com/problems/implement-queue-using-stacks/', NULL, 'Medium');

INSERT INTO problems (day, series, title, resource_free_link, resource_paid_link, difficulty)
VALUES
(1, 'Recursion Series', 'Print 1 to N using recursion', 'https://www.geeksforgeeks.org/print-numbers-from-1-to-n-using-recursion/', NULL, 'Easy'),
(2, 'Recursion Series', 'Print all subsequences of a string', 'https://leetcode.com/problems/subsets/', NULL, 'Medium'),
(3, 'Recursion Series', 'Generate parentheses (Valid Combinations)', 'https://leetcode.com/problems/generate-parentheses/', NULL, 'Medium'),
(4, 'Recursion Series', 'Solve N‑Queens problem', 'https://leetcode.com/problems/n-queens/', NULL, 'Hard'),
(5, 'Recursion Series', 'Subset Sum (count subsets with sum K)', 'https://www.geeksforgeeks.org/count-number-of-ways-to-reach-given-score-in-a-game/', NULL, 'Medium');


INSERT INTO problems (day, series, title, resource_free_link, resource_paid_link, difficulty)
VALUES
(1, 'Tree Series', 'Binary Tree Inorder Traversal', 'https://leetcode.com/problems/binary-tree-inorder-traversal/', NULL, 'Easy'),
(2, 'Tree Series', 'Validate Binary Search Tree', 'https://leetcode.com/problems/validate-binary-search-tree/', NULL, 'Medium'),
(3, 'Tree Series', 'Tree Diameter', 'https://leetcode.com/problems/diameter-of-binary-tree/', NULL, 'Medium'),
(4, 'Tree Series', 'Lowest Common Ancestor in BST', 'https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-search-tree/', NULL, 'Easy'),
(5, 'Tree Series', 'Serialize and Deserialize Binary Tree', 'https://leetcode.com/problems/serialize-and-deserialize-binary-tree/', NULL, 'Hard');


INSERT INTO problems (day, series, title, resource_free_link, resource_paid_link, difficulty)
VALUES
(1, 'Graph Series', 'Number of Islands', 'https://leetcode.com/problems/number-of-islands/', NULL, 'Medium'),
(2, 'Graph Series', 'Course Schedule (Detect Cycle in Directed Graph)', 'https://leetcode.com/problems/course-schedule/', NULL, 'Medium'),
(3, 'Graph Series', 'Find Graph Valid Tree', 'https://leetcode.com/problems/graph-valid-tree/', NULL, 'Medium'),
(4, 'Graph Series', 'Clone Graph', 'https://leetcode.com/problems/clone-graph/', NULL, 'Medium'),
(5, 'Graph Series', 'Word Ladder (Shortest Path BFS)', 'https://leetcode.com/problems/word-ladder/', NULL, 'Hard');

INSERT INTO problems (day, series, title, resource_free_link, resource_paid_link, difficulty)
VALUES
(1, 'DP Series', 'Climbing Stairs (Fibonacci style)', 'https://leetcode.com/problems/climbing-stairs/', NULL, 'Easy'),
(2, 'DP Series', 'Longest Increasing Subsequence', 'https://leetcode.com/problems/longest-increasing-subsequence/', NULL, 'Medium'),
(3, 'DP Series', '0/1 Knapsack', 'https://www.geeksforgeeks.org/0-1-knapsack-problem-dp-10/', NULL, 'Medium'),
(4, 'DP Series', 'Coin Change (Minimum Coins)', 'https://leetcode.com/problems/coin-change/', NULL, 'Medium'),
(5, 'DP Series', 'Longest Common Subsequence', 'https://leetcode.com/problems/longest-common-subsequence/', NULL, 'Medium');






















-- -----------------------------------------------------
-- Table `courses`
-- Represents a paid course (e.g., "Advanced Algorithms Course")
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `courses` (
  `course_id` INT NOT NULL AUTO_INCREMENT,
  `course_name` VARCHAR(255) NOT NULL UNIQUE,
  `description` TEXT NULL,
  `price` DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Price of the course
  `is_published` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`course_id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `modules`
-- Represents a module within a course (e.g., "Graph Algorithms" in "Advanced Algorithms Course")
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modules` (
  `module_id` INT NOT NULL AUTO_INCREMENT,
  `course_id` INT NOT NULL,
  `module_name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `module_order` INT NOT NULL COMMENT 'Order of modules within a course',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`module_id`),
  UNIQUE INDEX `uq_module_course_order` (`course_id` ASC, `module_order` ASC) VISIBLE, -- Ensures unique order per course
  CONSTRAINT `fk_module_course`
    FOREIGN KEY (`course_id`)
    REFERENCES `courses` (`course_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `lessons`
-- Represents a lesson within a module (e.g., "Dijkstra's Algorithm" lesson)
-- This is where video/PDF links will be stored.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lessons` (
  `lesson_id` INT NOT NULL AUTO_INCREMENT,
  `module_id` INT NOT NULL,
  `lesson_name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `video_url` VARCHAR(500) NULL COMMENT 'URL to Google Drive video or YouTube',
  `pdf_url` VARCHAR(500) NULL COMMENT 'URL to Google Drive PDF notes',
  `lesson_order` INT NOT NULL COMMENT 'Order of lessons within a module',
  `is_premium_content` BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'True if this specific lesson requires course enrollment/payment',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`lesson_id`),
  UNIQUE INDEX `uq_lesson_module_order` (`module_id` ASC, `lesson_order` ASC) VISIBLE, -- Ensures unique order per module
  CONSTRAINT `fk_lesson_module`
    FOREIGN KEY (`module_id`)
    REFERENCES `modules` (`module_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `user_enrollments`
-- Tracks which user is enrolled in which course
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_enrollments` (
  `enrollment_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `enrollment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Indicates if enrollment is currently active',
  PRIMARY KEY (`enrollment_id`),
  UNIQUE INDEX `uq_user_course_enrollment` (`user_id` ASC, `course_id` ASC) VISIBLE, -- Ensures user can enroll only once per course
  CONSTRAINT `fk_enrollment_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_enrollment_course`
    FOREIGN KEY (`course_id`)
    REFERENCES `courses` (`course_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Optional: Add some sample course data for testing
INSERT INTO `courses` (`course_name`, `description`, `price`, `is_published`) VALUES
('GATE CS Fundamentals', 'Core Computer Science subjects for GATE exam.', 79.99, TRUE),
('Web Dev Basics', 'Introduction to HTML, CSS, JavaScript.', 0.00, TRUE); -- Free course example

INSERT INTO `modules` (`course_id`, `module_name`, `module_order`) VALUES
((SELECT course_id FROM `courses` WHERE course_name = 'GATE CS Fundamentals'), 'Operating Systems', 1),
((SELECT course_id FROM `courses` WHERE course_name = 'GATE CS Fundamentals'), 'Computer Networks', 2),
((SELECT course_id FROM `courses` WHERE course_name = 'GATE CS Fundamentals'), 'COA', 3);


-- https://drive.google.com/drive/folders/1R5J-nZtouQ1eB_Uu8DcX54Qt_5HwhH6h?usp=drive_link
SET @gate_os_module_id = (SELECT module_id FROM `modules` WHERE module_name = 'Operating Systems' AND course_id = (SELECT course_id FROM `courses` WHERE course_name = 'GATE CS Fundamentals'));
SET @gate_cn_module_id = (SELECT module_id FROM `modules` WHERE module_name = 'Computer Networks' AND course_id = (SELECT course_id FROM `courses` WHERE course_name = 'GATE CS Fundamentals'));
SET @gate_coa_module_id = (SELECT module_id FROM `modules` WHERE module_name = 'COA' AND course_id = (SELECT course_id FROM `courses` WHERE course_name = 'GATE CS Fundamentals'));


INSERT INTO `lessons` (`module_id`, `lesson_name`, `description`, `video_url`, `pdf_url`, `lesson_order`, `is_premium_content`) VALUES
-- Lessons for Operating Systems Module
(@gate_coa_module_id, 'COA - Introduction to COA', 'COA',
 'https://drive.google.com/drive/folders/1R5J-nZtouQ1eB_Uu8DcX54Qt_5HwhH6h?usp=drive_link', 'https://drive.google.com/drive/folders/1Blfv-H9lWk1ldq2SXT0oDKjbnzBY0d2-?usp=drive_link', 1, FALSE), -- Example Free Lesson
(@gate_os_module_id, 'OS - Process Management', 'Understanding processes, threads, and scheduling.',
 'YOUR_GOOGLE_DRIVE_VIDEO_LINK_FOR_PROCESS_MGMT', 'YOUR_GOOGLE_DRIVE_PDF_LINK_FOR_PROCESS_MGMT', 2, TRUE), -- Example Premium Lesson
(@gate_os_module_id, 'OS - Memory Management', 'Virtual memory, paging, segmentation.',
 'YOUR_GOOGLE_DRIVE_VIDEO_LINK_FOR_MEMORY_MGMT', 'YOUR_GOOGLE_DRIVE_PDF_LINK_FOR_MEMORY_MGMT', 3, TRUE),

-- Lessons for Computer Networks Module
(@gate_cn_module_id, 'CN - OSI Model', 'Layers of the OSI Model and their functions.',
 'YOUR_GOOGLE_DRIVE_VIDEO_LINK_FOR_OSI_MODEL', 'YOUR_GOOGLE_DRIVE_PDF_LINK_FOR_OSI_MODEL', 1, TRUE),
(@gate_cn_module_id, 'CN - TCP/IP Protocol Suite', 'Details of TCP/IP and its components.',
 'YOUR_GOOGLE_DRIVE_VIDEO_LINK_FOR_TCPIP', 'YOUR_GOOGLE_DRIVE_PDF_LINK_FOR_TCPIP', 2, TRUE);
 

-- Example: Update a specific lesson with your actual embeddable links
UPDATE `lessons`
SET
  `video_url` = 'https://drive.google.com/file/d/11hFU3q6khmb_wNkKLs6j3P3FG-4zMsSb/view?usp=drive_link',
  `pdf_url` = 'YOUR_ACTUAL_GOOGLE_DRIVE_EMBED_PDF_LINK_FOR_OS_INTRO'
WHERE `lesson_name` = 'OS - Introduction to OS' AND `module_id` = (SELECT module_id FROM `modules` WHERE module_name = 'Operating Systems' AND course_id = (SELECT course_id FROM `courses` WHERE course_name = 'GATE CS Fundamentals'));

-- Repeat similar UPDATE statements for all your lessons, replacing the names and URLs.
-- Be very careful with the WHERE clause to update the correct lesson!




INSERT INTO problems (day, title, resource_free_link, resource_paid_link, difficulty)
VALUES
(1, 'Second Largest Element', 'https://www.geeksforgeeks.org/find-second-largest-element-in-an-array/', NULL, 'Easy'),
(2, 'Third Largest Element', 'https://www.geeksforgeeks.org/find-third-largest-element-array/', NULL, 'Easy'),
(3, 'Three Great Candidates', 'https://www.geeksforgeeks.org/three-largest-elements-in-an-array/', NULL, 'Easy'),
(4, 'Max Consecutive Ones', 'https://leetcode.com/problems/max-consecutive-ones/', NULL, 'Easy'),
(5, 'Move All Zeroes To End', 'https://leetcode.com/problems/move-zeroes/', NULL, 'Easy'),
(6, 'Reverse Array in Groups', 'https://practice.geeksforgeeks.org/problems/reverse-array-in-groups-1587115621/1', NULL, 'Easy'),
(7, 'Rotate Array', 'https://leetcode.com/problems/rotate-array/', NULL, 'Easy'),
(8, 'Wave Array', 'https://www.geeksforgeeks.org/sort-array-wave-form-2/', NULL, 'Easy'),
(9, 'Plus One', 'https://leetcode.com/problems/plus-one/', NULL, 'Easy'),
(10, 'Stock Buy and Sell – One Transaction', 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock/', NULL, 'Easy'),
(11, 'Remove Duplicates from Sorted Array', 'https://leetcode.com/problems/remove-duplicates-from-sorted-array/', NULL, 'Easy'),
(12, 'Array Leaders', 'https://www.geeksforgeeks.org/leaders-in-an-array/', NULL, 'Easy'),
(13, 'Missing and Repeating in Array', 'https://www.geeksforgeeks.org/find-missing-and-repeating-in-an-array/', NULL, 'Easy'),
(14, 'Next Permutation', 'https://leetcode.com/problems/next-permutation/', NULL, 'Medium'),
(15, 'Majority Element', 'https://leetcode.com/problems/majority-element/', NULL, 'Medium'),
(16, 'Majority Element II', 'https://leetcode.com/problems/majority-element-ii/', NULL, 'Medium'),
(17, 'Stock Buy and Sell – Multiple Transactions', 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock-ii/', NULL, 'Medium'),
(18, 'Maximum Subarray Sum (Kadane)', 'https://leetcode.com/problems/maximum-subarray/', NULL, 'Medium'),
(19, 'Maximum Product Subarray', 'https://leetcode.com/problems/maximum-product-subarray/', NULL, 'Medium'),
(20, 'Product of Array Except Self', 'https://leetcode.com/problems/product-of-array-except-self/', NULL, 'Medium'),
(21, 'Subarrays with Product Less Than K', 'https://leetcode.com/problems/subarray-product-less-than-k/', NULL, 'Medium'),
(22, 'Split Into Three Equal Sum Segments', 'https://www.geeksforgeeks.org/split-array-three-parts-equal-sum/', NULL, 'Medium'),
(23, 'Minimum Swaps To Group All Ones', 'https://leetcode.com/problems/minimum-swaps-to-group-all-ones/', NULL, 'Medium'),
(24, 'Count Inversions', 'https://www.geeksforgeeks.org/counting-inversions/', NULL, 'Hard'),
(25, 'Trapping Rain Water', 'https://leetcode.com/problems/trapping-rain-water/', NULL, 'Hard'),
(26, 'Maximum Circular Subarray Sum', 'https://practice.geeksforgeeks.org/problems/maximum-subarray-in-circular-array/1', NULL, 'Hard'),
(27, 'Smallest Missing Positive Number', 'https://leetcode.com/problems/first-missing-positive/', NULL, 'Hard'),
(28, 'Jump Game', 'https://leetcode.com/problems/jump-game/', NULL, 'Medium'),
(29, 'Closest Subsequence Sum', 'https://leetcode.com/problems/subarray-sum-closest-to-k/', NULL, 'Hard'),
(30, 'Candy Distribution', 'https://practice.geeksforgeeks.org/problems/candy-distribution/0', NULL, 'Medium'),
(31, 'Count Subarrays with K Distinct Elements', 'https://leetcode.com/problems/subarrays-with-k-distinct-elements/', NULL, 'Hard'),
(32, 'Next Smallest Palindrome', 'https://practice.geeksforgeeks.org/problems/next-smallest-palindrome/0', NULL, 'Hard'),
(33, 'Smallest Non-Representable Sum', 'https://www.geeksforgeeks.org/find-smallest-value-represented-sum-subset-numbers/', NULL, 'Hard'),
(34, 'Smallest Range Having Elements From K Lists', 'https://leetcode.com/problems/smallest-range-covering-elements-from-k-lists/', NULL, 'Hard'),
(35, 'Maximum Sum Among All Rotations', 'https://practice.geeksforgeeks.org/problems/maximum-sum-rotation/1', NULL, 'Medium'),
(36, 'Subarray with Given Sum', 'https://leetcode.com/problems/subarray-sum/', NULL, 'Easy'),
(37, 'Rearrange Array Elements by Sign', 'https://leetcode.com/problems/rearrange-array-elements-by-sign/', NULL, 'Easy'),
(38, 'Meeting Scheduler for Two Persons', 'https://leetcode.com/problems/meeting-scheduler/', NULL, 'Easy'),
(39, 'Longest Mountain Subarray', 'https://leetcode.com/problems/longest-mountain-in-array/', NULL, 'Hard'),
(40, 'Transform and Sort Array', 'https://leetcode.com/problems/transform-the-array/', NULL, 'Medium'),
(41, 'Minimum Moves To Equalize Array', 'https://leetcode.com/problems/minimum-moves-to-equal-array-elements/', NULL, 'Medium'),
(42, 'Minimum Indices To Equal Even‑Odd Sums', 'https://leetcode.com/problems/minimum-indexes-to-equal-even-and-odd-sums/', NULL, 'Medium'),
(43, 'Leaders in an Array', 'https://www.geeksforgeeks.org/leaders-in-an-array/', NULL, 'Easy'),
(44, 'Unique Number I', 'https://www.geeksforgeeks.org/find-the-element-occurring-once/', NULL, 'Easy'),
(45, 'Three Sum (Triplet Sum)', 'https://leetcode.com/problems/3sum/', NULL, 'Medium'),
(46, 'Equilibrium Index', 'https://www.geeksforgeeks.org/equilibrium-index-of-an-array/', NULL, 'Easy'),
(47, 'Merge Two Sorted Arrays Without Extra Space', 'https://practice.geeksforgeeks.org/problems/merge-two-sorted-arrays/0', NULL, 'Easy'),
(48, 'Two Pointers Technique', 'https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/', NULL, 'Easy'),
(49, 'Smallest subarray with sum greater than a given value', 'https://practice.geeksforgeeks.org/problems/smallest-subarray-with-sum-greater-than-x/0', NULL, 'Medium'),
(50, 'Reorder Array According to Given Indexes', 'https://www.geeksforgeeks.org/reorder-array-given-indexes/', NULL, 'Easy');

