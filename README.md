# Querying the National Science Foundation database
This repository contains source code for a data exploration project exploring various aspects of the National Science Foundation database.

## Database
The National Science Foundation Grants database houses the information on recent research grants awarded to professors at research universities by the National Science Foundation. The database consists of six entites:
 * Grants, with their associated meta-data (amount of funding, start/end dates, etc.)
 * Organizations (universities) which recieve grants
 * Researchers who recieve grants
 * Programs run by the NSF that award grants
 * Managers at NSF who run programs that award grants
 * Fields (research areas) that describe high level topic-areas for grants

The ERD for this database is as follows:<br />
![alt text](https://github.com/ColleenBobbie/NSF-dB/blob/master/ERDdB.PNG)

The data for this project can be found here:<br />
https://www.nsf.gov/awardsearch/<br />

These repository queries were adapted from below:<br />
http://db.csail.mit.edu/6.830/assignments/ps1.pdf<br />

## Skills
This analysis relies heavily on advanced SQL commands including SELECT, WHERE, GROUP BY, ORDER BY, NESTING, and CREATE LOCAL TEMP FILE.

## Analysis
Queries on this dataset include:
 * Find the title and amount of the grants for which Professor Smith is the supervisor.
 * Find the organizations that have received the same number of grants for 3 years in a row, with at least 7 grants per year. 
 * Find the researchers that have received grants from 8 or more directorates.
 * Find the managers who have given the most amount of money to a single organization. 
 * Find the researchers that received more than $1 million in grants one year, did not receive grants the subsequent year, then received more than $1 million in grants the 3rd year.




