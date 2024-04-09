{{ config(materialized='table') }}

SELECT 
     M.member_id
    ,M.gender
    ,DATE_DIFF(CURRENT_DATE, M.date_of_birth, YEAR)
        + IF(
            EXTRACT(DAYOFYEAR FROM CURRENT_DATE) < EXTRACT(DAYOFYEAR FROM M.date_of_birth), 
            -1, 
            0
          )                                                                           AS `age`

FROM {{ source ('raw_data', 'members') }}       AS M                                                                        -- Members