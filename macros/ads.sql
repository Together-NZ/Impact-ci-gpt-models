{% macro ads(source_name, table_name) %}
  ads AS (
    SELECT
      JSON_VALUE(data, '$.id') AS ad_id,
      JSON_VALUE(data, '$.name') AS ad_name,
      JSON_VALUE(data, '$.ad_group_id') AS ad_group_id,
      JSON_VALUE(data, '$.creative.target_url') AS target_url,
      ROW_NUMBER()
        OVER (
          PARTITION BY JSON_VALUE(data, '$.id') ORDER BY _sdc_batched_at DESC
        )
        AS row_num
    FROM {{source(source_name,table_name)}}
  ),
  clean_ads AS (
    SELECT ad_id, ad_name, ad_group_id, target_url FROM ads WHERE row_num = 1
  )
{% endmacro %}
