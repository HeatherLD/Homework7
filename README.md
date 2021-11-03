# Homework7 -- Week 7 Homework
1-4:
5. Explain what autoincrementing is; also explain the difference between creating a join and a subquery.

  Auto incrementing is a SQL process which generates unique numbers to be generated and assigned to new rows as they are inserted into a table. This column
  of unique ids is often used as a primary key for the table.
  
  Creating a join between tables is a process of comparing two columns and creating a new table containing some or all of the rows depending on the JOIN
  specified. A subquery, on the other hand, is a way to compare values in two columns and using the result as part of the outer query, without creating a new
  table.

6. ![Joining Data in SQL certificate](


Homework7 -- In Class Assignment

1) ![ERD diagram](https://github.com/HeatherLD/Homework7/blob/4d591190e6f0cc677087fa9e1f212d9073a91866/Goldie's%20Stores%20Corp%20Data%20Diagram.svg)
  
2)  Dirty data generally refers to data that somehow do not conform to a general standard (either within the database parameters or by accepted norms in the data community). Dirty data gets in the way of grouping and analyzing functions by throwing errors or dropping values. Some examples include:

  • symbols like dollar or percent signs
  
  • date formats
  
  • extra (often invisible) spaces in column names
  
  • misspelled words
  
  • non-standardized abbreviations or versions
  
  • null values
  
  • empty values
  
  • inconsistent data types
  
  
 Some ways to clean data include using functions like replace, reformat, rename, and searching for null values (and replacing them with something that makes sense in the data set).
  
 3)  APIs
I think it would be fun to explore NASA's API "Satellite Situation Center" (https://sscweb.gsfc.nasa.gov/WebServices/REST/) in conjunction with the OpenSky Network API (https://opensky-network.org/apidoc/) to try to get real-time comparisons of a wedge of sky/space and what objects are in it at any given time. 
