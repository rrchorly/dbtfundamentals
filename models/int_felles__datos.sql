{{ config(materialized='table') }}

with
-- importerer datopakke fra dbtMore actions
basedim as ({{ dbt_date.get_date_dimension("1823-01-01", "2123-12-31") }}),

-- importerer seed-fil med en dato per påske fra 1823 til 2123
paaskedag as (select * from {{ ref("dim_customers") }}),

-- importerer seed-fil med spesialdatoer UTENFOR 1823-2123
special_dates as (select * from {{ ref("fct_orders") }}),

-- setter opp kolonnene som kan utledes kun ved hjelp av datopakken
dim_model as (
    select
        concat(
            substr(to_varchar(date_day), 1, 4),
            substr(to_varchar(date_day), 6, 2),
            substr(to_varchar(date_day), 9, 2)
        )::int
            as dato_id,
        date_day as dato,
        year_number as aar,
        month_of_year as maaned,
        month_name,
        case
            when month_name = 'January'
                then 'Januar'
            when month_name = 'February'
                then 'Februar'
            when month_name = 'March'
                then 'Mars'
            when month_name = 'May'
                then 'Mai'
            when month_name = 'June'
                then 'Juni'
            when month_name = 'July'
                then 'Juli'
            when month_name = 'October'
                then 'Oktober'
            when month_name = 'December'
                then 'Desember'
            else month_name
        end as maaned_navn,
        case
            when month_name_short = 'May'
                then 'Mai'
            when month_name_short = 'Oct'
                then 'Okt'
            when month_name_short = 'Dec'
                then 'Des'
            else month_name_short
        end as maaned_navn_kort,
        quarter_of_year || '. kvartal' as kvartal,
        quarter_of_year as kvartal_nummer,
        'Q' || quarter_of_year as kvartal_kort,
        'Quarter ' || quarter_of_year as kvartal_int,
        case
            when month_of_year in (1, 2, 3, 4)
                then ('1. tertial')
            when month_of_year in (5, 6, 7, 8)
                then ('2. tertial')
            when month_of_year in (9, 10, 11, 12)
                then ('3. tertial')
        end as tertial,
        day_of_month as dag,
        day_of_week as ukedag,
        day_of_week_iso as ukedag_iso,
        case
            when day_of_week_iso = 1
                then 'Mandag'
            when day_of_week_iso = 2
                then 'Tirsdag'
            when day_of_week_iso = 3
                then 'Onsdag'
            when day_of_week_iso = 4
                then 'Torsdag'
            when day_of_week_iso = 5
                then 'Fredag'
            when day_of_week_iso = 6
                then 'Lørdag'
            when day_of_week_iso = 7
                then 'Søndag'
        end as ukedag_navn,
        iso_week_of_year as ukenummer,
        'Uke ' || iso_week_of_year as ukenummer_tekst,
        dag || '. ' || lower(maaned_navn_kort) as dato_dag,
        to_char(date_day, 'DD.MM.YYYY') as dato_desc,
        to_char(date_day, 'YYYY-MM') as aar_maaned,
        case
            when iso_week_of_year < 10
                then year_number || '-0' || iso_week_of_year
            when iso_week_of_year >= 10
                then year_number || '-' || iso_week_of_year
        end as aar_ukenummer,
        day_of_year as dag_i_aaret,
        coalesce(month_end_date = date_day, false) as er_siste_dag_i_mnd,
        to_char(year_number) as aar_navn,
        substring(aar_navn, 3, 5) as aarnavn_kort,
        substring(ukedag_navn, 1, 3) as dagnavn_kort
    from basedim
),

-- henter inn og prepper datoene for 1. påskedag fra seed-fil
paaskedag_beskrivelse as (
    select
        base.year_number as aar,
        base.day_of_year as dag_i_aaret,
        null as dag_beskrivelse
    from basedim as base
        inner join
            paaskedag as paaske
            on
                base.year_number = paaske.year
                and base.month_of_year = paaske.month
                and base.day_of_month = paaske.day
),

-- legge til dag_beskrivelse for alle bevegelige helligdager basert på antall
-- dager unna 1. påskedag
bevegelige_helligdager as (
    select
        aar,
        dag_i_aaret,
        dag_beskrivelse
    from paaskedag_beskrivelse
    union all
    select
        aar,
        dag_i_aaret - 3 as dag_i_aaret,
        'Skjærtorsdag' as dag_beskrivelse
    from paaskedag_beskrivelse
    union all
    select
        aar,
        dag_i_aaret - 2 as dag_i_aaret,
        'Langfredag' as dag_beskrivelse
    from paaskedag_beskrivelse
    union all
    select
        aar,
        dag_i_aaret + 1 as dag_i_aaret,
        '2. påskedag' as dag_beskrivelse
    from paaskedag_beskrivelse
    union all
    select
        aar,
        dag_i_aaret + 39 as dag_i_aaret,
        'Kristi Himmelfart' as dag_beskrivelse
    from paaskedag_beskrivelse
    union all
    select
        aar,
        dag_i_aaret + 50 as dag_i_aaret,
        '2. pinsedag' as dag_beskrivelse
    from paaskedag_beskrivelse
),

-- fylle ut dag_beskrivelse for alle røddager og joine inn med dim_model
dato_dag_beskrivelse as (
    select
        dim.*,
        case
            when dim.maaned = 1 and dim.dag = 1
                then '1. nyttårsdag'
                -- når bevegelige og faste helligdager havner på samme dag vises begge
            when dim.maaned = 5 and dim.dag = 1 and bev_hellig.dag_beskrivelse is not null
                then 'Arbeidernes dag / ' || bev_hellig.dag_beskrivelse
            when dim.maaned = 5 and dim.dag = 1 and bev_hellig.dag_beskrivelse is null
                then 'Arbeidernes dag'
            when dim.maaned = 5 and dim.dag = 17 and bev_hellig.dag_beskrivelse is not null
                then 'Grunnlovsdagen / ' || bev_hellig.dag_beskrivelse
            when dim.maaned = 5 and dim.dag = 17 and bev_hellig.dag_beskrivelse is null
                then 'Grunnlovsdagen'
            when dim.maaned = 12 and dim.dag = 25
                then '1. juledag'
            when dim.maaned = 12 and dim.dag = 26
                then '2. juledag'
            else bev_hellig.dag_beskrivelse
        end as dag_beskrivelse
    from dim_model as dim
        left join
            bevegelige_helligdager as bev_hellig
            on dim.aar = bev_hellig.aar and dim.dag_i_aaret = bev_hellig.dag_i_aaret
)

-- sette kolonner i riktig rekkefølge og utlede er_virkedag
-- endrer ikke lengde/format, dette bestemmer Snowflake selv 
select
    dato_id,
    dato,
    aar,
    maaned,
    month_name,
    maaned_navn,
    maaned_navn_kort,
    kvartal,
    kvartal_nummer,
    kvartal_kort,
    kvartal_int,
    tertial,
    dag,
    ukedag,
    ukedag_iso,
    ukedag_navn,
    case
        when dag_beskrivelse is not null
            then false
        when ukedag_navn = 'Lørdag'
            then false
        when ukedag_navn = 'Søndag'
            then false
        else true
    end as er_virkedag,
    dag_beskrivelse,
    ukenummer,
    ukenummer_tekst,
    dato_dag,
    dato_desc,
    aar_maaned,
    aar_ukenummer,
    dag_i_aaret,
    er_siste_dag_i_mnd,
    aar_navn,
    aarnavn_kort,
    dagnavn_kort
from dato_dag_beskrivelse
union all
select *
from special_dates
order by dato_id
