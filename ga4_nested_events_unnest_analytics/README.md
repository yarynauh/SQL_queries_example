# GA4 Event Params Analysis using BigQuery UNNEST

## Project Overview

This project demonstrates advanced techniques for querying semi-structured, nested data structures in Google BigQuery (typical for GA4 / event-tracking schemas). The goal was to unpack repeated record fields (`event_params`) and aggregate page title metrics across geographical continents.

## Key Technical Highlights

* **Working with Nested Fields:** Applied the `UNNEST()` function to flatten repeated ARRAY/RECORD structures within event logs.
* **Conditional String Aggregation:** Combined conditional logic (`CASE WHEN`) with string manipulation functions (`STRPOS`, `LOWER`) to filter and match specific parameter keys (`page_title`) and values.
* **Conversion Rate Metrics:** Calculated percentage shares of specific user interactions relative to total event volumes per continent.

## Technical Requirements

* **Database:** Google BigQuery
* **Functions Used:** `UNNEST`, `STRPOS`, `LOWER`, `SUM(CASE ...)`, `GROUP BY`

## Result

<img width="326" height="165" alt="image" src="https://github.com/user-attachments/assets/34da178d-35a1-46b6-bba9-c620ad21b0a5" />


---
**SQL Query File:** Check `query.sql` in this directory for the full implementation.
