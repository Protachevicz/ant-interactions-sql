-- Sample queries over the ant_interactions database.
-- Run with: sqlite3 ant_interactions.db < queries/sample_queries.sql

-- 1. Total number of interactions and distinct ants observed.
SELECT COUNT(*) AS total_interactions FROM interactions;
SELECT COUNT(DISTINCT ant_tag) AS distinct_ants FROM interactions_by_ant;

-- 2. Interaction duration stats (seconds).
SELECT
    MIN(stop_time - start_time) AS min_duration,
    AVG(stop_time - start_time) AS avg_duration,
    MAX(stop_time - start_time) AS max_duration
FROM interactions;

-- 3. Top 10 most socially active ants (by interaction count).
SELECT ant_tag, COUNT(*) AS n_interactions
FROM interactions_by_ant
GROUP BY ant_tag
ORDER BY n_interactions DESC
LIMIT 10;

-- 4. Most frequent interacting pairs (tag1 < tag2 avoids double counting).
SELECT
    MIN(tag1, tag2) AS ant_a,
    MAX(tag1, tag2) AS ant_b,
    COUNT(*) AS n_interactions
FROM interactions
GROUP BY ant_a, ant_b
ORDER BY n_interactions DESC
LIMIT 10;

-- 5. Interactions per minute of the observation window (activity over time).
SELECT
    CAST(start_time / 60 AS INTEGER) AS minute_bucket,
    COUNT(*) AS n_interactions
FROM interactions
GROUP BY minute_bucket
ORDER BY minute_bucket;

-- 6. All interactions involving a specific ant tag (replace 65 as needed).
SELECT * FROM interactions_by_ant WHERE ant_tag = 65 ORDER BY start_time;
