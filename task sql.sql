
SELECT 
    e.event_id,
    e.title AS event_title,
    e.description,
    e.start_date,
    e.end_date
FROM 
    Events e
JOIN 
    Registrations r ON e.event_id = r.event_id
JOIN 
    Users u ON r.user_id = u.user_id
WHERE 
    u.user_id = 1 -- Replace with parameter
    AND e.city = u.city
    AND e.status = 'upcoming'
    AND e.start_date > CURRENT_DATE()
ORDER BY 
    e.start_date;


SELECT 
    e.event_id,
    e.title,
    AVG(f.rating) AS average_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM 
    Events e
JOIN 
    Feedback f ON e.event_id = f.event_id
GROUP BY 
    e.event_id, e.title
HAVING 
    COUNT(f.feedback_id) >= 10
ORDER BY 
    average_rating DESC
LIMIT 5;


SELECT 
    u.user_id,
    u.full_name,
    u.email,
    u.registration_date,
    MAX(r.registration_date) AS last_registration_date
FROM 
    Users u
LEFT JOIN 
    Registrations r ON u.user_id = r.user_id
GROUP BY 
    u.user_id, u.full_name, u.email, u.registration_date
HAVING 
    MAX(r.registration_date) IS NULL 
    OR MAX(r.registration_date) < DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY);


SELECT 
    e.event_id,
    e.title,
    COUNT(s.session_id) AS peak_hour_sessions
FROM 
    Events e
LEFT JOIN 
    Sessions s ON e.event_id = s.event_id
    AND TIME(s.start_time) BETWEEN '10:00:00' AND '12:00:00'
GROUP BY 
    e.event_id, e.title;

SELECT 
    u.city,
    COUNT(DISTINCT r.user_id) AS unique_users_registered
FROM 
    Registrations r
JOIN 
    Users u ON r.user_id = u.user_id
GROUP BY 
    u.city
ORDER BY 
    unique_users_registered DESC
LIMIT 5;


SELECT 
    e.event_id,
    e.title,
    SUM(CASE WHEN res.resource_type = 'pdf' THEN 1 ELSE 0 END) AS pdf_count,
    SUM(CASE WHEN res.resource_type = 'image' THEN 1 ELSE 0 END) AS image_count,
    SUM(CASE WHEN res.resource_type = 'link' THEN 1 ELSE 0 END) AS link_count,
    COUNT(res.resource_id) AS total_resources
FROM 
    Events e
LEFT JOIN 
    Resources res ON e.event_id = res.event_id
GROUP BY 
    e.event_id, e.title;


SELECT 
    u.user_id,
    u.full_name,
    e.event_id,
    e.title AS event_title,
    f.rating,
    f.comments,
    f.feedback_date
FROM 
    Feedback f
JOIN 
    Users u ON f.user_id = u.user_id
JOIN 
    Events e ON f.event_id = e.event_id
WHERE 
    f.rating < 3
ORDER BY 
    f.rating, f.feedback_date;

/*
=============================================
  Exercise 8: Sessions per Upcoming Event
  Upcoming events with count of scheduled sessions
=============================================
*/
SELECT 
    e.event_id,
    e.title,
    COUNT(s.session_id) AS session_count
FROM 
    Events e
LEFT JOIN 
    Sessions s ON e.event_id = s.event_id
WHERE 
    e.status = 'upcoming'
GROUP BY 
    e.event_id, e.title;

