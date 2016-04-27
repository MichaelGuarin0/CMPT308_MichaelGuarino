--Author: Michael Guarino--
--Class: CMPT308--
--Assignment: iCongress Design Project--
drop view BillVoteByParty;
drop view ElectedOfficialVoteByBill;
drop view CommitteeMembershipByTitleAndMemberName;
drop view SenatorsByNameAndState;
drop view RepresentativesByNameAndState;
drop view PartyAffiliationByAvgAge;
DROP TABLE IF EXISTS Committee_Bill_Assignment;
DROP TABLE IF EXISTS CommitteeMembership;
DROP TABLE IF EXISTS Committees;
DROP TABLE IF EXISTS BillSponsors;
DROP TABLE IF EXISTS Votes;
DROP TABLE IF EXISTS Bills;
DROP TABLE IF EXISTS Representatives;
DROP TABLE IF EXISTS Senators;
DROP TABLE IF EXISTS Positions;
DROP TABLE IF EXISTS ElectedOfficials;
DROP TYPE CurrentStatuses;
DROP TYPE States;
DROP TYPE SenatorRanks;
DROP TYPE Committee_Types;
DROP TYPE Committee_Roles;
DROP TYPE VoteValues;
DROP TYPE Genders;
DROP TYPE PositionValues;

--++++++++++++Create Tables Section++++++++++++--
--Create Enumerated Type Genders--
CREATE TYPE Genders AS ENUM (
  'Male',
  'Female'
);

--Create Table ElectedOfficials--
CREATE TABLE IF NOT EXISTS ElectedOfficials (
  ElectedOfficial_id VARCHAR(5) NOT NULL UNIQUE,
  FirstName          TEXT       NOT NULL,
  MiddleName         TEXT       NOT NULL,
  LastName           TEXT       NOT NULL,
  Gender             Genders,
  DateOfBirth        DATE       NOT NULL,
  USCitizen          BOOLEAN DEFAULT TRUE,
  PartyAffiliation   TEXT       NOT NULL CHECK (PartyAffiliation IN ('Republican', 'Democrat', 'Other')),
  PRIMARY KEY (ElectedOfficial_id)
);

--Create Enumerated Type CurrentStatuses--
CREATE TYPE CurrentStatuses AS ENUM (
  'introduced',
  'killed',
  'passed'
);

--Create Table Bills--
CREATE TABLE IF NOT EXISTS Bills (
  Bill_id        VARCHAR(10)     NOT NULL UNIQUE,
  BillTitle      TEXT            NOT NULL,
  DateIntroduced DATE            NOT NULL,
  CurrentStatus  CurrentStatuses NOT NULL DEFAULT 'introduced',
  PRIMARY KEY (Bill_id)
);

--Create Enumerated Type Committee_Types--
CREATE TYPE Committee_Types AS ENUM (
  'senate',
  'house',
  'joint'
);

--Create Table Committees--
CREATE TABLE IF NOT EXISTS Committees (
  Committee_id    VARCHAR(6)      NOT NULL UNIQUE,
  Committee_Title TEXT            NOT NULL,
  Committee_Type  Committee_Types NOT NULL,
  PRIMARY KEY (Committee_id)
);

--Create Enumerated Type Committee_Roles--
CREATE TYPE Committee_Roles AS ENUM (
  'Member',
  'Ranking Member',
  'Vice Chairman',
  'Ex Officio',
  'Chairman'
);

--Create Table CommitteeMembership--
CREATE TABLE IF NOT EXISTS CommitteeMembership (
  Committee_id       VARCHAR(20)     NOT NULL,
  ElectedOfficial_id VARCHAR(5)      NOT NULL,
  Committee_Role     Committee_Roles NOT NULL,
  PRIMARY KEY (Committee_id, ElectedOfficial_id),
  FOREIGN KEY (Committee_id) REFERENCES Committees (Committee_id),
  FOREIGN KEY (ElectedOfficial_id) REFERENCES ElectedOfficials (ElectedOfficial_id)
);

--Create Table Committee_Bill_Assignment--
CREATE TABLE IF NOT EXISTS Committee_Bill_Assignment (
  Bill_id       VARCHAR(10) NOT NULL,
  Committee_id  VARCHAR(20) NOT NULL,
  FloorSchedule DATE        NOT NULL,
  PRIMARY KEY (Bill_id, Committee_id),
  FOREIGN KEY (Bill_id) REFERENCES Bills (Bill_id),
  FOREIGN KEY (Committee_id) REFERENCES Committees (Committee_id)
);

