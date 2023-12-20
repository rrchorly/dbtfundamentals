with quelle_raw as (
select 1 as source_id
),

quelle as (
select {{ dummy_macro( something='loremipsumloremipsumloremipsumloremipsumloremipsumloremipsumloremipsumloremipsumloremipsumremipsumloremipsumloremipsum', anything=true ) }} from quelle_raw
)

select * from quelle
