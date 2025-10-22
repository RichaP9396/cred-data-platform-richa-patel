{{ config(
    materialized='view'
) }}

with base as (
    select
        user_id,
        event_timestamp,
        metadata_amount as amount
    from {{ ref('stg_events') }}
)

, aggregated as (
    select
        user_id,
        min(event_timestamp) as first_event,
        max(event_timestamp) as last_event,
        count(*) as total_events,
        sum(amount) as total_amount
    from base
    group by user_id
)

select * from aggregated
