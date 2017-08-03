-*- mode: sql;-*-

#---
#create tables
#---

create table orgs (
id int primary key,
name varchar(100),
streetaddr varchar(200),
city varchar(100),
state char(2),
zip char(5),
phone char(10)
);

create table researchers (
id int primary key,
name varchar(100),
org int references orgs(id)
);

create table programs (
id int primary key,
name varchar(200),
directorate char(3) -- the top-level part of NSF that runs this program
);

create table managers (
id int primary key,
name varchar(100));

create table grants (
id int primary key,
title varchar(300),
amount float,
org int references orgs(id),
pi int references researchers(id), -- the principal investigator (PI) on the grant
manager int references managers(id),
started date,
ended date,
abstract text
);

create table grant_researchers (
researcherid int references researchers(id),
grantid int references grants(id)
);

create table fields (
id int primary key,
name varchar(100)
);

create table grant_fields (
grantid int references grants(id),
fieldid int references fields(id)
);

create table grant_programs(
grantid int references grants(id),
programid int references programs(id)
);


#Note: assuming dB imported

#---
#Queries
#---

#Find the title and amount of the grants for which Professor Smith is the supervisor.

SELECT title, amount
FROM grants, researchers
WHERE researchers.id = pi and researchers.name like ’%Smith’;

#Find the number of times an MIT researcher has received (not necessarily a PI) a grant over $500 000 since 1/1/2010. 
#Retrieve the name of the researcher and the number of such grants awarded.

SELECT researchers.name, count(*) as count
FROM researchers, orgs, grant_researchers, grants
WHERE researchers.org = orgs.id
and orgs.name = ’Massachusetts Institute of Technology’
and grants.id = grant_researchers.grantid
and grant_researchers.researcherid = researchers.id
and grants.amount > 500 000
and grants.started >= ’2010-01-01’
GROUP BY researchers.name;

#Find the organizations that have received the same number of grants for 3 years in a row, with at least 7 grants per year. 
#Report the name of the organization, the number of grants, and the years they received the grants.

CREATE local temp table foo as
SELECT org, started, count(*) as c
FROM grants
GROUP BY org, started;

SELECT o.name, min(f1.started) as y1, min(f2.started) as y2,
min(f3.started) as y3, f1.c as num
FROM orgs as o, foo as f1, foo as f2, foo as f3
WHERE f1.org = f2.org and f1.org = f3.org and
extract(’year’ from f1.started) + 1 = extract(’year’ from f2.started) and
extract(’year’ from f1.started) + 2 = extract(’year’ from f3.started) and
f1.c = f2.c and f1.c = f3.c and f1.c > 7 and
o.id = f1.org
GROUP BY o.name, f1.c;


#Find the researchers that have received grants from 8 or more directorates. 
#Retrieve the researcher name and the number of directorates he/she has received grants from. 
#Order the results in descending order by the number of directorates, and return the first 10.

SELECT r.name, count(distinct(p.directorate)) as c
FROM grants as g, grant_researchers as gr,
grant_programs as gp, researchers as r, programs as p
WHERE g.id = gr.grantid and r.id = gr.researcherid and
gp.grantid = g.id and gp.programid = p.id
GROUP BY r.name
HAVING count(distinct(p.directorate)) >= 8
ORDER BY c
LIMIT 10;

#Find the managers who have given the most amount of money to a single organization. 
#For the 5 highest amounts retrieve the manager name, organization name, and the total amount given.

SELECT m.name as mname, o.name as oname, sum(amount) as totamount
FROM grants as g, managers as m, orgs as o
WHERE g.manager = m.id and g.org = o.id
GROUP BY mname, oname
ORDER BY totamount desc
LIMIT 5;

#Find the researchers that received more than $1 million in grants one year, 
#did not receive grants the subsequent year, 
#then received more than $1 million in grants the 3rd year.

CREATE LOCAL TEMP TABLE gtmp as
SELECT pi, extract(’year’ from started) as year,
sum(amount) as amount, count(*)
FROM grants GROUP BY pi, year;

CREATE LOCAL TEMP TABLE gtmp2 as
SELECT g1.pi, g1.year
FROM gtmp as g1, gtmp as g3
WHERE g1.year + 2 = g3.year and g1.pi = g3.pi and
g1.amount > 1000000 and g3.amount > 1000000;

SELECT r.name, min(gtmp2.year) as y
FROM gtmp2, gtmp, researchers as r
WHERE gtmp2.pi not in (SELECT pi FROM gtmp as g2
WHERE g2.year = gtmp2.year + 1) and
r.id = gtmp2.pi
GROUP BY name;

