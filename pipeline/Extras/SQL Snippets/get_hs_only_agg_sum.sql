SELECT 
    rls.leaid
-- 	,rls.schid
	,min(rls.lea_name) AS lea_name
	,min(rls.lea_state) as lea_state
-- 	,rls.sch_name
-- 	,rls.jj
	,sum(GREATEST(advmath.tot_mathenr_advm_m,0) + GREATEST(advmath.tot_mathenr_advm_f,0)) AS advmath_enr
	,sum(GREATEST(advpl.TOT_APEXAM_NONE_M,0) + GREATEST(advpl.TOT_APEXAM_NONE_F,0)) AS advpl_noexam
	,sum(GREATEST(alg1.TOT_ALGPASS_GS0910_M,0) + GREATEST(alg1.TOT_ALGPASS_GS0910_F,0)) AS alg1_0910_passed
	,sum(GREATEST(alg1.TOT_ALGPASS_GS1112_M,0) + GREATEST(alg1.TOT_ALGPASS_GS1112_F,0)) AS alg1_1112_passed
	,sum(GREATEST(alg2.tot_mathenr_alg2_m,0) + GREATEST(alg2.tot_mathenr_alg2_f,0)) AS alg2_enr
	,sum(GREATEST(bio.TOT_SCIENR_BIOL_M,0) + GREATEST(bio.TOT_SCIENR_BIOL_F,0)) AS bio_enr
	,sum(GREATEST(calc.TOT_MATHENR_CALC_M,0) + GREATEST(calc.TOT_MATHENR_CALC_F,0)) AS calc_enr
	,sum(GREATEST(chem.TOT_SCIENR_CHEM_M,0) + GREATEST(chem.TOT_SCIENR_CHEM_F,0)) AS chem_enr
	,sum(GREATEST(dual.TOT_DUAL_M,0) + GREATEST(dual.TOT_DUAL_F,0)) AS dual_enr
	,sum(GREATEST(enr.tot_enr_m,0) + GREATEST(enr.tot_enr_f,0)) AS total_enr
	,sum(GREATEST(enr.SCH_ENR_LEP_M,0) + GREATEST(enr.SCH_ENR_LEP_F,0)) AS enr_lep
	,sum(GREATEST(enr.SCH_ENR_504_M,0) + GREATEST(enr.SCH_ENR_504_F,0)) AS enr_504
	,sum(GREATEST(enr.SCH_ENR_IDEA_M,0) + GREATEST(enr.SCH_ENR_IDEA_F,0)) AS enr_idea
	,sum(GREATEST(geo.TOT_MATHENR_GEOM_M,0) + GREATEST(geo.TOT_MATHENR_GEOM_F,0)) AS geo_enr
	,sum(GREATEST(phys.TOT_SCIENR_PHYS_M,0) + GREATEST(phys.TOT_SCIENR_PHYS_F,0)) AS phys_enr
	,sum(GREATEST(satact.TOT_SATACT_M,0) + GREATEST(satact.TOT_SATACT_F,0)) AS satact
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