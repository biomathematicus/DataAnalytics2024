-- Get unmatched SAIPE records
select s.state_abbr state, 
	saipe.districtid,
	saipe.nameschooldistrict,
	saipe.totalpopulation total_pop,
	saipe.population5_17 pop_5_17,
	saipe.population5_17inpoverty pop_5_17inpoverty
from data_schema.saipe_ussd17 saipe
join ref_schema.ref_state s
on s.state_code = saipe.state_code
where length(leaid)<1
order by cast(totalpopulation as int) desc;

-- Another version
select * from data_schema.saipe_ussd17
where length(leaid)<1;

-- currently unmapped: 248/13223 districts for 131k / 54m aged 5-17
SELECT COUNT(*), SUM(CAST(population5_17 AS INT))
FROM data_schema.saipe_ussd17
WHERE leaid = ''
union
SELECT COUNT(*), SUM(CAST(population5_17 AS INT))
FROM data_schema.saipe_ussd17;

-- TODO : HS_only unmatched