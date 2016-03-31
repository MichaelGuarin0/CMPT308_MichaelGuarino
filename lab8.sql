drop table if exists people;
drop table if exists actors;
drop table if exists directors;
drop Table if exists movies;
drop table if exists actor_movie;
drop table if exists director_movie;


--+Create Tables---------------------
--create table people (Strong Entity)
create table people(
	pid char(4) not null,
	completeName text,
	address text,
	spouseName text,
	primary key(pid)
);

--create table actors (Strong Entity), Entity SubType of people
create table actors(
	aid char(4) not null,
	pid char(4) not null,
	DOB date,
	hairColor text,
	eyeColor text,
	height_inches float,
	weight_pounds float,
	SAG_AnnDate date,
	primary key(aid,pid)
);

--create table directors (Strong Entity), Entity SubType of people
create table directors(
	did char(4) not null,
	pid char(4) not null,
	filmSchool text,
	DG_AnnDate date,
	fav_lensMaker text,
	primary key(did,pid)
);

--create table movies (Strong Entity)
create table movies(
	mid char(4) not null,
	title text not null,
	yrReleased date,
	Dom_BoxOfficeSales numeric(12,2),
	Forgn_BoxOfficeSales numeric(12,2),
	DVD_BluRaySales numeric(12,2),
	primary key(mid)
);

--create table actor:movie (Weak Entity)
create table actor_movie(
	mid char(4) not null,
	aid char(4) not null,
	primary key(mid, aid)
);

--create table director:movie (Weak Entity)
create table director_movie(
	mid char(4) not null,
	did char(4) not null,
	primary key(mid, did)
);
--+Populate the tables---------------------------------
--populate people table
insert into people(pid, completeName, address, spouseName)
	values('P001','Sean Connery', 'Hollywood','Diane Cilento');
insert into people(pid, completeName, address, spouseName)
	values('P002','George Lazenby','Hollywood','Christina Gannett');
insert into people(pid, completeName, address, spouseName)
	values('P003','Roger Moore','Hollywood', 'Kristina Tholstrup');
insert into people(pid, completeName, address, spouseName)
	values('P004','Timothy Dalton','Hollywood','Vanessa Redgrave');
insert into people(pid, completeName, address, spouseName)
	values('P005', 'Pierce Brosnan','Hollywood','Cassandra Harris');
insert into people(pid, completeName, address, spouseName)
	values('p006', 'Daniel Craig(BOOOOOOOOO)','Hollywood','Rachel Weisz');
insert into people(pid, completeName, address, spouseName)
	values('P007','Eric Bana', 'Hollywood','Rebecca Gleeson');
insert into people(pid, completeName, address, spouseName)
	values('P008', 'Henry Cavill','Hollywood', null);
insert into people(pid, completeName, address, spouseName)
	values('P009', 'Charlie Sheen','Hollywood',null);
insert into people(pid, completeName, address, spouseName)
	values('P010', 'Terence Young','Hollywood','Sabine Sun');
insert into people(pid, completeName, address, spouseName)
	values('P011', 'Guy Hamilton','Hollywood','Naomi Chance');
insert into people(pid, completeName, address, spouseName)
	values('P012', 'Lewis Gilbert','Hollywood','Hylda Tafler');
insert into people(pid, completeName, address, spouseName)
	values('P013', 'Peter R. Hunt','Hollywood',null);
insert into people(pid, completeName, address, spouseName)
	values('P014', 'John Glen','Hollywood',null);
insert into people(pid, completeName, address, spouseName)
	values('P015', 'Martin Campbell','Hollywood','Sol E. Romero');
insert into people(pid, completeName, address, spouseName)
	values('P016', 'Roger Spottiswoode','Hollywood','Holly Palance');
insert into people(pid, completeName, address, spouseName)
	values('P017', 'Michael Apted','Hollywood','Paige Simpson');
insert into people(pid, completeName, address, spouseName)
	values('P018', 'Lee Tamahori','Hollywood',null);
insert into people(pid, completeName, address, spouseName)
	values('P019', 'Marc Forster','Hollywood',null);
insert into people(pid, completeName, address, spouseName)
	values('P020', 'Sam Mendes','Hollywood','Kate Winslet');

