SELECT DISTINCT
sent_month,
id_account,
sent_msg_percent_from_this_month,
first_sent_date,
last_sent_date
FROM
(
  SELECT
    sent_month,
    id_account,
    COUNT(id_message)
      OVER (PARTITION BY sent_month, id_account) AS month_account_cnt,
    COUNT(id_message) OVER (PARTITION BY sent_month) AS month_cnt,
    COUNT(id_message)
      OVER (PARTITION BY sent_month, id_account)
      / COUNT(id_message) OVER (PARTITION BY sent_month)
      * 100 AS sent_msg_percent_from_this_month,
    MIN(full_sent_day) OVER (PARTITION BY sent_month, id_account) AS first_sent_date,
    MAX(full_sent_day) OVER (PARTITION BY sent_month, id_account) AS last_sent_date
  FROM
    (
      SELECT
        es.id_account,
        es.id_message,
        DATE_TRUNC(DATE_ADD(s.date, INTERVAL es.sent_date DAY), MONTH)
          AS sent_month,
        DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS full_sent_day 
      FROM `data-analytics-mate.DA.email_sent` AS es
      JOIN `data-analytics-mate.DA.account_session` AS acs
        ON es.id_account = acs.account_id
      JOIN `data-analytics-mate.DA.session` AS s
        ON acs.ga_session_id = s.ga_session_id
    ) AS month_date
) AS final;