/*
=============================================
  Exercise 9: Organizer Event Summary
  For each organizer: event count by status
=============================================
*/
SELECT 
    u.user_id AS organizer_id,
    u.full_name AS organizer_name,
    SUM(CASE WHEN e.status = 'upcoming' THEN 1 ELSE 0 END) AS upcoming_events,
    SUM(CASE WHEN e.status = 'completed' THEN 1 ELSE 0 END) AS completed_events,
    SUM(CASE WHEN e.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_events,
    COUNT(e.event_id) AS total_events
FROM 
    Users u
LEFT JOIN 
    Events e ON u.user_id = e.organizer_id
GROUP BY 
    u.user_id, u.full_name;

/*
=============================================
  Exercise 10: Feedback Gap
  Events with registrations but no feedback
=============================================
*/
SELECT 
    e.event_id,
    e.title,
    COUNT(r.registration_id) AS registration_count
FROM 
    Events e
JOIN 
    Registrations r ON e.event_id = r.event_id
LEFT JOIN 
    Feedback f ON e.event_id = f.event_id
WHERE 
    f.feedback_id IS NULL
GROUP BY 
    e.event_id, e.title;

/*
=============================================
  Exercise 11: Daily New User Count
  Users registered each day in last 7 days
=============================================
*/
SELECT 
    DATE(registration_date) AS registration_day,
    COUNT(user_id) AS new_users
FROM 
    Users
WHERE 
    registration_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
GROUP BY 
    DATE(registration_date)
ORDER BY 
    registration_day DESC;

/*
=============================================
  Exercise 12: Event with Maximum Sessions
  Event(s) with highest number of sessions
=============================================
*/
SELECT 
    e.event_id,
    e.title,
    COUNT(s.session_id) AS session_count
FROM 
    Events e
JOIN 
    Sessions s ON e.event_id = s.event_id
GROUP BY 
    e.event_id, e.title
HAVING 
    COUNT(s.session_id) = (
        SELECT MAX(session_count)
        FROM (
            SELECT COUNT(session_id) AS session_count
            FROM Sessions
            GROUP BY event_id
        ) AS counts
    );

/*
=============================================
  Exercise 13: Average Rating per City
  Average feedback rating of events by city
=============================================
*/
SELECT 
    e.city,
    AVG(f.rating) AS average_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM 
    Events e
JOIN 
    Feedback f ON e.event_id = f.event_id
GROUP BY 
    e.city
ORDER BY 
    average_rating DESC;

/*
=============================================
  Exercise 14: Most Registered Events
  Top 3 events by registration count
=============================================
*/
SELECT 
    e.event_id,
    e.title,
    COUNT(r.registration_id) AS registration_count
FROM 
    Events e
JOIN 
    Registrations r ON e.event_id = r.event_id
GROUP BY 
    e.event_id, e.title
ORDER BY 
    registration_count DESC
LIMIT 3;

/*
=============================================
  Exercise 15: Event Session Time Conflict
  Overlapping sessions within the same event
=============================================
*/
SELECT 
    s1.event_id,
    e.title AS event_title,
    s1.session_id AS session1_id,
    s1.title AS session1_title,
    s1.start_time AS session1_start,
    s1.end_time AS session1_end,
    s2.session_id AS session2_id,
    s2.title AS session2_title,
    s2.start_time AS session2_start,
    s2.end_time AS session2_end
FROM 
    Sessions s1
JOIN 
    Sessions s2 ON s1.event_id = s2.event_id
    AND s1.session_id < s2.session_id
JOIN 
    Events e ON s1.event_id = e.event_id
WHERE 
    s1.start_time < s2.end_time 
    AND s1.end_time > s2.start_time;

/*
=============================================
  Exercise 16: Unregistered Active Users
  Users created in last 30 days with no event registrations
=============================================
*/
SELECT 
    u.user_id,
    u.full_name,
    u.email,
    u.registration_date
FROM 
    Users u
LEFT JOIN 
    Registrations r ON u.user_id = r.user_id
WHERE 
    u.registration_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    AND r.registration_id IS NULL;

/*
=============================================
  Exercise 17: Multi-Session Speakers
  Speakers handling more than one session
=============================================
*/
SELECT 
    speaker_name,
    COUNT(DISTINCT session_id) AS session_count,
    GROUP_CONCAT(DISTINCT e.title ORDER BY e.title SEPARATOR ', ') AS events
FROM 
    Sessions s
JOIN 
    Events e ON s.event_id = e.event_id
GROUP BY 
    speaker_name
HAVING 
    COUNT(DISTINCT session_id) > 1
ORDER BY 
    session_count DESC;

/*
=============================================
  Exercise 18: Resource Availability Check
  Events with no resources uploaded
=============================================
*/
SELECT 
    e.event_id,
    e.title
FROM 
    Events e
LEFT JOIN 
    Resources r ON e.event_id = r.event_id
WHERE 
    r.resource_id IS NULL;

/*
=============================================
  Exercise 19: Completed Events with Feedback
  Completed events with registration count and average rating
=============================================
*/
SELECT 
    e.event_id,
    e.title,
    COUNT(DISTINCT r.registration_id) AS registration_count,
    AVG(f.rating) AS average_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM 
    Events e
LEFT JOIN 
    Registrations r ON e.event_id = r.event_id
LEFT JOIN 
    Feedback f ON e.event_id = f.event_id
WHERE 
    e.status = 'completed'
GROUP BY 
    e.event_id, e.title;

/*
=============================================
  Exercise 20: User Engagement Index
  For each user: events attended and feedbacks submitted
=============================================
*/
SELECT 
    u.user_id,
    u.full_name,
    COUNT(DISTINCT r.event_id) AS events_attended,
    COUNT(DISTINCT f.feedback_id) AS feedbacks_submitted
FROM 
    Users u
LEFT JOIN 
    Registrations r ON u.user_id = r.user_id
LEFT JOIN 
    Feedback f ON u.user_id = f.user_id
GROUP BY 
    u.user_id, u.full_name
ORDER BY 
    events_attended DESC, feedbacks_submitted DESC;

/*
=============================================
  Exercise 21: Top Feedback Providers
  Top 5 users who submitted most feedback
=============================================
*/
SELECT 
    u.user_id,
    u.full_name,
    COUNT(f.feedback_id) AS feedback_count
FROM 
    Users u
JOIN 
    Feedback f ON u.user_id = f.user_id
GROUP BY 
    u.user_id, u.full_name
ORDER BY 
    feedback_count DESC
LIMIT 5;

/*
=============================================
  Exercise 22: Duplicate Registrations Check
  Users registered more than once for same event
=============================================
*/
SELECT 
    user_id,
    event_id,
    COUNT(registration_id) AS registration_count
FROM 
    Registrations
GROUP BY 
    user_id, event_id
HAVING 
    COUNT(registration_id) > 1;

/*
=============================================
  Exercise 23: Registration Trends
  Month-wise registration count over past 12 months
=============================================
*/
SELECT 
    DATE_FORMAT(registration_date, '%Y-%m') AS month,
    COUNT(registration_id) AS registration_count
FROM 
    Registrations
WHERE 
    registration_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
GROUP BY 
    DATE_FORMAT(registration_date, '%Y-%m')
ORDER BY 
    month;

/*
=============================================
  Exercise 24: Average Session Duration
  Average session duration (minutes) per event
=============================================
*/
SELECT 
    e.event_id,
    e.title,
    AVG(TIMESTAMPDIFF(MINUTE, s.start_time, s.end_time)) AS avg_duration_minutes
FROM 
    Events e
JOIN 
    Sessions s ON e.event_id = s.event_id
GROUP BY 
    e.event_id, e.title;

/*
=============================================
  Exercise 25: Events Without Sessions
  Events with no sessions scheduled
=============================================
*/
SELECT 
    e.event_id,
    e.title
FROM 
    Events e
LEFT JOIN 
    Sessions s ON e.event_id = s.event_id
WHERE 
    s.session_id IS NULL;