{%- macro last_few_statuses(count) -%}

	{%-
		set tracked_measures = get_adherent_to_feature_to_measure()
	-%}


	SELECT 
		 *
		,ROW_NUMBER() OVER(PARTITION BY CS.member_id, CS.measure_id ORDER BY CS.date DESC) 		AS `status_ordinal_index`

	FROM {{ source('raw_data', 'members_care_status')}} AS CS

	WHERE CS.measure_id IN (
		{% for tracked_measure, measure_name_source in tracked_measures.items() -%}
			'{{ measure_name_source }}'
			{%- if not loop.last -%}
				, 
			{%- endif -%}
		{% endfor %}
	)

	QUALIFY ROW_NUMBER() OVER(PARTITION BY CS.member_id, CS.measure_id ORDER BY CS.date DESC) <= {{ count }}

	ORDER BY CS.member_id, measure_id, date DESC

{%- endmacro -%}