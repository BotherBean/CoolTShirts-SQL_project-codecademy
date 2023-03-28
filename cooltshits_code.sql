-- Visits by page on home page

SELECT DISTINCT page_name,
  COUNT(DISTINCT user_id) as 'number of visits'
FROM page_visits
GROUP BY page_name;

-- First touch distribution by campaign

WITH first_touch AS (
  SELECT user_id,
    MIN(timestamp) as first_touch_at
  FROM page_visits
  GROUP BY user_id),
ft_pv AS (
  SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
  ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
  SELECT utm_source,
    utm_campaign,
    COUNT(*) AS 'first touch count'
  FROM  ft_pv
  GROUP BY 1, 2
  ORDER BY 3 DESC;
  
  
  -- Last touch distribution by campaign
  WITH last_touch AS (
  SELECT user_id,
    MAX(timestamp) AS last_touch_at
  FROM page_visits
  GROUP BY user_id),
  lt_pv AS (
    SELECT lt.user_id,
     lt.last_touch_at,
     pv.utm_source,
     pv.utm_campaign,
     pv.page_name
    FROM last_touch AS 'lt'
    JOIN page_visits as 'pv'
      ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
  )
  SELECT
    utm_source,
    utm_campaign,
    COUNT(DISTINCT user_id) AS 'last touch count'
  FROM lt_pv
  GROUP BY 2
  ORDER BY 3 DESC;
  
  -- Last touch distribution by campaign considering only users reaching the purchase page
  WITH last_touch AS (
  SELECT user_id,
    MAX(timestamp) AS last_touch_at
  FROM page_visits
  GROUP BY user_id),
  lt_pv AS (
    SELECT lt.user_id,
     lt.last_touch_at,
     pv.utm_source,
     pv.utm_campaign,
     pv.page_name
    FROM last_touch AS 'lt'
    JOIN page_visits as 'pv'
      ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
  )
  SELECT
    utm_source,
    utm_campaign,
    COUNT(DISTINCT user_id) AS 'purchases'
  FROM lt_pv
  WHERE page_name = '4 - purchase'
  GROUP BY 2
  ORDER BY 3 DESC;
  
