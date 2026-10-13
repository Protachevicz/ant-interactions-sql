-- Schema for ant interaction network data (DataDryad "Ciclos_Ant" dataset).
-- One row per detected pairwise interaction between two tagged ants.

CREATE TABLE IF NOT EXISTS interactions (
    interaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag1           INTEGER NOT NULL,   -- RFID/tag id of ant 1
    tag2           INTEGER NOT NULL,   -- RFID/tag id of ant 2
    start_frame    INTEGER NOT NULL,
    stop_frame     INTEGER NOT NULL,
    start_time     REAL    NOT NULL,   -- unix timestamp (seconds)
    stop_time      REAL    NOT NULL,   -- unix timestamp (seconds)
    x1             REAL    NOT NULL,   -- ant 1 position at interaction start
    y1             REAL    NOT NULL,
    angle1         REAL    NOT NULL,   -- ant 1 heading, degrees
    x2             REAL    NOT NULL,   -- ant 2 position at interaction start
    y2             REAL    NOT NULL,
    angle2         REAL    NOT NULL    -- ant 2 heading, degrees
);

CREATE INDEX IF NOT EXISTS idx_interactions_tag1 ON interactions (tag1);
CREATE INDEX IF NOT EXISTS idx_interactions_tag2 ON interactions (tag2);
CREATE INDEX IF NOT EXISTS idx_interactions_start_time ON interactions (start_time);

-- Convenience view: each interaction listed once per participating ant,
-- so "which ants did X interact with" queries don't need tag1/tag2 unions.
CREATE VIEW IF NOT EXISTS interactions_by_ant AS
    SELECT interaction_id, tag1 AS ant_tag, tag2 AS other_tag,
           start_frame, stop_frame, start_time, stop_time,
           x1 AS x, y1 AS y, angle1 AS angle
    FROM interactions
    UNION ALL
    SELECT interaction_id, tag2 AS ant_tag, tag1 AS other_tag,
           start_frame, stop_frame, start_time, stop_time,
           x2 AS x, y2 AS y, angle2 AS angle
    FROM interactions;
