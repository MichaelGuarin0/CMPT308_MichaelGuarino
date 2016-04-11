drop table if exists roster;
drop table if exists teams;
drop table if exists assistantCoaches_Teams;

drop table if exists headcoaches;
drop table if exists assistantcoaches;

drop table if exists players;

drop table if exists coaches;

drop table if exists people;
drop table if exists zip;

--zip table--
create table zip(
	zipCode integer,
	city text,
	state text,
	primary key(zipCode)
);

--people table--
create table people(
	peopleID char(4) not null,
	zip integer references zip(zipCode),
	streetAddress text,
	country varchar(20),
	firstName text,
	lastName text,
	phoneNumber integer,
	primary key(peopleID)
);

--players table(sub-entity of people)--
create table players(
	playerID char(4) not null,
	primary key(playerID),
	Foreign key(playerID) references people(peopleID)
);

--coaches table(sub-entity of people)--
create table coaches(
	coachID char(4) not null,
	yearsCoached integer,
	primary key(coachID),
	Foreign key(coachID) references people(peopleID)
);

--create table headcoaches table(sub-entity of coaches)--
create table headcoaches(
	headCoachID char(4) not null,
	primary key(headCoachID),
	Foreign key(headCoachID) references coaches(coachID)
);

--create table assistantcoaches table(sub-entity of coaches)--
create table assistantcoaches(
	assistantCoachID char(4) not null,
	primary key(assistantCoachID),
	Foreign key(assistantCoachID) references coaches(coachID)
);

--create table roster--
create table roster(
	playerID char(4) not null,
	teamID char(4) not null,
	primary key(playerID,teamID)
);

--create ageGroup enumerated types
create type ageGroups as enum(
	'<10',
	'10-14',
	'>14'
);

--create table teams--
create table teams(
	teamID char(4) not null,
	headCoachID char(4) not null,
	ageGroup ageGroups,
	constraint headCoachOnlyOneTeamPerAgeGroup unique(teamID,headCoachID,ageGroup),
	primary key(teamID)
);

--create table assistantcoachToTeam--
create table assistantCoaches_Teams(
	teamID char(4) not null,
	assistantCoachID char(4) not null,
	primary key(teamID,assistantCoachID)
);
