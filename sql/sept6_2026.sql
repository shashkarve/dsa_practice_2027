-- users
--   user_id      BIGINT
--   signup_date  DATE        -- the day the account was created

-- events
--   event_id     BIGINT
--   user_id      BIGINT
--   event_type   VARCHAR     -- 'play', 'pause', 'search', 'login', ...
--   event_ts     TIMESTAMP   -- when the event happened (UTC)

-- The question
-- Write a query that returns, for each signup cohort month (the month a user
-- signed up), the retention in Week 0, Week 1, Week 2, and Week 3 after signup.

-- Retention for a given cohort in week N = the fraction of users in that cohort
-- who had at least one event in the time window `[signup_date + 7*N days,
-- signup_date + 7*(N+1) days)`.

-- Expected output shape
-- text
-- cohort_month | week_0_retention | week_1_retention | week_2_retention | week_3_retention
-- -------------|------------------|------------------|------------------|------------------
-- 2025-01      | 0.92             | 0.41             | 0.28             | 0.19
-- 2025-02      | ...


-- Incorrect try...
SELECT 
    CONCAT(EXTRACT(YEAR FROM users.signup_date), "-", EXTRACT(MONTH FROM users.signup_date)) as 'cohort_month',
    ROUND(SUM(CASE WHEN event.event_ts >= users.signup_date AND event.event_ts <= users.signup_date + INTERVAL '7 days'
    THEN 1 ELSE 0 
    END) * 100/COUNT(CASE WHEN event.event_ts >= users.signup_date AND event.event_ts <= users.signup_date + INTERVAL '7 days'
    THEN 1 ELSE 0 
    END), 2) as 'week_0_retention',
    ROUND(SUM(CASE WHEN event.event_ts >= users.signup_date + INTERVAL '7 days' AND event.event_ts <= users.signup_date + INTERVAL '14 days'
    THEN 1 ELSE 0 
    END) * 100/COUNT(CASE WHEN event.event_ts >= users.signup_date + INTERVAL '7 days' AND event.event_ts <= users.signup_date + INTERVAL '14 days'
    THEN 1 ELSE 0 
    END), 2) as 'week_1_retention',
    ROUND(SUM(CASE WHEN event.event_ts >= users.signup_date + INTERVAL '14 days' AND event.event_ts <= users.signup_date + INTERVAL '21 days'
    THEN 1 ELSE 0 
    END) * 100/COUNT(CASE WHEN event.event_ts >= users.signup_date + INTERVAL '14 days' AND event.event_ts <= users.signup_date + INTERVAL '21 days'
    THEN 1 ELSE 0 
    END), 2) as 'week_2_retention',
    ROUND(SUM(CASE WHEN event.event_ts >= users.signup_date + INTERVAL '21 days' AND event.event_ts <= users.signup_date + INTERVAL '28 days'
    THEN 1 ELSE 0 
    END) * 100/COUNT(CASE WHEN event.event_ts >= users.signup_date + INTERVAL '21 days' AND event.event_ts <= users.signup_date + INTERVAL '28 days'
    THEN 1 ELSE 0 
    END), 2) as 'week_3_retention'
FROM users 
LEFT JOIN events
GROUP BY CONCAT(EXTRACT(YEAR FROM users.signup_date), "-", EXTRACT(MONTH FROM users.signup_date))
ORDER BY CONCAT(EXTRACT(YEAR FROM users.signup_date), "-", EXTRACT(MONTH FROM users.signup_date)) 


--correct ans:-
WITH per_user_flags AS (
    SELECT
        u.user_id,
        DATE_TRUNC('month', u.signup_date) AS cohort_month,
        MAX(CASE WHEN e.event_ts >= u.signup_date
                  AND e.event_ts <  u.signup_date + INTERVAL '7 days'
                 THEN 1 ELSE 0 END) AS w0,
        MAX(CASE WHEN e.event_ts >= u.signup_date + INTERVAL '7 days'
                  AND e.event_ts <  u.signup_date + INTERVAL '14 days'
                 THEN 1 ELSE 0 END) AS w1,
        MAX(CASE WHEN e.event_ts >= u.signup_date + INTERVAL '14 days'
                  AND e.event_ts <  u.signup_date + INTERVAL '21 days'
                 THEN 1 ELSE 0 END) AS w2,
        MAX(CASE WHEN e.event_ts >= u.signup_date + INTERVAL '21 days'
                  AND e.event_ts <  u.signup_date + INTERVAL '28 days'
                 THEN 1 ELSE 0 END) AS w3
    FROM users u
    LEFT JOIN events e ON e.user_id = u.user_id
    GROUP BY u.user_id, u.signup_date
)
SELECT
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort_month,
    ROUND(AVG(w0), 2) AS week_0_retention,
    ROUND(AVG(w1), 2) AS week_1_retention,
    ROUND(AVG(w2), 2) AS week_2_retention,
    ROUND(AVG(w3), 2) AS week_3_retention
FROM per_user_flags
GROUP BY cohort_month
ORDER BY cohort_month;

--LESSONS:
-- USE MAX for checking : atleast 1 event. Helps with deduplication.
-- THE final select does avg of these max values and then rounds by 2

-- Edge cases you should have named out loud
-- At staff level, the interviewer wants to hear you volunteer these before/while coding:

-- Users with zero events ever — LEFT JOIN keeps them; their retention = 0. Handled.

-- Late-arriving / backfilled events — if the report runs before all week-3 events land, retention is understated. Note the report should only run for cohorts where the full window is in the past.

-- Exact-boundary timestamps — half-open intervals prevent double-counting at +7 days exactly.

-- Duplicate events — event_id dedup not needed here because MAX collapses to a flag, but worth stating.

-- Timezone — signup_date is a DATE but event_ts is UTC TIMESTAMP. A signup on "2025-01-01" in UTC vs local TZ can shift which events fall in week 0. Clarify whether signup_date is local or UTC.

-- Cohorts too small — a cohort with 3 users gives noisy retention. Mention you'd flag low-n cohorts.

-- Performance / scale (the staff narrative)
-- On 500M events this query:

-- Shuffle-joins on user_id — events table is huge, users is small. Push the users side as a broadcast join, or partition events by user_id/date.

-- Predicate pushdown: the window predicates filter events early — make sure the engine prunes partitions on event_ts before the join. A range predicate on event_ts enables partition pruning if events is partitioned by date.

-- Skew: power users with millions of events create hot keys in the GROUP BY user_id. Consider salting or pre-filtering events to the relevant 28-day window before the join (a huge win — you only need events within 28 days of some signup, and you can prune to a date range).

-- Materialization: if this report is weekly, don't recompute from raw events each time — maintain a daily active users aggregate table (user_id, active_date) and derive retention from it. DAU → retention is a classic staff-level "pre-aggregate" answer.
