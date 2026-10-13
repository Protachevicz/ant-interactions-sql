# ant-interactions-sql

SQL project around a pairwise ant-interaction dataset (DataDryad "Ciclos_Ant" series).
Each record is one detected interaction between two tagged ants, with timing,
position and heading at the start of the interaction.

## Dataset

`data/interactions_filtered_col8_rep1_angpara120_timethresh10.txt` — raw
space-separated export (replicate 1, angular parallelism threshold 120°,
time threshold 10s). Columns: `Tag1 Tag2 Startframe Stopframe Starttime
Stoptime Xcoor1 Ycoor1 Angle1 Xcoor2 Ycoor2 Angle2`.

- `Tag1`/`Tag2`: RFID tag IDs of the two ants.
- `Startframe`/`Stopframe`: video frame range of the interaction.
- `Starttime`/`Stoptime`: unix timestamps (seconds).
- `Xcoor*`/`Ycoor*`: arena coordinates (pixels) at interaction start.
- `Angle*`: heading in degrees at interaction start.

## Setup

Requires Python 3 (stdlib `sqlite3` only) and the `sqlite3` CLI.

```bash
python3 scripts/load_data.py
sqlite3 ant_interactions.db < queries/sample_queries.sql
```

This creates `ant_interactions.db` with an `interactions` table (see
[schema.sql](schema.sql)) and an `interactions_by_ant` view that unpivots
each interaction into one row per participating ant.

## Project layout

```
schema.sql              -- table/view definitions
data/                   -- raw dataset
scripts/load_data.py    -- parses the raw file and loads SQLite
queries/sample_queries.sql -- example analyses (activity, pair frequency, time series)
```

## Example analyses

See [queries/sample_queries.sql](queries/sample_queries.sql) for:
- total interactions / distinct ants
- interaction duration stats
- most socially active ants
- most frequent interacting pairs
- interaction rate over time
- full interaction history for a given ant
