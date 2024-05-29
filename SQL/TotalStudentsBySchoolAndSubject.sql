copy (
	select lea_state, leaid, 
			'"' || lea_name || '"', lea_city, lea_zip, schid, 
			'"' || sch_name || '"', total, 
		   case when apmath < 0 then null else apmath end as apmath,
		   case when advmath < 0 then null else advmath end as advmath,
		   case when apscience < 0 then null else apscience end as apscience,
		   case when apothers < 0 then null else apothers end as apothers,
		   case when algii < 0 then null else algii end as algii,
		   case when bio < 0 then null else bio end as bio,
		   case when cal < 0 then null else cal end as cal,
		   case when chem < 0 then null else chem end as chem,
		   case when geo < 0 then null else geo end as geo,
		   case when phy < 0 then null else phy end as phy
	from "CRDB".hstotals()
)
to 	'C:\Dropbox\!JBGCourses\!2024\2024 Data Analytics\github\data\HIGHSCHOOLS.csv' 
WITH CSV HEADER;
