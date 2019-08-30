/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */



SELECT name
FROM Facilities
WHERE membercost != 0.0



/* Q2: How many facilities do not charge a fee to members? */



SELECT COUNT(*)
FROM Facilities
WHERE membercost = 0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */



SELECT f.facid, 
	   f.name AS 'facility name', 
	   f.membercost AS 'member cost',
           f.monthlymaintenance as 'monthly maintenance'
FROM Facilities f
WHERE f.membercost != 0 AND f.membercost < 0.2*f.monthlymaintenance



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */


SELECT *
FROM Facilities
WHERE facid IN (1, 5)


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */


SELECT f.name, 
       (CASE 
	    WHEN f.monthlymaintenance > 100 THEN 'expensive' 
            WHEN f.monthlymaintenance <= 100 THEN 'cheap'
	    END) AS 'monthly maintenance'
FROM Facilities f



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */



SELECT m1.firstname AS 'firs_tname', m1.surname AS 'last_name'
     FROM Members m1
INNER JOIN
     (SELECT MAX(joindate) AS jdate
      FROM Members) m2
ON m1.joindate = m2.jdate



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */



SELECT DISTINCT(CONCAT(m1.firstname,' ',m1.surname))AS member_name, m3.name AS court_name
FROM Facilities m3
INNER JOIN 
	(SELECT m2.firstname,m2.surname,m4.facid
       	FROM Members m2
      	INNER JOIN Bookings m4
      	ON m2.memid=m4.memid) m1
ON m1.facid=m3.facid
WHERE m3.name LIKE 'Tennis Court%' 
ORDER BY member_name



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


SELECT f.name AS name_of_facility,  
       CONCAT(m.firstname,' ',m.surname) AS member_name,
       IF(m.memid =0, f.guestcost*b.slots, f.membercost*b.slots) AS cost
FROM Facilities f
JOIN Bookings b ON b.facid = f.facid
JOIN Members m ON m.memid = b.memid
WHERE b.starttime LIKE '2012-09-14%'
HAVING cost > 30
ORDER BY cost DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT f.name AS name_of_facility,  
        CONCAT(s.firstname,' ',s.surname) AS member_name, 
	IF(s.memid =0, f.guestcost*s.slots, f.membercost*s.slots) AS cost
FROM Facilities f
JOIN 
	(SELECT m.memid, m.firstname, m.surname, b.slots, b.facid
     	 FROM Bookings b
  	 JOIN Members m 
	 ON m.memid = b.memid
     	 WHERE b.starttime LIKE '2012-09-14%') s
ON f.facid=s.facid
HAVING cost > 30
ORDER BY cost DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


SELECT f.name AS name_of_facility,
       SUM(IF(m.memid =0, f.guestcost*b.slots, f.membercost*b.slots)) AS cost
FROM Facilities f
JOIN Bookings b ON b.facid = f.facid
JOIN Members m ON m.memid = b.memid
GROUP BY name_of_facility
ORDER BY cost 


