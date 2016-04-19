-- Michael Guarino
-- Alan Labouseur
-- CMPT 308 Database Systems
-- April 19, 2016
-- Lab10: Stored Procedures

--Stored Procedure 1: returns the immediate prerequisites for the passed-in course number.--
create or replace function PreReqsFor(int, REFCURSOR) returns refcursor as
$$
declare
   courseNumber int:= $1;
   resultset REFCURSOR:= $2;
begin
   open resultset for
      select preReqNum
      from Prerequisites
      where courseNumber=courseNum;
   return resultset;
end;
$$
language plpgsql;

select PreReqsFor(499, 'results');
Fetch all from results;


--Stored Procedure 2: returns the courses for which the passed-in course number is an immediate prerequisite.--
create or replace function isPreReqsFor(int, REFCURSOR) returns refcursor as
$$
declare
   courseNumber int:= $1;
   resultset REFCURSOR:= $2;
begin
   open resultset for
      select courseNum
      from Prerequisites
      where courseNumber=preReqNum;
   return resultset;
end;
$$
language plpgsql;

select isPreReqsFor(120, 'results');
Fetch all from results;
