/*
    For each patient, show if they are diagnosed with certain medical conditions. Spread over multiple columns to support ML processes.
    Check from multiple conditions, as defined in the dedicated macro.
*/

{# Get hash of conditions #}
{%-
    set conditions = get_has_condition_feature_to_measure()
-%}

SELECT
     MCS.member_id
     
     {%- for condition_name, measure_name in conditions.items() -%}
        
        ,LOGICAL_OR(MCS.measure_id = '{{ measure_name }}')         AS `{{ condition_name }}`

    {% endfor %}

FROM {{ source ('raw_data', 'members') }}
    LEFT JOIN {{ ref ('latest_members_care_status') }} AS MCS                                               -- Members Care Status
        USING (member_id)

WHERE member_id IS NOT NULL

GROUP BY MCS.member_id