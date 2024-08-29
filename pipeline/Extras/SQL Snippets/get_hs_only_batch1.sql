SELECT 
    rls.leaid
	,rls.schid
	,rls.lea_name
	,rls.sch_name
	,rls.jj
    ,advmath.tot_mathenr_advm_m AS advmath_m_enr
    ,advmath.tot_mathenr_advm_f AS advmath_f_enr
    ,advpl.TOT_APEXAM_NONE_M AS advpl_m_noexam
    ,advpl.TOT_APEXAM_NONE_F AS advpl_f_noexam
	,alg1.TOT_ALGPASS_GS0910_M AS alg1_m_0910_passed
    ,alg1.TOT_ALGPASS_GS1112_M AS alg1_m_1112_passed
	,alg1.TOT_ALGPASS_GS0910_F AS alg1_f_0910_passed
    ,alg1.TOT_ALGPASS_GS1112_F AS alg1_f_1112_passed
    ,alg2.tot_mathenr_alg2_m AS alg2_m_enr
    ,alg2.tot_mathenr_alg2_f AS alg2_f_enr
	,bio.TOT_SCIENR_BIOL_M AS bio_m_enr
	,bio.TOT_SCIENR_BIOL_F AS bio_f_enr
	,calc.TOT_MATHENR_CALC_M AS calc_m_enr
	,calc.TOT_MATHENR_CALC_F AS calc_f_enr
	,chem.TOT_SCIENR_CHEM_M AS chem_m_enr
	,chem.TOT_SCIENR_CHEM_F AS chem_f_enr
	,dual.TOT_DUAL_M AS dual_m_enr
	,dual.TOT_DUAL_F AS dual_f_enr
--     ,enr.tot_enr_m AS total_m_enr
--     ,enr.tot_enr_f AS total_f_enr
-- 	,enr.SCH_ENR_LEP_M AS enr_lep_m
-- 	,enr.SCH_ENR_LEP_F AS enr_lep_f
-- 	,enr.SCH_ENR_504_M AS enr_504_m
-- 	,enr.SCH_ENR_504_F AS enr_504_f
-- 	,enr.SCH_ENR_IDEA_M AS enr_idea_m
-- 	,enr.SCH_ENR_IDEA_F AS enr_idea_f
-- 	,geo.TOT_MATHENR_GEOM_M AS geo_m_enr
-- 	,geo.TOT_MATHENR_GEOM_F AS geo_f_enr
-- 	,phys.TOT_SCIENR_PHYS_M AS phys_m_enr
-- 	,phys.TOT_SCIENR_PHYS_F AS phys_f_enr
-- 	,satact.TOT_SATACT_M AS satact_m
-- 	,satact.TOT_SATACT_F AS satact_f
--     ,rls.lea_state
--     ,saipe.totalpopulation
--     ,saipe.population5_17
--     ,saipe.population5_17inpoverty
FROM ref_schema.ref_lea_sch rls
JOIN data_schema.sch_advancedmathematics advmath ON advmath.combokey = rls.combokey
JOIN data_schema.sch_advancedplacement advpl ON advpl.combokey = rls.combokey
JOIN data_schema.sch_algebrai alg1 ON alg1.combokey = rls.combokey
JOIN data_schema.sch_algebraii alg2 ON alg2.combokey = rls.combokey 
JOIN data_schema.sch_biology bio ON bio.combokey = rls.combokey 
JOIN data_schema.sch_calculus calc ON calc.combokey = rls.combokey 
JOIN data_schema.sch_chemistry chem ON chem.combokey = rls.combokey 
JOIN data_schema.sch_dualenrollment dual ON dual.combokey = rls.combokey 
-- JOIN data_schema.sch_enrollment enr ON enr.combokey = rls.combokey 
-- JOIN data_schema.sch_geometry geo ON geo.combokey = rls.combokey 
-- JOIN data_schema.sch_physics phys ON phys.combokey = rls.combokey 
-- JOIN data_schema.sch_satandact satact ON satact.combokey = rls.combokey 
-- JOIN  ON .combokey = rls.combokey 
JOIN data_schema.sch_schoolcharacteristics chr ON chr.combokey = rls.combokey 
JOIN data_schema.saipe_ussd17 saipe ON saipe.leaid = rls.leaid
WHERE chr.hs_only = TRUE
order by leaid