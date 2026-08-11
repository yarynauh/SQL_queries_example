SELECT
 sp.continent,
 (
   SUM(
     CASE
       WHEN
         params.key = 'page_title'
         AND STRPOS(LOWER(params.value.string_value), 'youtube') > 0
         THEN 1
       ELSE 0
       END)
   / COUNT(ep.event_name))
   * 100 AS percent_page_title
FROM `data-analytics-mate.DA.event_params` ep, UNNEST(event_params) AS params
JOIN `data-analytics-mate.DA.session_params` sp
 ON ep.ga_session_id = sp.ga_session_id
GROUP BY sp.continent;
