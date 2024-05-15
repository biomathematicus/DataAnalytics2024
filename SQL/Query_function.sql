--drop  function "CRDB".hstotals()
create or replace function "CRDB".hstotals()
returns table(lea_state varchar(300), leaid varchar(300), lea_name varchar(300), 
			 lea_city varchar(300), lea_zip varchar(300), schid varchar(300), 
			 sch_name varchar(300), total int, advmath int, apmath int, 
			 apscience int, apothers int, algii int, bio int, 
			 cal int, chem int, geo int, phy int) as
$$
begin return query

select e."lea_state", e."leaid", e."lea_name", lc."lea_city", lc."lea_zip", e."schid", e."sch_name",  
		cast(tot_enr_m as integer) + cast(tot_enr_f as integer) as total,
		cast(tot_mathenr_advm_m as integer) + cast(tot_mathenr_advm_f as integer) as advmath,
		cast(tot_apmathenr_m as integer) + cast(tot_apmathenr_f as integer) as apmath,
		cast(tot_apscienr_m as integer) + cast(tot_apscienr_f as integer) as apscience,
		cast(tot_apothenr_m as integer) + cast(tot_apothenr_f as integer) as apothers,
		cast(tot_mathenr_alg2_m as integer) + cast(tot_mathenr_alg2_f as integer) as algii,
		cast(tot_scienr_biol_m as integer) + cast(tot_scienr_biol_f as integer) as bio,
		cast(tot_mathenr_calc_m as integer) + cast(tot_mathenr_calc_f as integer) as cal,
		cast(tot_scienr_chem_m as integer) + cast(tot_scienr_chem_f as integer) as chem,
		cast(tot_mathenr_geom_m as integer) + cast(tot_mathenr_geom_f as integer) as geo,
		cast(tot_scienr_phys_m as integer) + cast(tot_scienr_phys_f as integer) as phy
from 	"CRDB".schoolcharacteristics sc
		join "CRDB".enrollment e 
		on sc.schid = e.schid and sc.leaid = e.leaid
		join "CRDB".leacharacteristics as lc
		on sc.leaid = lc.leaid
		join "CRDB".advancedmathematics av
		on av.schid = e.schid and av.leaid = e.leaid
		join "CRDB".advancedplacement ap
		on ap.schid = e.schid and ap.leaid = e.leaid
		join "CRDB".algebraii alg2
		on alg2.schid = e.schid and alg2.leaid = e.leaid
		join "CRDB".biology bio
		on bio.schid = e.schid and bio.leaid = e.leaid
		join "CRDB".calculus cal
		on cal.schid = e.schid and cal.leaid = e.leaid
		join "CRDB".chemistry che
		on che.schid = e.schid and che.leaid = e.leaid
		join "CRDB".geometry geo
		on geo.schid = e.schid and geo.leaid = e.leaid
		join "CRDB".physics phy
		on phy.schid = e.schid and phy.leaid = e.leaid
where	sch_grade_g09 = 'Yes'
		and sch_grade_g10  = 'Yes'
		and sch_grade_g11 = 'Yes'
		and sch_grade_g12 = 'Yes'
		and cast(tot_enr_m as integer) >= 0
		and cast(tot_enr_f as integer) >= 0
		and cast(tot_enr_m as integer) + cast(tot_enr_f as integer) > 0
order by e.lea_state, e.lea_name, e.sch_name;

end;
$$ language plpgsql

/* 
after the query is created, you can see the table by using this following command:

select * from "CRDB".hstotals();


*/
