use nycflights;
create table nycflightdelay as 
select dep_delay, 
       arr_delay, 
       flight
from nycflightdetails;

create table nycflightinformation as 
select carrier, 
        flight, 
        tailnum, 
        origin, 
        dest
from nycflightdetails;

create table nycflightschedule as 
select  year, 
        month, 
        day, 
        dep_time,
        sched_dep_time,
        arr_time,
        sched_arr_time,
        flight
from nycflightdetails;

create table nycflightduration as 
select  flight, 
        air_time, 
        distance, 
        hour,
        minute,
        time_hour
from nycflightdetails;

select * from nycflightdetails;
select * from nycflightdelay;
select * from nycflightduration;
select * from nycflightinformation;
select * from nycflightschedule;

select Distinct flight as flight_no from nycflightdetails;

select count(*) from nycflightdetails;

-- Flight details from origin LGA to Destination MSY
select flight, tailnum, carrier, origin, dest from nycflightdetails where 
origin = 'LGA' AND dest='MSY';

-- Were there more flights to Oakland in August 2013 or December 2013? 
Select 'August' as "Month", Count(*) as "Total Flights" From nycflightdetails
where dest='OAK' AND year = 2013 AND month = 8 UNION Select 'December', COUNT(*) 
FROM  nycflightdetails WHERE dest = 'OAK' AND year = 2013 AND month = 12;

-- Creating View 
CREATE OR REPLACE VIEW OAKFlights AS
Select 'August' as "Month", Count(*) as "Total Flights" From nycflightdetails
where dest='OAK' AND year = 2013 AND month = 8 UNION Select 'December', COUNT(*) 
FROM  nycflightdetails WHERE dest = 'OAK' AND year = 2013 AND month = 12;
select * from OAKFlights;

-- Flights with Arrival Delay less than 30 minutes
SELECT nycflightdetails.flight, nycflightdetails.origin, nycflightdetails.dest, 
nycflightdetails.carrier, nycflightdelay.dep_delay, nycflightdelay.arr_delay 
FROM nycflightdetails INNER JOIN nycflightdelay 
ON nycflightdetails.flight=nycflightdelay.flight where nycflightdelay.arr_delay <30;

-- How many flights went to Seattle
SELECT  COUNT(*) AS 'Total flights' FROM  nycflightdetails WHERE dest = 'SEA'; 

-- Flights from JFK to ORD
select count(flight) as flights_JFKORD from nycflightinformation
where origin='JFK' and dest='ORD';

-- Flights by American Airlines in August 2013
select carrier, count(flight) as flights_in_Aug from
nycflightdetails where year=2013 and month=8 and carrier='AA' and dest='IAH';

-- Total no.of flights from each carrier 
select carrier,count(flight) from nycflightdetails group by carrier;


-- what was the longest Airtime?
Select flight,air_time,distance from  nycflightduration where air_time > 0 
order by air_time DESC LIMIT 1;

-- What was the shortest air time for EV?
Select  nycflightduration.flight, nycflightduration.air_time, nycflightduration.distance,
 nycflightdetails.carrier from nycflightduration INNER JOIN nycflightdetails 
 ON nycflightduration.flight=nycflightdetails.flight where nycflightduration.air_time > 0 
 AND nycflightdetails.carrier = 'EV' order by nycflightduration.air_time LIMIT 1;

--  Arrival Delay and Depature Delay for flights from NC(EWR,LGA,JFK) to Seattle?
Select nycflightdelay.arr_delay, nycflightdelay.dep_delay, nycflightdetails.origin, nycflightdetails.dest AS 'Average Delay' from nycflightdelay INNER JOIN nycflightdetails 
 ON nycflightdelay.flight=nycflightdetails.flight where nycflightdelay.arr_delay > 0 
 AND nycflightdetails.dest='SEA' AND (nycflightdetails.origin='EWR' OR nycflightdetails.origin='JFK' OR nycflightdetails.origin='LGA');

--  What is the average arrival delay for flights from NC (EWR,LGA,JFK) to Seattle?
Select AVG(nycflightdelay.arr_delay) AS 'Average Arrival Delay' from nycflightdelay INNER JOIN nycflightdetails 
 ON nycflightdelay.flight=nycflightdetails.flight where nycflightdelay.arr_delay > 0 
 AND nycflightdetails.dest='SEA' AND (nycflightdetails.origin='EWR' OR nycflightdetails.origin='JFK' OR nycflightdetails.origin='LGA');
 
 --  What is the average depature delay for flights from NC (EWR,LGA,JFK) to Seattle?
Select AVG(nycflightdelay.dep_delay) AS 'Average Depature Delay' from nycflightdelay INNER JOIN nycflightdetails 
 ON nycflightdelay.flight=nycflightdetails.flight where nycflightdelay.dep_delay > 0 
 AND nycflightdetails.dest='SEA' AND (nycflightdetails.origin='EWR' OR nycflightdetails.origin='JFK' OR nycflightdetails.origin='LGA');
 
-- What was the worst day to fly out of NYC in 2013 if you dislike delayed flights?
select nycflightschedule.month, nycflightschedule.day, max(nycflightdelay.dep_delay) AS 'Max Departure Delay'from nycflightschedule  INNER JOIN nycflightdelay ON nycflightdelay.flight=nycflightschedule.flight;


