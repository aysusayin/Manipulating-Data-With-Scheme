# Manipulating-Data-With-Scheme-

The task is to write Scheme functions (statements) for manipulating
lists of travelers and locations using DrRacket.

Problem description is given below:
You will extract different sorts of information from a database of locations and travelers. In Scheme,
the database is encoded as a list of entries, with one entry for each location and again one entry
for each traveler. Each entry will be a list in the following form:

(<location> <accommodation-cost> (<neighbor-location1> ... <neighbor-locationN>) (<activity1> ... <activityN>))
  
which indicates that <location> is a city which has a railway connection with cities <neighborlocation1>
... <neighbor-locationN> and hosts activities <activity1> ... <activityN> and staying
one night in <location> costs <accommodation-cost>.
  
(<traveler> (<city1> ... <cityN>) (<activity1> ... <activityN>) <home>)
  
which indicates that <traveler> is a traveler who likes to visit cities <city1> . . . <cityN> and
enjoys activities <activity1> ... <activityN> and who lives in <home>.
  
 
