WITH
  registrations
  AS (  -- кількість створених акаунтів
    SELECT
      s.date,
      sp.country,
      a.send_interval,
      a.is_verified,
      a.is_unsubscribed,
      COUNT(DISTINCT a.id) AS account_cnt
    FROM `DA.account_session` acs
    JOIN `DA.session` s
      ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp
      ON acs.ga_session_id = sp.ga_session_id
    JOIN `DA.account` a
      ON acs.account_id = a.id
    GROUP BY
      s.date,
      sp.country,
      a.send_interval,
      a.is_verified,
      a.is_unsubscribed
  ),
  emails_cnt
  AS (  -- кількість відправлених, відкритих та клікнутих листів
    SELECT
      DATE_ADD(s.date, INTERVAL ems.sent_date DAY) AS sent_date,
      sp.country,
      a.send_interval,
      a.is_verified,
      a.is_unsubscribed,
      COUNT(DISTINCT ems.id_message) AS sent_msg,
      COUNT(DISTINCT eo.id_message) AS open_msg,
      COUNT(DISTINCT ev.id_message) AS visit_msg
    FROM `DA.email_sent` ems
    JOIN `DA.account` a
      ON ems.id_account = a.id
    JOIN `DA.account_session` acs
      ON ems.id_account = acs.account_id
    JOIN `DA.session` s
      ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp
      ON acs.ga_session_id = sp.ga_session_id
    LEFT JOIN `DA.email_open` eo
      ON ems.id_message = eo.id_message
    LEFT JOIN `DA.email_visit` ev
      ON ems.id_message = ev.id_message
    GROUP BY
      DATE_ADD(s.date, INTERVAL ems.sent_date DAY),
      sp.country,
      a.send_interval,
      a.is_verified,
      a.is_unsubscribed
  ),
  final AS (  -- обʼєдную дані
    SELECT
      date,
      country,
      send_interval,
      is_verified,
      is_unsubscribed,
      account_cnt,
      0 AS sent_msg,
      0 AS open_msg,
      0 AS visit_msg
    FROM registrations
    UNION ALL
    SELECT
      sent_date,
      country,
      send_interval,
      is_verified,
      is_unsubscribed,
      0 AS account_cnt,
      sent_msg,
      open_msg,
      visit_msg
    FROM emails_cnt
  ),  -- склеюю таблиці
  total_sum AS (
    SELECT
      date,
      country,
      send_interval,
      is_verified,
      is_unsubscribed,
      SUM(account_cnt) AS account_cnt,
      SUM(sent_msg) AS sent_msg,
      SUM(open_msg) AS open_msg,
      SUM(visit_msg) AS visit_msg,
    FROM final
    GROUP BY
      date,
      country,
      send_interval,
      is_verified,
      is_unsubscribed
  ),
  country_count AS (  -- total counts по країнах
    SELECT
      country,
      SUM(account_cnt) AS total_country_account_cnt,
      SUM(sent_msg) AS total_country_sent_cnt
    FROM total_sum
    GROUP BY country
  ),
  country_rank AS (  -- віконні функції
    SELECT
      country,
      total_country_account_cnt,
      total_country_sent_cnt,
      RANK()
        OVER (ORDER BY total_country_account_cnt DESC)
        AS rank_total_country_account_cnt,
      RANK()
        OVER (ORDER BY total_country_sent_cnt DESC)
        AS rank_total_country_sent_cnt
    FROM country_count
  )
SELECT
  date,
  ts.country,
  send_interval,
  is_verified,
  is_unsubscribed,
  account_cnt,
  sent_msg,
  open_msg,
  visit_msg,
  total_country_account_cnt,
  total_country_sent_cnt,
  rank_total_country_account_cnt,
  rank_total_country_sent_cnt
FROM total_sum ts
JOIN country_rank cr
  ON ts.country = cr.country
WHERE
  rank_total_country_account_cnt <= 10
  OR rank_total_country_sent_cnt <= 10;
