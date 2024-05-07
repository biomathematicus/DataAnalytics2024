declare @a as float, @b as float, @c as float, @d as float;
declare @CourseLevel as integer;
declare @GPA as float
set @CourseLevel = 3999
set @GPA = 3

-- Print paramters
select '@CourseLevel = ' + cast(@CourseLevel as varchar(5)) + '. @GPA = ' + cast(@GPA as varchar(4));

-- AP Calculus vs. senior courses
select @a = (
		SELECT	count(distinct IDENTIFIER)
		from	OIR 
		where	CAP = 0
				AND cast(CT_SUBJECT as integer) > 3999
				and [MAT1214_AP_GRDE] = 'CR' 
		), @b = (
		SELECT	count(distinct IDENTIFIER)
		from	OIR 
		where	CAP = 0
				AND cast(CT_SUBJECT as integer) < 3999
				and [MAT1214_AP_GRDE] = 'CR'
		), @c = (
		SELECT	count(distinct IDENTIFIER)
		from	OIR 
		where	CAP = 0
				AND cast(CT_SUBJECT as integer) > 3999
				and [MAT1214_AP_GRDE] is null 
		), @d = (
		SELECT	count(distinct IDENTIFIER)
		from	OIR 
		where	CAP = 0
				AND cast(CT_SUBJECT as integer) < 3999
				and [MAT1214_AP_GRDE] is null 
		);
select 'AP Calculus vs. senior courses', @a as a, @b as b, @c as c, @d as d, (@a/@c) / (@b/@d) as 'Odds Ratio'


-- AP Calculus vs. graduation
select @a = (
		SELECT	count(distinct IDENTIFIER)
		from	OIR 
		where	CAP = 0
				and FIRSTGRADDATE is not null
				and [MAT1214_AP_GRDE] = 'CR' 
		), @b = (
		SELECT	count(distinct IDENTIFIER)
		from	OIR 
		where	CAP = 0
				and FIRSTGRADDATE is null
				and [MAT1214_AP_GRDE] = 'CR'
		), @c = (
		SELECT	count(distinct IDENTIFIER)
		from	OIR 
		where	CAP = 0
				and FIRSTGRADDATE is not null
				and [MAT1214_AP_GRDE] is null 
		), @d = (
		SELECT	count(distinct IDENTIFIER)
		from	OIR 
		where	CAP = 0
				and FIRSTGRADDATE is null
				and [MAT1214_AP_GRDE] is null 
		);
select 'AP Calculus vs. graduation', @a as a, @b as b, @c as c, @d as d, (@a/@c) / (@b/@d) as 'Odds Ratio'


-- AP Calculus vs. overall GPA B or higher
select @a = (
		select	count(*) a  -- SQL Server requires alias here
		from	(
				select	count(distinct IDENTIFIER) a  -- SQL Server requires alias here
				from	OIR 
				where	CAP = 0
						and [MAT1214_AP_GRDE] = 'CR' 
				group by IDENTIFIER
				having  avg(cast([SHRGRDE_QUALITY_POINTS] as float)) >= @GPA
				) as A1  -- SQL Server requires alias here
		), @b = (
		select	count(*) b  -- SQL Server requires alias here
		from	(
				select	count(distinct IDENTIFIER) b  -- SQL Server requires alias here
				from	OIR 
				where	CAP = 0
						and [MAT1214_AP_GRDE] = 'CR' 
				group by IDENTIFIER
				having  avg(cast([SHRGRDE_QUALITY_POINTS] as float)) < @GPA
				) as B1  -- SQL Server requires alias here
		), @c = (
		select	count(*) c  -- SQL Server requires alias here
		from	(
				select	count(distinct IDENTIFIER) c  -- SQL Server requires alias here
				from	OIR 
				where	CAP = 0
						and [MAT1214_AP_GRDE] is null 
				group by IDENTIFIER
				having  avg(cast([SHRGRDE_QUALITY_POINTS] as float)) >= @GPA
				) as C1  -- SQL Server requires alias here
		), @d = (
		select	count(*) d -- SQL Server requires alias here
		from	(
				select	count(distinct IDENTIFIER) d  -- SQL Server requires alias here
				from	OIR 
				where	CAP = 0
						and [MAT1214_AP_GRDE] is null 
				group by IDENTIFIER
				having  avg(cast([SHRGRDE_QUALITY_POINTS] as float)) < @GPA
				) as D1  -- SQL Server requires alias here
		);
select 'AP Calculus vs. overall GPA B or higher', @a as a, @b as b, @c as c, @d as d, (@a/@c) / (@b/@d) as 'Odds Ratio'


/*

RESULTS: 


---------------------------------
@CourseLevel = 3999. @GPA = 3

(1 row affected)

                               a                      b                      c                      d                      Odds Ratio
------------------------------ ---------------------- ---------------------- ---------------------- ---------------------- ----------------------
AP Calculus vs. senior courses 902                    1725                   40504                  83940                  1.08364863588352

(1 row affected)

                           a                      b                      c                      d                      Odds Ratio
-------------------------- ---------------------- ---------------------- ---------------------- ---------------------- ----------------------
AP Calculus vs. graduation 637                    1131                   29856                  56025                  1.05688338507595

(1 row affected)

                                        a                      b                      c                      d                      Odds Ratio
--------------------------------------- ---------------------- ---------------------- ---------------------- ---------------------- ----------------------
AP Calculus vs. overall GPA B or higher 1173                   552                    28018                  55949                  4.24340156328075

(1 row affected)


Completion time: 2024-05-07T09:19:13.1405178-05:00



*/
