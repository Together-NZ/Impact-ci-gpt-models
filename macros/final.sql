{% marco final() %}
joint_insight AS (
  SELECT con.conversions , ads.* FROM ads_insights AS ads JOIN conversions AS con 
  ON con.ad_id = ads.ad_id AND con.date=ads.date
),
joint_campaigns AS (
  SELECT insights.* EXCEPT(ad_id), metadata.* FROM 
  joint_insight AS insights LEFT JOIN joint_metadata AS metadata
  ON insights.ad_id = metadata.ad_id
)
SELECT 
SUM(media_cost),
SUM(clicks),
sum(conversions),
sum(impressions) ,
campaign_name,
ad_name AS creative_name,
ad_group_name,
target_url
FROM joint_campaigns 
group by campaign_name,ad_name,ad_group_name,target_url
{% endmarco %}