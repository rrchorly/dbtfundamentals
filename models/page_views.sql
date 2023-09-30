{{ config(
    materialized = 'incremental',
    unique_key = 'page_view_id'
   ) }}
with events as (
    select PAGE_VIEW_ID,
    ANONYMOUS_USER_ID,
SESSION_ID,
EVENT,
DEVICE_TYPE,
PAGE_URL,
PAGE_TITLE,
PAGE_URLSCHEME,
PAGE_URLHOST,
PAGE_URLPORT,
PAGE_URLPATH,
PAGE_URLQUERY,
PAGE_URLFRAGMENT,
COLLECTOR_TSTAMP,
DERIVED_TSTAMP 
from {{ source('snowplow', 'events') }}
    {% if is_incremental() %}
        -- this filter will only be applied on an incremental run
        where collector_tstamp > (select dateadd('day',-3, max(max_collector_tstamp)) from {{ this }}) 
    {% endif %}
),
page_views as (
    select * from events
    where event = 'page_view'
),
aggregated_page_events as (
    select
        page_view_id,
        count(*) * 10 as approx_time_on_page,
        min(derived_tstamp) as page_view_start,
        max(collector_tstamp) as max_collector_tstamp
    from events
    group by 1
),
joined as (
    select
        *
    from page_views
    left join aggregated_page_events using (page_view_id)
)
select * from joined