# Emails Sent by Month (Window Functions Analysis)

## Project Overview

This project focuses on calculating monthly email distribution metrics and account activity timelines using **Advanced SQL Window Functions**. The main objective was to perform complex analytical calculations (percentages, first/last activity dates) directly via analytical clauses **without using standard `GROUP BY` groupings**.

## Objectives

* **Monthly Email Volume Share:** Calculate the percentage of emails sent to each specific account relative to the total monthly email volume.
* **Activity Timelines:** Determine the exact dates of the first and last sent emails for each account within a given month.
* **Non-Standard Aggregation:** Perform all multi-level analytical aggregations using purely window functions (`COUNT OVER`, `MIN OVER`, `MAX OVER`).

## Technical Requirements & Key Concepts

* **Database:** BigQuery SQL
* **Window Functions:** Employed `PARTITION BY` across different granularity levels (`sent_month` vs `sent_month, id_account`) to calculate both account-level and total monthly aggregates in a single pass.
* **Date Manipulation:** Used `DATE_TRUNC` and `DATE_ADD` for dynamic month/date extraction.
* **Deduplication:** Applied `SELECT DISTINCT` to handle row duplication resulting from non-grouped window calculations.

## Result

<img width="572" height="613" alt="image" src="https://github.com/user-attachments/assets/9c1738cb-f2fb-4637-b732-264eab9add4c" />


---
**SQL Query File:** Check `query.sql` in this directory to see the full code implementation.
