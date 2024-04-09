/*
    Get the adherence trend for each prescribed medicinal treatmemt.
    Consider the last two recorded statuses.
*/

{% set tracked_measures = get_adherent_to_feature_to_measure() %}

WITH LastFewStatuses AS (                                                                                   -- Get last 2 statuses for each employee & status reason
    {{ last_few_statuses(2) }} 
)
,
AddedTrend AS (                                                                                             -- Add the trend value for the last status (compared to previous)
    SELECT 
         LFS.member_id
        ,LFS.measure_id
		,LFS.`status_ordinal_index`
        ,CASE
            WHEN status > LAG(status) OVER (PARTITION BY member_id, measure_id ORDER BY date ASC)        
                THEN 'increasing'
            WHEN status < LAG(status) OVER (PARTITION BY member_id, measure_id ORDER BY date ASC)        
                THEN 'decreasing'
            ELSE 'no change'
         END                                                        AS `trend`

    FROM LastFewStatuses    AS LFS
)

SELECT                                                                                                      -- Pivot the column to represent each status as a feature
    member_id,

    {% for tracked_measure, measure_name_source in tracked_measures.items() -%}
    
        {{ measure_name_source }} AS `{{ measure_name_source }}_trend`
    
        {%- if not loop.last -%}
            ,
        {% endif %}
    {%- endfor %}
    
FROM AddedTrend
    PIVOT ( MAX(trend) 
        FOR measure_id IN (
            {%- for tracked_measure, measure_name_source in tracked_measures.items() -%}
    
               '{{ measure_name_source }}'

                {%- if not loop.last -%}
                    ,
                {% endif %}

            {%- endfor %}
        )
    )

WHERE `status_ordinal_index` = 1