--populate actors table
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A001', 'P001', '08-25-1930', 'Black', 'Brown', 6.2, 170.0, '01-12-1960');
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A002', 'P002', '09-05-1939', 'Black', 'Brown', 6.2, 170.0, '01-12-1965');
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A003', 'P003', '10-14-1927', 'Black', 'Blue', 6.1, 170.0, '01-12-1970');
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A004', 'P004', '03-21-1946', 'Black', 'Blue', 6.2, 170.0, '01-12-1975');
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A005', 'P005', '05-16-1953', 'Brown', 'Blue', 6.2, 170.0, '01-12-1970');
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A006', 'P006', '03-02-1968', 'Blond', 'Blue', 5.2, 300.0, '01-12-1980');
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A007', 'P007', '08-09-1968', 'Black', 'Brown', 6.2, 170.0, '01-12-1990');
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A008', 'P008', '05-05-1983', 'Brown', 'Blue', 6.1, 170.0, '01-12-2000');
insert into actors(aid, pid, DOB, hairColor, eyeColor, height_inches, weight_pounds, SAG_AnnDate)
	values('A009', 'P009', '09-03-1965', 'Black', 'Brown', 10.0, 300.00, '01-12-1965');

--populate directors table
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D001', 'P010',null, '01-12-1910', 'zeiss');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D002', 'P011', null,'01-12-1920', 'canon');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D003', 'P012', null,'01-12-1930', 'zeiss');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D004', 'P013',null, '01-12-1940', 'zeiss');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D005', 'P014', null,'01-12-1950', 'canon');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D006', 'P015',null,'01-12-1960',  'canon' );
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D007', 'P016', null,'01-12-1970', 'zeiss');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D008', 'P017', null,'01-12-1980', 'canon');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D009', 'P018', null, '01-12-1990','canon');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D010', 'P019', 'NYU','01-12-2000', 'zeiss');
insert into directors(did, pid, filmSchool, DG_AnnDate, fav_lensMaker)
	values('D011', 'P020',null, '01-12-2010','zeiss');

--populate movies table
insert into movies(mid, title, yrReleased, Dom_BoxOfficeSales, Forgn_BoxOfficeSales)
	values('M001', 'Dr. NO', null, null, null);
insert into movies(mid, title, yrReleased, Dom_BoxOfficeSales, Forgn_BoxOfficeSales)
	values('M002', 'From Russia With Love', null, null, null);
insert into movies(mid, title, yrReleased, Dom_BoxOfficeSales, Forgn_BoxOfficeSales)
	values('M003', 'Goldfinger', null, null, null);
insert into movies(mid, title, yrReleased, Dom_BoxOfficeSales, Forgn_BoxOfficeSales)
	values('M004', 'Thunderball', null, null, null);
insert into movies(mid, title, yrReleased, Dom_BoxOfficeSales, Forgn_BoxOfficeSales)
	values('M005', 'You Only Live Twice', null, null, null);
insert into movies(mid, title, yrReleased, Dom_BoxOfficeSales, Forgn_BoxOfficeSales)
	values('M006', 'Diamonds Are Forever', null, null, null);

--populate actor_movie
insert into actor_movie(mid, aid)
	values('M001', 'A001');
insert into actor_movie(mid, aid)
	values('M002', 'A001');
insert into actor_movie(mid, aid)
	values('M003', 'A001');
insert into actor_movie(mid, aid)
	values('M004', 'A001');
insert into actor_movie(mid, aid)
	values('M005', 'A001');
insert into actor_movie(mid, aid)
	values('M006', 'A001');

--populate director_movie
insert into director_movie(mid, did)
	values('M001', 'D001');
insert into director_movie(mid, did)
	values('M002', 'D001');
insert into director_movie(mid, did)
	values('M003', 'D002');
insert into director_movie(mid, did)
	values('M004', 'D001');
insert into director_movie(mid, did)
	values('M005', 'D003');
insert into director_movie(mid, did)
	values('M006', 'D002');

--QUERY TO SHOW ALL DIRECTORS WITH WHOM ACTOR "SEAN CONNERY" HAS WORKED:
select completeName
from people p inner join directors d on p.pid=d.pid
inner join director_movie dm on d.did=dm.did
where dm.mid in
(select mid
from actor_movie am inner join actors a on am.aid=a.aid
inner join people p on a.pid=p.pid
where p.completeName='Sean Connery');
