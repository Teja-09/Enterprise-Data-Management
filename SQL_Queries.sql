select * from employees;

select * from authentication;

select * from bike_models;

select * from vendors;

with rideTime as (select tripid, (extract(HOUR FROM ((endtime)-(starttime))) * 3600 + extract(MINUTE FROM ((endtime)-(starttime))
    ) * 60 + extract(SECOND FROM ((endtime)-(starttime)))) as time1, age, c.custid from customers c 
inner join trips t on c.custid = t.custid)
select sum(time1) as SumTime, custid 
from rideTime
group by custid
order by SumTime desc;


WITH Quarters AS (         
SELECT
        YEAR,
        CEIL(MONTH / 3) AS QUARTER,
        sum(MONTHTOTAL) as monthtotal
    FROM
        monthly_revenue
        group by year, ceil(month/3)
        )
SELECT
    YEAR,
    LAG(QUARTER) OVER (ORDER BY YEAR, QUARTER) AS PREVIOUS_QUARTER,
    QUARTER AS CURRENT_QUARTER,
    MONTHTOTAL - LAG(MONTHTOTAL) OVER (ORDER BY YEAR, QUARTER) AS REVENUE_DIFFERENCE
FROM
    Quarters
ORDER BY
    YEAR, QUARTER;
    
    
with hotspotsPick as (select * from trips t
    left join bikes b using(Bikeid)
    left join stations s using(stationid))
select h.pickupstationid, count(h.pickupstationid) as NoOfSt, ss.city
    from hotspotsPick h	
    left join stations ss on h.pickupstationid = ss.stationid
group by h.pickupstationid, ss.city
order by NoOfSt desc
;



WITH TripDetails AS (
    SELECT
        tripID,
        bikeID,
        startTime,
        endTime,
        LEAD(startTime) OVER (PARTITION BY bikeID ORDER BY startTime) AS nextStartTime
    FROM
        TRIPS
)
SELECT
    tripID,
    bikeID,
    startTime,
    endTime,
    nextStartTime,
    nextStartTime - endTime AS timeBetweenRentals
FROM
    TripDetails
ORDER BY
    bikeID, startTime;


WITH ServiceCounts AS (
    SELECT
        EXTRACT(YEAR FROM m_Start_Time) AS maintenanceYear,
        typeOfService,
        COUNT(*) AS serviceCount
    FROM
        BIKE_MAINTENANCE
    GROUP BY
        EXTRACT(YEAR FROM m_Start_Time),
        typeOfService
)
SELECT
    maintenanceYear,
    typeOfService,
    serviceCount
FROM
    ServiceCounts
ORDER BY
    maintenanceYear, typeOfService;
    
    
WITH CustomerPayments AS (
    SELECT
        c.custID,
        c.fName || ' ' || c.lName AS name,
        SUM(p.amount) AS totalAmount,
        RANK() OVER (ORDER BY SUM(p.amount) DESC) AS paymentRank
    FROM
        CUSTOMERS c
    JOIN
        PAYMENT p ON c.custID = p.custid
    WHERE
        p.typeOfPayment = 'D'
    GROUP BY
        c.custID, c.fName, c.lName
)
SELECT
    paymentRank,name,
    totalAmount
    
FROM
    CustomerPayments
WHERE
    paymentRank <= 5;


WITH CustomerCategories AS (
    SELECT
        c.custID,
        c.fName || ' ' || c.lName AS name,
        COUNT(p.paymentID) AS numberOfPayments,
        CASE
            WHEN COUNT(p.paymentID) >= 20 THEN 'Platinum'
            WHEN COUNT(p.paymentID) >= 15 THEN 'Gold'
            WHEN COUNT(p.paymentID) >= 10 THEN 'Silver'
            ELSE 'Regular'
        END AS category
    FROM
        CUSTOMERS c
    LEFT JOIN
        PAYMENT p ON c.custID = p.custid
    GROUP BY
        c.custID, c.fName, c.lName
)
SELECT
    name,
    numberOfPayments,
    category
FROM
    CustomerCategories
order by numberofpayments desc;

select planid, count(custid) as CtCust
from subscription_status
group by planid
order by CtCust desc;

