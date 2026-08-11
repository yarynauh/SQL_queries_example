# Email Campaign Performance by Operating System

## Project Overview

This query analyses email marketing efficiency metrics (**Open Rate**, **Click Rate**, and **Click-to-Open Rate / CTOR**) segmented by user operating systems.

## Key Technical Highlights

* **Marketing KPIs Calculation:** Implemented dynamic formulas for OR, CR, and CTOR with zero-division handling (`CASE WHEN ... > 0`).
* **Multi-Table Aggregation:** Consolidated user accounts, email events, and session parameters using `LEFT JOIN` and `COUNT(DISTINCT)`.
* **Filtering & Grouping:** Segmented performance by `operating_system` while filtering out unsubscribed users.

## Technical Requirements

* **Database:** BigQuery SQL
* **Functions Used:** `COUNT(DISTINCT)`, `CASE WHEN`, `LEFT JOIN`, `GROUP BY`, `ORDER BY`

## Result

<img width="816" height="224" alt="image" src="https://github.com/user-attachments/assets/ab4c2e50-8db2-4222-9e2e-652a67125106" />


---
**SQL Query File:** Check `query.sql` in this directory for the full implementation.
