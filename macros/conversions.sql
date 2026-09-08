{% macro gpt_conversions(source_name, table_name) %}
raw_conversions AS (
  SELECT 
  SAFE_CAST(JSON_VALUE(data,'$.conversions') AS FLOAT64) AS conversions,
  JSON_VALUE(data,'$.entity_id') AS ad_id,
  json_value(data,'$.date') AS date,
  ROW_NUMBER() OVER (PARTITION BY JSON_VALUE(data,'$.conversions'),
   JSON_VALUE(data,'$.entity_id'),
   json_value(data,'$.date') ORDER BY _sdc_batched_at) AS row_num
  FROM {{ source(source_name,table_name)}}
),
conversions AS (
  SELECT * EXCEPT(row_num) from raw_conversions where row_num=1
)
{% endmacro %}
