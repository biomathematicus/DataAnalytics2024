SELECT 
    rls.leaid
-- 	,rls.schid
	,min(rls.lea_name) AS lea_name
	,min(rls.lea_state) as lea_state
-- 	,rls.sch_name
-- 	,rls.jj
	,sum(advmath.tot_mathenr_advm_m) AS advmath_m_enr
	,sum(advmath.tot_mathenr_advm_f) AS advmath_f_enr
	,sum(advpl.TOT_APEXAM_NONE_M) AS advpl_m_noexam
	,sum(advpl.TOT_APEXAM_NONE_F) AS advpl_f_noexam
	,sum(alg1.TOT_ALGPASS_GS0910_M) AS alg1_m_0910_passed
	,sum(alg1.TOT_ALGPASS_GS1112_M) AS alg1_m_1112_passed
	,sum(alg1.TOT_ALGPASS_GS0910_F) AS alg1_f_0910_passed
	,sum(alg1.TOT_ALGPASS_GS1112_F) AS alg1_f_1112_passed
	,sum(alg2.tot_mathenr_alg2_m) AS alg2_m_enr
	,sum(alg2.tot_mathenr_alg2_f) AS alg2_f_enr
	,sum(bio.TOT_SCIENR_BIOL_M) AS bio_m_enr
	,sum(bio.TOT_SCIENR_BIOL_F) AS bio_f_enr
	,sum(calc.TOT_MATHENR_CALC_M) AS calc_m_enr
	,sum(calc.TOT_MATHENR_CALC_F) AS calc_f_enr
	,sum(chem.TOT_SCIENR_CHEM_M) AS chem_m_enr
	,sum(chem.TOT_SCIENR_CHEM_F) AS chem_f_enr
	,sum(dual.TOT_DUAL_M) AS dual_m_enr
	,sum(dual.TOT_DUAL_F) AS dual_f_enr
	,sum(enr.tot_enr_m) AS total_m_enr
	,sum(enr.tot_enr_f) AS total_f_enr
	,sum(enr.SCH_ENR_LEP_M) AS enr_lep_m
	,sum(enr.SCH_ENR_LEP_F) AS enr_lep_f
	,sum(enr.SCH_ENR_504_M) AS enr_504_m
	,sum(enr.SCH_ENR_504_F) AS enr_504_f
	,sum(enr.SCH_ENR_IDEA_M) AS enr_idea_m
	,sum(enr.SCH_ENR_IDEA_F) AS enr_idea_f
	,sum(geo.TOT_MATHENR_GEOM_M) AS geo_m_enr
	,sum(geo.TOT_MATHENR_GEOM_F) AS geo_f_enr
	,sum(phys.TOT_SCIENR_PHYS_M) AS phys_m_enr
	,sum(phys.TOT_SCIENR_PHYS_F) AS phys_f_enr
	,sum(satact.TOT_SATACT_M) AS satact_m
	,sum(satact.TOT_SATACT_F) AS satact_f
	,avg(saipe.totalpopulation) AS totalpopulation 
	,avg(saipe.population5_17) AS population5_17
	,avg(saipe.population5_17inpoverty) AS population5_17inpoverty
FROM ref_schema.ref_lea_sch rls
JOIN data_schema.sch_advancedmathematics advmath ON advmath.combokey = rls.combokey
JOIN data_schema.sch_advancedplacement advpl ON advpl.combokey = rls.combokey
JOIN data_schema.sch_algebrai alg1 ON alg1.combokey = rls.combokey
JOIN data_schema.sch_algebraii alg2 ON alg2.combokey = rls.combokey 
JOIN data_schema.sch_biology bio ON bio.combokey = rls.combokey 
JOIN data_schema.sch_calculus calc ON calc.combokey = rls.combokey 
JOIN data_schema.sch_chemistry chem ON chem.combokey = rls.combokey 
JOIN data_schema.sch_dualenrollment dual ON dual.combokey = rls.combokey 
JOIN data_schema.sch_enrollment enr ON enr.combokey = rls.combokey 
JOIN data_schema.sch_geometry geo ON geo.combokey = rls.combokey 
JOIN data_schema.sch_physics phys ON phys.combokey = rls.combokey 
JOIN data_schema.sch_satandact satact ON satact.combokey = rls.combokey 
-- JOIN  ON .combokey = rls.combokey 
JOIN data_schema.sch_schoolcharacteristics chr ON chr.combokey = rls.combokey 
JOIN data_schema.saipe_ussd17 saipe ON saipe.leaid = rls.leaid
WHERE chr.hs_only = TRUE
group by rls.leaid
order by leaid;