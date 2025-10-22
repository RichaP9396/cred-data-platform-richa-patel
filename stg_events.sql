select
  event_id,
  user_id,
  event_type,
  cast(event_timestamp as timestamp) as event_timestamp,
  metadata_amount,
  metadata_currency,
  source
from {{ source('cred_raw', 'events_raw') }}
