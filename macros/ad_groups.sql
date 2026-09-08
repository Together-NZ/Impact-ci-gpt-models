{% marco ad_groups(source_name,table_name)}
  ad_groups AS (
    SELECT
      JSON_VALUE(data, '$.id') AS ad_group_id,
      JSON_VALUE(data, '$.name') AS ad_group_name,
      JSON_VALUE(data, '$.campaign_id') AS campaign_id,
      ROW_NUMBER()
        OVER (
          PARTITION BY JSON_VALUE(data, '$.id') ORDER BY _sdc_batched_at DESC
        )
        AS row_num
    FROM {{source(source_name,table_name)}}
  ),
  clean_ad_groups AS (
    SELECT ad_group_id, ad_group_name, campaign_id
    FROM ad_groups
    WHERE row_num = 1
  )

{% endmacro% }