--Create Table BillSponsors--
CREATE TABLE IF NOT EXISTS BillSponsors (
  ElectedOfficial_id VARCHAR(5)  NOT NULL,
  Bill_id            VARCHAR(10) NOT NULL,
  PRIMARY KEY (ElectedOfficial_id, Bill_id),
  FOREIGN KEY (ElectedOfficial_id) REFERENCES ElectedOfficials (ElectedOfficial_id),
  FOREIGN KEY (Bill_id) REFERENCES Bills (Bill_id)
);

--Create Enumerated Type PositionValues--
CREATE TYPE PositionValues AS ENUM (
  'Senator',
  'Representative'
);

--Create Table Positions--
CREATE TABLE IF NOT EXISTS Positions (
  Position_id PositionValues NOT NULL UNIQUE,
  TermLength  INT            NOT NULL,
  TermLimit   BOOLEAN        NOT NULL,
  PRIMARY KEY (Position_id)
);

--Create Enumerated Type States--
CREATE TYPE States AS ENUM (
  'New York',
  'Florida',
  'California',
  'Arizona'
);

--Create Table Representatives--
CREATE TABLE IF NOT EXISTS Representatives (
  ElectedOfficial_id VARCHAR(5)     NOT NULL UNIQUE,
  Position_id        PositionValues NOT NULL CHECK (Position_id = 'Representative'),
  StartDate          DATE           NOT NULL,
  StateRepresenting  States         NOT NULL,
  PRIMARY KEY (ElectedOfficial_id, Position_id),
  FOREIGN KEY (ElectedOfficial_id) REFERENCES ElectedOfficials (ElectedOfficial_id),
  FOREIGN KEY (Position_id) REFERENCES Positions (Position_id)
);

--Create Enumerated Type SenatorRanks--
CREATE TYPE SenatorRanks AS ENUM (
  'Senior',
  'Junior'
);

--Create Table Senators--
CREATE TABLE IF NOT EXISTS Senators (
  ElectedOfficial_id VARCHAR(5)     NOT NULL UNIQUE,
  Position_id        PositionValues NOT NULL CHECK (Position_id = 'Senator'),
  StartDate          DATE           NOT NULL,
  StateRepresenting  States         NOT NULL,
  SenatorRank        SenatorRanks   NOT NULL,
  PRIMARY KEY (ElectedOfficial_id),
  FOREIGN KEY (ElectedOfficial_id) REFERENCES ElectedOfficials (ElectedOfficial_id),
  FOREIGN KEY (Position_id) REFERENCES Positions (Position_id)
);

--Create Enumerated Type VoteValues--

CREATE TYPE VoteValues AS ENUM (
  'For',
  'Against'
);

--Create Table Votes--
CREATE TABLE IF NOT EXISTS Votes (
  Bill_id            VARCHAR(30) NOT NULL,
  ElectedOfficial_id VARCHAR(5)  NOT NULL,
  VoteValue          VoteValues  NOT NULL,
  DateOfVote         DATE        NOT NULL,
  PRIMARY KEY (ElectedOfficial_id, Bill_id),
  FOREIGN KEY (Bill_id) REFERENCES Bills (Bill_id),
  FOREIGN KEY (ElectedOfficial_id) REFERENCES ElectedOfficials (ElectedOfficial_id)
);

--++++++++++++Create View Section++++++++++++--

--Create SenatorsByNameAndState View--
create view SenatorsByNameAndState
as
select ElectedOfficials.FirstName,
       ElectedOfficials.LastName,
       Senators.Position_id,
       Senators.StateRepresenting,
       Senators.StartDate,
       Senators.SenatorRank
from Senators
inner join ElectedOfficials
on Senators.ElectedOfficial_id=ElectedOfficials.ElectedOfficial_id;

--Create RepresentativesByNameAndState View--
create view RepresentativesByNameAndState
as
select ElectedOfficials.FirstName,
       ElectedOfficials.LastName,
       Representatives.Position_id,
       Representatives.StateRepresenting,
       Representatives.StartDate
from Representatives
inner join ElectedOfficials
on Representatives.ElectedOfficial_id=ElectedOfficials.ElectedOfficial_id;

--Create CommitteeMembershipByNames View--
create view CommitteeMembershipByTitleAndMemberName
as
select Committees.Committee_Title,
       Committees.Committee_Type,
       ElectedOfficials.FirstName,
       ElectedOfficials.LastName,
       CommitteeMembership.Committee_Role
from Committees
inner join CommitteeMembership
on Committees.Committee_id=CommitteeMembership.Committee_id
inner join ElectedOfficials
on CommitteeMembership.ElectedOfficial_id=ElectedOfficials.ElectedOfficial_id;

