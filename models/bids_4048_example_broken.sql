WITH quelle_raw AS (
    SELECT 1 AS source_id

),

quelle AS (
    SELECT {{ dummy_macro( something='loremipsumloremipsumloremipsumloremipsumloremipsumloremipsumloremipsumloremipsumloremipsumremipsumloremipsumloremipsum', anything=true ) }} FROM quelle_raw
)

SELECT * FROM quelle
