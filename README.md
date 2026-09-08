# Impact-CI-gpt_models

dbt package for transforming OpenAI ChatGPT Ads (tap-gpt) raw data into the standard dash table shape.

## Streams expected in raw source

| Table | tap-gpt stream |
|---|---|
| `campaigns` | campaigns |
| `ads` | ads |
| `ad_insights` | ad_insights |
| `ad_conversions` | ad_conversions |

## Client usage

```sql
{{ config(
    materialized='table',
    schema=env_var('GPT_SUFFIX', ''),
) }}

with {{ gpt.gpt_campaigns(source_name='gpt_raw', table_name='campaigns') }},
{{ gpt.gpt_ads(source_name='gpt_raw', table_name='ads') }},
{{ gpt.gpt_insights(source_name='gpt_raw', table_name='ad_insights') }},
{{ gpt.gpt_conversions(source_name='gpt_raw', table_name='ad_conversions') }},
{{ gpt.gpt_final() }}
```

Add to client `packages.yml`:

```yaml
  - git: git@github.com:Together-NZ/Impact-CI-gpt_models.git
    revision: v1.0.0
```
