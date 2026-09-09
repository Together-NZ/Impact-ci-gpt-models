{% macro final() %}
joint_insight AS (
  SELECT con.conversions, ads.*
  FROM ads_insights AS ads
  JOIN conversions AS con
    ON con.ad_id = ads.ad_id AND con.date = ads.date
),
joint_campaigns AS (
  SELECT insights.* EXCEPT (ad_id), metadata.*
  FROM joint_insight AS insights
  LEFT JOIN joint_metadata AS metadata
    ON insights.ad_id = metadata.ad_id
)
SELECT
  SUM(media_cost) AS media_cost,
  SUM(clicks) AS clicks,
  SUM(conversions) AS conversions,
  SUM(impressions) AS impressions,
  campaign_name,
  ad_name AS creative_name,
  ad_group_name,
  target_url,
  NULL AS ad_format,
  NULL AS audience_name,
  campaign_name AS campaign_name_selection,
  campaign_name AS campaign_descr,
  ad_name AS creative_descr,
  'ChatGPT' AS platform,
  'ChatGPT' AS publisher,
  'Native' AS channel,
  date
FROM joint_campaigns
GROUP BY campaign_name, ad_name, ad_group_name, target_url, date
{% endmacro %}
