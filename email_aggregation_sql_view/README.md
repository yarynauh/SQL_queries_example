# Aggregation Data with SQL View & CTEs

## Project Overview

This project demonstrates query refactoring and data modeling by building a structured **SQL View** (`CREATE VIEW`). The main technical constraint was to eliminate deep subquery nesting (avoiding multi-level nested `SELECT ... FROM (SELECT ...)`) by refactoring the pipeline into modular, readable **Common Table Expressions (CTEs)**.

## Objectives

* **Refactor Complex Logic:** Reorganize multi-step aggregations into clean, sequential CTE blocks (`WITH ... AS`).
* **Database View Creation:** Wrap the logic inside a reusable SQL View (`aggregation_data`) for reporting and downstream BI usage.
* **Monthly Metric Calculation:** Aggregate monthly email counts, calculate individual account email percentages relative to overall monthly totals, and extract account activity range boundaries (`MIN` / `MAX` sent dates).

## Technical Requirements & Key Concepts

* **Database:** BigQuery SQL
* **SQL Constructs:** `CREATE VIEW`, Common Table Expressions (CTEs), Explicit `JOIN` conditions, `GROUP BY` aggregations.
* **Subquery Nesting Avoidance:** Enforced flat query architecture by restricting nesting depth to a maximum of 1 level, improving readability and maintainability.
* **Data Granularity:** Staged calculations starting from event-level logs to account-month aggregates, followed by overall monthly totals.

## Result

<img width="464" height="344" alt="image" src="https://github.com/user-attachments/assets/3439b2dd-fed5-4513-8e1a-8a68e913a372" />


---
**SQL Query File:** Check `query.sql` in this directory to see the full code implementation.
