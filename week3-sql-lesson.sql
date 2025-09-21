-- Sqlite Commands:
-- start the CLI: sqlite3
-- quit the CLI: .q
-- See list of commands: .help
-- Open a database: .open longlist.db
-- See open database: .databases
-- See tables of open database: .ta
-- See schema of a table (column names and data types): .schema longlist

-- See every row and column:
SELECT * FROM longlist;

-- Format as boxes: .mode box

-- See only title, author, and rating
SELECT title, author, rating FROM longlist;

-- Press up arrow on keyboard to get previous queries

-- Only see highly-rated books:
SELECT title, author, rating FROM longlist WHERE rating>4;

-- Only books by Han Kang, note the single quotes for strings
Select title, author FROM longlist WHERE author='Han Kang';

-- Sort by ascending order
SELECT title, rating FROM longlist ORDER BY rating ASC;

-- Get books with ratings between 3.5 and 4, ordered in descending order
SELECT title, rating FROM longlist WHERE rating >= 3.5 AND rating <= 4 ORDER BY rating DESC;

-- Another way to get values between two bounds with BETWEEN:
SELECT title, rating FROM longlist WHERE rating BETWEEN 3.5 AND 4;

-- Get only 5 books (not guaranteed to be in order, use ORDER BY to guarantee this)
SELECT title, author FROM longlist LIMIT 5;

-- Only books with authors that appear in an array; note 
SELECT title, author FROM longlist WHERE
author IN ('David Grossman', 'David Diop');

-- Use LIKE to define a pattern. % is a wildcard that matches any string
SELECT title, author FROM longlist WHERE
author LIKE 'David%';
-- Note that you can break queries onto multiple lines. The semicolon ; ends the query.

-- CHALLENGE: find all authors whose name ends with 'a;
SELECT title, author FROM longlist WHERE
author LIKE '%a';

-- Challenge: find all authors who have an x or a z in their name anywhere
SELECT title, author FROM longlist WHERE
author LIKE '%x%' OR author LIKE '%z%';



