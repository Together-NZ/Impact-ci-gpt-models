{% macro gpt_campaigns(source_name, table_name) %}
  campaigns AS (
    SELECT
      JSON_VALUE(data, '$.id') AS campaign_id,
      JSON_VALUE(data, '$.name') AS campaign_name,
      ROW_NUMBER()
        OVER (
          PARTITION BY JSON_VALUE(data, '$.id') ORDER BY _sdc_batched_at DESC
        )
        AS row_num
    FROM {{ source(source_name,table_name)}}
  ),
  clean_campaigns AS (
    SELECT campaign_id, campaign_name FROM campaigns WHERE row_num = 1
  )
{% endmacro %}
