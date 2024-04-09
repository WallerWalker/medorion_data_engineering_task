/*
    Count reported medical conditions for each member.

    Layout:
        - get a list of conditions to include
        - pivot has_condition
        - count rows, only if 'true' was specified for the condition
*/

{%
    set conditions = get_has_condition_feature_to_measure()
%}


SELECT 
     member_id
    ,COUNT(*)                       AS `number_of_medical_conditions`

FROM {{ ref('has_condition') }}
    UNPIVOT (`bool` 
        for condition in ( 
            {% for condition_name, measure_name in conditions.items() -%}
                {{ condition_name }}
                {%- if not loop.last -%}
                    , 
                {%- endif -%}
            {% endfor %}
        )
    )

WHERE `bool` = true

GROUP BY member_id