--Create ElectedOfficialVoteByBill View--
create or replace view ElectedOfficialVoteByBill
as
select Bills.BillTitle,
       ElectedOfficials.FirstName,
       ElectedOfficials.LastName,
       ElectedOfficials.PartyAffiliation,
       Votes.VoteValue
from Bills
inner join Votes
on Bills.Bill_id=Votes.Bill_id
inner join ElectedOfficials
on Votes.ElectedOfficial_id=ElectedOfficials.ElectedOfficial_id
order by Bills.BillTitle;

--Create ElectedOfficialVoteByBill View--
create or replace view BillVoteByParty
as
select Bills.BillTitle,
       ElectedOfficials.PartyAffiliation,
       Votes.VoteValue,
       Count(Votes.VoteValue)
from Bills
inner join Votes on Bills.Bill_id=Votes.Bill_id
inner join ElectedOfficials on Votes.ElectedOfficial_id=ElectedOfficials.ElectedOfficial_id
Group by (Bills.BillTitle, ElectedOfficials.PartyAffiliation,Votes.VoteValue)
order by Bills.BillTitle;

--Create PartyAffiliationByAvgAge View--
create or replace view PartyAffiliationByAvgAge
as
select PartyAffiliation, avg(date_part('year',age(DateOfBirth)))
from ElectedOfficials
group by PartyAffiliation;

