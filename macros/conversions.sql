{% macro conversions(source_name, table_name) %}
raw_conversions AS (
  SELECT
    SAFE_CAST(JSON_VALUE(data, '$.conversions') AS FLOAT64) AS conversions,
    JSON_VALUE(data, '$.entity_id') AS ad_id,
    JSON_VALUE(data, '$.date') AS date,
    ROW_NUMBER() OVER (
      PARTITION BY
        JSON_VALUE(data, '$.conversions'),
        JSON_VALUE(data, '$.entity_id'),
        JSON_VALUE(data, '$.date')
      ORDER BY _sdc_batched_at DESC
    ) AS row_num
  FROM {{ source(source_name, table_name) }}
),
conversions AS (
  SELECT * EXCEPT (row_num) FROM raw_conversions WHERE row_num = 1
)
{% endmacro %}
