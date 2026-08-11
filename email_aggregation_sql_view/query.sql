CREATE VIEW aggregation_data AS
WITH sent_data AS (
SELECT
      es.id_account,
      es.id_message,
      DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS full_sent_day,
      DATE_TRUNC(DATE_ADD(s.date, INTERVAL es.sent_date DAY), MONTH)
        AS sent_month
    FROM `data-analytics-mate.DA.email_sent` AS es
    JOIN `data-analytics-mate.DA.account_session` AS acs
      ON es.id_account = acs.account_id
    JOIN `data-analytics-mate.DA.session` AS s
      ON acs.ga_session_id = s.ga_session_id
),
account_agregates AS (
SELECT
    id_account,
    sent_month,
    COUNT(id_message) AS account_month_cnt,
    MIN(full_sent_day) AS first_sent_date,
    MAX(full_sent_day) AS last_sent_date
    FROM sent_data
    GROUP BY sent_month, id_account
),
total_monthly_cnt AS (
SELECT
    sent_month,
    SUM(account_month_cnt) AS total_month_cnt
FROM account_agregates
GROUP BY sent_month
)
SELECT
    tmc.sent_month,
    id_account,
    account_month_cnt / total_month_cnt * 100 AS sent_msg_percent_from_this_month,
    first_sent_date,
    last_sent_date
FROM total_monthly_cnt AS tmc
JOIN account_agregates AS aa
ON tmc.sent_month = aa.sent_month;