WITH BikeTripsCount AS (
    SELECT
        b.modelID,
        bm.modelName,
        COUNT(t.tripID) AS tripCount
    FROM
        BIKES b
    JOIN
        TRIPS t ON b.bikeID = t.bikeID
    JOIN
        BIKE_MODELS bm ON b.modelID = bm.modelID
    GROUP BY
        b.modelID, bm.modelName
)
SELECT
    modelID,
    modelName,
    tripCount
FROM
    (
        SELECT
            modelID,
            modelName,
            tripCount,
            RANK() OVER (ORDER BY tripCount DESC) AS rnk
        FROM
            BikeTripsCount
    )
WHERE
    rnk <= 3;


WITH OnCallEmployeeComplaints AS (
    SELECT
        e.empID,
        e.fName || ' ' || e.lName AS employeeName,
        COUNT(c.complaintID) AS numberOfComplaints
    FROM
        EMPLOYEES e
    JOIN
        COMPLAINTS c ON e.empID = c.empID
    WHERE
        e.isOnCallSupport = 'Y'
    GROUP BY
        e.empID, e.fName, e.lName
    order by numberOfComplaints desc
)
SELECT
    employeeName,
    numberOfComplaints
FROM
    OnCallEmployeeComplaints
where rownum = 1
ORDER BY
    numberOfComplaints DESC;

with activeCust as (select custid, fname, lname, age, city, planid
from customers 
inner join subscription_status using(custid)
where activestatus = 'Y' and haspayed='Y' and enddate > sysdate 
order by custid),

totalCust as (select count(custid) as total from customers)

select (count(a.custid)/total * 100) as "Percent of Active Subscribers"
from activeCust a ,totalCust t
group by total;

select * from payment;

select sum(amount) as "Total Revenue" from payment where paymenttime between '01-NOV-23' and '30-NOV-23';

with activeCust as (select custid, fname, lname, age, city, planid
from customers 
inner join subscription_status using(custid)
where activestatus = 'Y' and haspayed='Y' and enddate > sysdate 
order by custid),

totalCust as (select count(custid) as total from customers)

select (count(a.custid)/total * 100) as "Percent of Active Subscribers"
from activeCust a ,totalCust t
group by total;


SELECT stationID, sName, availableBikes
FROM STATIONS
WHERE availableBikes < bikeCapacity / 2;


SELECT c.custID, c.fName || ' ' || c.lName AS CustomerName, COUNT(co.complaintID) AS UnresolvedComplaints
FROM CUSTOMERS c
inner JOIN COMPLAINTS co ON c.custID = co.custID AND co.status = 'P'
GROUP BY c.custID, c.fName, c.lName
ORDER BY UnresolvedComplaints DESC;


with activeCust as (select custid, fname, lname, age, city, planid
from customers 
inner join subscription_status using(custid)
where activestatus = 'Y' and haspayed='Y' and enddate > sysdate 
order by custid),

totalCust as (select count(custid) as total from customers)

select (count(a.custid)/total * 100) as "Percent of Active Subscribers"
from activeCust a ,totalCust t
group by total;

with rideTime as (select tripid, (extract(HOUR FROM ((endtime)-(starttime))) * 3600 + extract(MINUTE FROM ((endtime)-(starttime))
    ) * 60 + extract(SECOND FROM ((endtime)-(starttime)))) as time1, age, c.custid, c.fname,c.lname from customers c 
inner join trips t on c.custid = t.custid)
select custid, fname, lname, sum(time1) as SumTime 
from rideTime
group by custid,fname,lname
order by SumTime desc;

select * from customers;

WITH ServiceCounts AS (
    SELECT
        EXTRACT(YEAR FROM m_Start_Time) AS maintenanceYear,
        typeOfService,
        COUNT(*) AS serviceCount
    FROM
        station_MAINTENANCE
    GROUP BY
        EXTRACT(YEAR FROM m_Start_Time),
        typeOfService
)
SELECT
    maintenanceYear,
    typeOfService,
    serviceCount
FROM
    ServiceCounts
ORDER BY
    maintenanceYear, typeOfService;

