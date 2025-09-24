--We want to do Aggregation : 
--Suppose we want to do the average "rating" or "hardcover" books ? 
SELECT ROUND(AVG(rating),2) AS average_rating, format FROM longlist WHERE format = 'hardcover';
-- how about id I want to see an average rating in the hardcover and papaerback books at the same time? so one way is to write two queries
--the other way is to grouping two queries.
SELECT ROUND(AVG(rating),2) AS average_rating, format FROM longlist GROUP BY format;
--to find number of books that we have- eg how many paper book and how many hardcover?  : 
SELECT ROUND(AVG(rating),2) AS average_rating, COUNT(rating) ,format FROM longlist GROUP BY format;
--now give is an Aliases : mmeanin a good name for columns
SELECT ROUND(AVG(rating),2) AS average_rating, COUNT(rating) AS "Number of Books" ,format FROM longlist GROUP BY format;
--let's rank all publisher by their average rating , from greatest to least: 
SELECT ROUND(AVG(rating),2) AS average ,publisher FROM longlist GROUP BY publisher HAVING average>4 ORDER BY average DESC;

--SUBQUERIES : get in a data in a conveinet way, try forcus on result 
--get all books written by the same authoer as the book 'FLights'; 
--step 1 : get the author of Flights SELECT author FROM longlist WHERE title='Flights'
--step 2 : get the author's books   SELECT author, title FROM longlist WHERE author =
SELECT author, title FROM longlist WHERE author =
(SELECT author FROM longlist WHERE title='Flights');

--subquery from a temp result set
--select the highest-rated publisher 
--step 1 : use AVE to get average of each publisher and put it into a temporary set with alias AveragesByPublisher;
--SELECT ROUND(AVG(rating),2) AS average,publisher FROM longlist GROUP BY publisher AS"AverageByPublisher";
--step 2 : query from AverageByPublisher as we would a normal table , and get the MAX.
--SELECT MAX(average), publisher FROM ( 
SELECT MAX(average), publisher FROM ( 
SELECT ROUND(AVG(rating),2) AS average,publisher FROM longlist GROUP BY publisher )AS"AverageByPublisher";

--set operation : 
-- it has three different querise: UNION - INTERsect and except 
--get all books with the 'life' and 'Love' in the title 
--UNION will merge all data into one table
SELECT title FROM longlist WHERE title LIKE '%Life%' 
UNION 
SELECT title FROM longlist WHERE title LIKE '%Love%';
--only books that have LIFE and LOVE in their title; 
--it is time to use intersect 
SELECT title FROM longlist WHERE title LIKE '%Life%' 
INTERSECT
SELECT title FROM longlist WHERE title LIKE '%Love%';
--now the books have life not LOVe in their titles
SELECT title FROM longlist WHERE title LIKE '%Life%' 
EXCEPT 
SELECT title FROM longlist WHERE title LIKE '%Love%';
--creating column "" double quotes
--creating value '' signle quotes 
--get all authors and translators:
SELECT 'author' AS "profession" , author FROM longlist
UNION
SELECT 'translator' AS "Translator" , translator FROM longlist;