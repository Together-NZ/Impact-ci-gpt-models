{% macro insights(source_name, table_name) %}
raw_ads_insights AS (
  SELECT JSON_VALUE(data,'$.ad_id') AS ad_id,
  SAFE_CAST(JSON_VALUE(data,'$.clicks') AS INT64) AS clicks,
  SAFE_CAST(JSON_VALUE(data,'$.impressions') AS INT64)  AS impressions,
  SAFE_CAST(JSON_VALUE(data,'$.spend') AS FLOAT64) AS media_cost,
  JSON_VALUE(data,'$.readable_time') AS date,
  ROW_NUMBER() OVER (PARTITION BY JSON_VALUE(data,'$.id'),JSON_VALUE(data,'$.reasable_time'),
  JSON_VALUE(data,'$.spend'),JSON_VALUE(data,'$.impressions'),JSON_VALUE(data,'$.clicks'),
  JSON_VALUE(data,'$.readable_time')
  ORDER BY _sdc_batched_at DESC) AS row_num

  FROM {{source(source_name,table_name)}}
),
ads_insights AS (
  SELECT * except(row_num) FROM raw_ads_insights where row_num=1
)
{% endmacro %}
