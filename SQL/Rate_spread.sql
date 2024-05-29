copy (
	select 
		--a.census_tract_number,
		b."leaid", b."name_lea17",denial_reason_name_1,
		avg(cast(a.loan_amount_000s as float)) as loan_amount_000s,
		avg(cast(a.applicant_income_000s as float)) as applicant_income_000s,
		avg(cast(a.rate_spread as float)) as avg_rate_spread,
		stddev(cast(a.rate_spread as float)) as StandardDeviation,
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
	from 
		"CRDB".hmda_2017_nationwide_allrecords_labels a
	join 
		"CRDB".grf17_lea_tract b 
	on 
		right(trim(b."tract"), 6) = replace(trim(a.census_tract_number), '.', '')
	join 
		"CRDB".hstotals() h
	on	h."leaid" = b."leaid"
		
	where 
		a.census_tract_number is not null 
		and trim(a.census_tract_number) <> ''
		and length(replace(trim(a.census_tract_number), '.', '')) = 6
		and length(trim(b."tract")) >= 10
		and a.rate_spread <> ''  -- this condition filters out empty strings
	group by 
		--a.census_tract_number,
		b."leaid", b."name_lea17", denial_reason_name_1, apmath, advmath, apscience, apothers, algii, bio, cal, chem, geo, phy
	order by 
		b."name_lea17"
)
to 	'C:\Dropbox\!JBGCourses\!2024\2024 Data Analytics\github\data\RATESPREADLEA.csv' 
WITH CSV HEADER;
	
