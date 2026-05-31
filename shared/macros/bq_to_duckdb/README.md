# BQ → DuckDB macro shims

Wire generates BigQuery-targeted SQL. DuckDB is broadly compatible, but a small number of BQ-specific functions need shimming for dbt models to run unchanged against the bundled DuckDB warehouse.

Each `.sql` file in this folder is a dbt macro that wraps DuckDB's equivalent in a name matching BQ's, so the dbt models written for BQ run unchanged.

| BQ function | DuckDB equivalent | Macro file |
|---|---|---|
| `safe_cast(x AS type)` | `try_cast(x AS type)` | `safe_cast.sql` |
| `current_timestamp()` | `now()` | `current_timestamp.sql` |
| `date_diff(d1, d2, day)` | `(d1 - d2)::integer` | `date_diff.sql` |
| `parse_json(str)` | `json(str)` | `parse_json.sql` |
| `to_json_string(obj)` | `cast(obj AS json)::varchar` | `to_json_string.sql` |
| `generate_uuid()` | `uuid()` | `generate_uuid.sql` |

## Unsupported BQ patterns

Documented for transparency — these will NOT work in the demos and should not appear in any Wire-generated model the demos exercise:

- `ML.*` (BigQuery ML)
- Geospatial functions (`ST_*`)
- `_TABLE_SUFFIX` / wildcard table queries
- `INFORMATION_SCHEMA.*` (DuckDB has its own catalog views)

If a demo run produces a model using any of these, that's a real bug worth fixing in either the demo seed data shape or the relevant Wire spec.
