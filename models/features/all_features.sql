/*
	Combines all features into a single dataset.
	Note that not all patients have recorded statuses.
*/
SELECT 
	 *
FROM {{ ref('members_features')}} 							AS MBF                      -- Member Basic Features
	LEFT JOIN {{ ref('adherent_to') }} 						AS A                        -- Adherenence
		USING(member_id)
 
	LEFT JOIN {{ ref('has_condition') }} 					AS C                        -- Conditions
		USING(member_id)
 
	LEFT JOIN {{ ref('number_of_medical_conditions') }} 	AS CMC                      -- Count Medical Conditions
		USING(member_id)
 
	LEFT JOIN {{ ref('condition_medication_trend') }} 		AS MAT						-- Medication Adherence Trend
		USING(member_id)