SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME IN (
        'sch_advancedmathematics',
        'sch_advancedplacement',
        'sch_algebrai',
        'sch_algebraii',
        'sch_biology',
        'sch_calculus',
        'sch_chemistry',
        'sch_corporalpunishment',
        'sch_creditrecovery',
        'sch_dualenrollment',
        'sch_enrollment',
        'sch_expulsions',
        'sch_geometry',
        'sch_giftedandtalented',
        'sch_harassmentandbullying',
        'sch_internationalbaccalaureate',
        'sch_justicefacilities',
        'sch_offenses',
        'sch_physics',
        'sch_referralsandarrests',
        'sch_restraintandseclusion',
        'sch_retention',
        'sch_satandact',
        'sch_schoolcharacteristics',
        'sch_schoolexpenditures',
        'sch_schoolsupport',
        'sch_singlesexathletics',
        'sch_singlesexclasses',
        'sch_suspensions',
        'sch_transfers'
    )
AND 
    TABLE_SCHEMA = 'data_schema' and column_name <> 'combokey'
ORDER BY 
    TABLE_NAME, COLUMN_NAME;
