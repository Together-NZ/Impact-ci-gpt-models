{% macro joint_meta_data() %}
 joint_metadata AS (
    SELECT
      campaigns.campaign_id,
      campaign_name,
      ad_groups.ad_group_id,
      ad_group_name,
      ads.ad_id,
      ads.ad_name,
      target_url
    FROM clean_ads AS ads
    LEFT JOIN clean_ad_groups AS ad_groups
      ON ads.ad_group_id = ad_groups.ad_group_id
    LEFT JOIN clean_campaigns AS campaigns
      ON ad_groups.campaign_id = campaigns.campaign_id
  )
{% endmacro %}