--++++++++++++Populate Tables Section++++++++++++--
--Populate ElectedOfficials Table--
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('eo1z1', 'Alexander', 'Daddy', 'Hamilton', 'Male', '01-11-1755', TRUE, 'Other');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('a4hn2', 'Benjamin', 'Daddy', 'Franklin', 'Male', '01-17-1706', TRUE, 'Other');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('b3zi3', 'John', 'E', 'McCain', 'Male', '08-29-1936', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('jzkq4', 'Jeff', 'J', 'Flake', 'Male', '12-31-1962', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('d3kz5', 'Bill', 'C', 'Nelson', 'Male', '09-29-1942', TRUE, 'Democrat');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('z1uz6', 'Marco', 'L', 'Rubio', 'Male', '05-28-1971', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('y3ub7', 'Chuck', 'N', 'Schumer', 'Male', '10-23-1950', TRUE, 'Democrat');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('m7po8', 'Kirsten', 'D', 'Gillibrand', 'Female', '12-26-1966', TRUE, 'Democrat');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('k0ti9', 'Dianne', 'A', 'Feinstein', 'Female', '06-22-1933', TRUE, 'Democrat');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('cr510', 'Barbara', 'N', 'Boxer', 'Female', '10-11-1940', TRUE, 'Democrat');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('sp211', 'Barbara', 'I', 'Boxer', 'Female', '10-11-1940', TRUE, 'Democrat');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('hp212', 'Matt', 'E', 'Salmon', 'Male', '10-11-1958', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('hp213', 'Raul', 'L', 'Grijalva', 'Male', '10-11-1948', TRUE, 'Democrat');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('hp214', 'Jeff', 'C', 'Denham', 'Male', '10-11-1967', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('hp215', 'Paul', 'R', 'Cook', 'Male', '10-11-1943', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('hp216', 'Ami', 'A', 'Bera', 'Male', '10-11-1965', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('hp217', 'Tom', 'I', 'Rooney', 'Male', '10-11-1970', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('hp218', 'Patrick', 'G', 'Murphy', 'Male', '10-11-1983', TRUE, 'Republican');
INSERT INTO ElectedOfficials (ElectedOfficial_id, FirstName, MiddleName, LastName, Gender, DateOfBirth, USCitizen, PartyAffiliation)
VALUES ('hp219', 'Gregory', 'Q', 'Meeks', 'Male', '10-11-1953', TRUE, 'Democrat');

--Populate Positions Table--
INSERT INTO Positions (Position_id, TermLength, TermLimit)
VALUES ('Senator', 6, FALSE);
INSERT INTO Positions (Position_id, TermLength, TermLimit)
VALUES ('Representative', 2, FALSE);

--Populate Representatives Table--
INSERT INTO Representatives (ElectedOfficial_id, Position_id, StartDate, StateRepresenting)
VALUES ('hp212', 'Representative', '01-30-2003', 'Arizona');
INSERT INTO Representatives (ElectedOfficial_id, Position_id, StartDate, StateRepresenting)
VALUES ('hp213', 'Representative', '01-30-2013', 'Arizona');
INSERT INTO Representatives (ElectedOfficial_id, Position_id, StartDate, StateRepresenting)
VALUES ('hp214', 'Representative', '01-30-2011', 'California');
INSERT INTO Representatives (ElectedOfficial_id, Position_id, StartDate, StateRepresenting)
VALUES ('hp215', 'Representative', '01-30-2013', 'California');
INSERT INTO Representatives (ElectedOfficial_id, Position_id, StartDate, StateRepresenting)
VALUES ('hp216', 'Representative', '01-30-2013', 'California');
INSERT INTO Representatives (ElectedOfficial_id, Position_id, StartDate, StateRepresenting)
VALUES ('hp217', 'Representative', '01-30-2009', 'Florida');
INSERT INTO Representatives (ElectedOfficial_id, Position_id, StartDate, StateRepresenting)
VALUES ('hp218', 'Representative', '01-30-2013', 'Florida');
INSERT INTO Representatives (ElectedOfficial_id, Position_id, StartDate, StateRepresenting)
VALUES ('hp219', 'Representative', '01-30-1998', 'New York');

--Populate Senators Table--
INSERT INTO Senators (ElectedOfficial_id, Position_id, StartDate, StateRepresenting, SenatorRank)
VALUES ('b3zi3', 'Senator', '01-03-1987', 'Arizona', 'Senior');
INSERT INTO Senators (ElectedOfficial_id, Position_id, StartDate, StateRepresenting, SenatorRank)
VALUES ('jzkq4', 'Senator', '01-03-2013', 'Arizona', 'Junior');
INSERT INTO Senators (ElectedOfficial_id, Position_id, StartDate, StateRepresenting, SenatorRank)
VALUES ('d3kz5', 'Senator', '01-03-2001', 'Florida', 'Senior');
INSERT INTO Senators (ElectedOfficial_id, Position_id, StartDate, StateRepresenting, SenatorRank)
VALUES ('z1uz6', 'Senator', '01-03-2011', 'Florida', 'Junior');
INSERT INTO Senators (ElectedOfficial_id, Position_id, StartDate, StateRepresenting, SenatorRank)
VALUES ('y3ub7', 'Senator', '01-03-1999', 'New York', 'Senior');
INSERT INTO Senators (ElectedOfficial_id, Position_id, StartDate, StateRepresenting, SenatorRank)
VALUES ('m7po8', 'Senator', '01-26-2009', 'New York', 'Junior');
INSERT INTO Senators (ElectedOfficial_id, Position_id, StartDate, StateRepresenting, SenatorRank)
VALUES ('k0ti9', 'Senator', '10-10-1992', 'California', 'Senior');
INSERT INTO Senators (ElectedOfficial_id, Position_id, StartDate, StateRepresenting, SenatorRank)
VALUES ('cr510', 'Senator', '01-03-1993', 'California', 'Junior');

--Populate Bills Table--
INSERT INTO Bills (Bill_id, BillTitle, DateIntroduced, CurrentStatus)
VALUES ('abnmz4oaa1', 'Freedom to Trump', '01-13-2017', 'introduced');
INSERT INTO Bills (Bill_id, BillTitle, DateIntroduced, CurrentStatus)
VALUES ('dafazjjaa2', 'Right to Arm Bears', '01-20-2017', 'introduced');
INSERT INTO Bills (Bill_id, BillTitle, DateIntroduced, CurrentStatus)
VALUES ('zafaaaaaa3', 'Ban all bike lanes', '01-25-2017', 'introduced');
INSERT INTO Bills (Bill_id, BillTitle, DateIntroduced, CurrentStatus)
VALUES ('ihjr58a9y4', 'Tuesday is ice cream day', '02-03-2017', 'introduced');
INSERT INTO Bills (Bill_id, BillTitle, DateIntroduced, CurrentStatus)
VALUES ('y2jro0a1k5', 'All magic tricks are real', '02-03-2017', 'introduced');

--Populate BillSponsors Table--
INSERT INTO BillSponsors (ElectedOfficial_id, Bill_id)
VALUES ('hp214', 'abnmz4oaa1');
INSERT INTO BillSponsors (ElectedOfficial_id, Bill_id)
VALUES ('z1uz6', 'dafazjjaa2');
INSERT INTO BillSponsors (ElectedOfficial_id, Bill_id)
VALUES ('cr510', 'zafaaaaaa3');
INSERT INTO BillSponsors (ElectedOfficial_id, Bill_id)
VALUES ('hp212', 'zafaaaaaa3');
INSERT INTO BillSponsors (ElectedOfficial_id, Bill_id)
VALUES ('hp219', 'ihjr58a9y4');
INSERT INTO BillSponsors (ElectedOfficial_id, Bill_id)
VALUES ('hp219', 'y2jro0a1k5');
INSERT INTO BillSponsors (ElectedOfficial_id, Bill_id)
VALUES ('eo1z1', 'y2jro0a1k5');
INSERT INTO BillSponsors (ElectedOfficial_id, Bill_id)
VALUES ('a4hn2', 'y2jro0a1k5');

--Populate Committee Table--
INSERT INTO Committees (committee_id, Committee_Title, Committee_Type)
VALUES ('uta01t', 'Argiculture, Nutrition, and Forestry', 'senate');
INSERT INTO Committees (committee_id, Committee_Title, Committee_Type)
VALUES ('utv8tl', 'Energy and Natural Resources', 'senate');
INSERT INTO Committees (committee_id, Committee_Title, Committee_Type)
VALUES ('pop99b', 'Health, Education, Labor, and Pensions', 'senate');
INSERT INTO Committees (committee_id, Committee_Title, Committee_Type)
VALUES ('yay7n1', 'Foreign Relations', 'joint');
INSERT INTO Committees (committee_id, Committee_Title, Committee_Type)
VALUES ('vox1jc', 'Rules and Administration', 'house');
INSERT INTO Committees (committee_id, Committee_Title, Committee_Type)
VALUES ('101sto', 'Governmental Affairs', 'house');
INSERT INTO Committees (committee_id, Committee_Title, Committee_Type)
VALUES ('ei78b2', 'Small Business and Entrepreneurship', 'house');

--Populate CommitteeMembership Table--
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('uta01t', 'eo1z1', 'Chairman');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('uta01t', 'a4hn2', 'Ranking Member');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('uta01t', 'b3zi3', 'Vice Chairman');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('uta01t', 'jzkq4', 'Ex Officio');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('uta01t', 'd3kz5', 'Member');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('utv8tl', 'eo1z1', 'Chairman');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('utv8tl', 'a4hn2', 'Ranking Member');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('pop99b', 'b3zi3', 'Vice Chairman');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('ei78b2', 'jzkq4', 'Ex Officio');
INSERT INTO CommitteeMembership (Committee_id, ElectedOfficial_id, Committee_Role)
VALUES ('yay7n1', 'd3kz5', 'Member');

--Populate Committee_Bill_Assignment Table--
INSERT INTO Committee_Bill_Assignment (Bill_id, Committee_id, FloorSchedule)
VALUES ('abnmz4oaa1', 'pop99b', '04-08-2017');
INSERT INTO Committee_Bill_Assignment (Bill_id, Committee_id, FloorSchedule)
VALUES ('dafazjjaa2', 'ei78b2', '03-21-2017');
INSERT INTO Committee_Bill_Assignment (Bill_id, Committee_id, FloorSchedule)
VALUES ('zafaaaaaa3', 'yay7n1', '03-10-2017');
INSERT INTO Committee_Bill_Assignment (Bill_id, Committee_id, FloorSchedule)
VALUES ('dafazjjaa2', 'yay7n1', '03-19-2017');
INSERT INTO Committee_Bill_Assignment (Bill_id, Committee_id, FloorSchedule)
VALUES ('ihjr58a9y4', 'pop99b', '05-05-2017');
INSERT INTO Committee_Bill_Assignment (Bill_id, Committee_id, FloorSchedule)
VALUES ('y2jro0a1k5', 'utv8tl', '08-30-2017');

--Populate Votes Table--
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('abnmz4oaa1', 'eo1z1', 'For', '02-01-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('abnmz4oaa1', 'd3kz5', 'Against', '02-01-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'k0ti9', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'sp211', 'Against', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'cr510', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'z1uz6', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'hp213', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'hp215', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'hp217', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'hp214', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('dafazjjaa2', 'hp216', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('ihjr58a9y4', 'hp214', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('ihjr58a9y4', 'z1uz6', 'Against', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('ihjr58a9y4', 'hp212', 'Against', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('ihjr58a9y4', 'sp211', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('ihjr58a9y4', 'k0ti9', 'For', '03-18-2018');
insert into Votes(Bill_id, ElectedOfficial_id, VoteValue, DateOfVote)
values ('ihjr58a9y4', 'm7po8', 'For', '03-18-2018');

create role admin;
Grant select, update, insert, delete
on all tables in schema Public
to admin;

create role generalUser;
grant select
on table Bills,
ElectedOfficials,
Committees,
SenatorsByNameAndState,
RepresentativesByNameAndState,
CommitteeMembershipByTitleAndMemberName,
ElectedOfficialVoteByBill,
BillVoteByParty,
PartyAffiliationByAvgAge
to generalUser;
