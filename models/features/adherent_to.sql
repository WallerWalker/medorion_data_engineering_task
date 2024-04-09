/*
	For each patient, get adherence to prescribed medicinal treatments.
	Check for multiple possible treatments, as defined in the dedicated macro.
*/

{# Get hash of medications #} 
{%
	set feature_to_measure = get_adherent_to_feature_to_measure()
%}

SELECT 
	 member_id
	,{%- for feature, measure in feature_to_measure.items() -%}
		
		LOGICAL_OR(LCS.measure_id = '{{ measure }}' and status > 0.8) AS {{ feature }},

	 {% endfor %}

FROM {{ source ('raw_data', 'members') }}                   AS M                                -- Members
	LEFT JOIN {{ ref ('latest_members_care_status') }}      AS LCS                              -- Latest Care Status 
		USING (member_id)

GROUP BY member_id