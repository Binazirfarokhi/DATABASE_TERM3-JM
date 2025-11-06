-- Task 1: Altering the Ratings Table

-- -- Remove id column
-- -- -- ALTER TABLE ratings
-- -- -- DROP COLUMN id;
-- -- Error: Parse error near line 4: cannot drop PRIMARY KEY column: "id"

-- -- Rename table https://www.geeksforgeeks.org/sql/sql-alter-rename/
ALTER TABLE ratings
RENAME TO ratings_temp;
-- -- Create new ratings table  (without id)
CREATE TABLE ratings (
    movie_id    INTEGER UNIQUE,
    rating    REAL NOT NULL,
    votes    INTEGER NOT NULL,
    PRIMARY KEY (movie_id) 
    FOREIGN KEY (movie_id) REFERENCES movie(id)
);
-- -- Copy data
INSERT INTO ratings (movie_id, rating, votes)
SELECT movie_id, rating, votes FROM ratings_temp;
-- -- Drop ratings_temp table
DROP TABLE ratings_temp;
-- -- Alter ratings to add column last_rated with default value 2024-01-01
ALTER TABLE ratings
ADD
    last_rated  DATE DEFAULT '2024-01-01';





-- Task 3: Awards

-- -- Create new table and rows for awards
DROP TABLE IF EXISTS awards;
CREATE TABLE awards (
    id  INTEGER,
    type    TEXT,
    PRIMARY KEY (id)
);
INSERT INTO awards (type) VALUES
('Best of the Best'),
('Not a Bad Choice'),
('A Total Dud');
-- -- Print awards table
SELECT * FROM AWARDS;
-- -- Create a junction table to connect awards and movies
DROP TABLE IF EXISTS awarded;
CREATE TABLE awarded (
    movie_id    INTEGER,
    award_id    INTEGER,
    PRIMARY KEY (movie_id, award_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (award_id) REFERENCES awards(id)
);
-- -- Populate the awarded table
INSERT INTO awarded (movie_id, award_id)
SELECT ratings.movie_id, awards.id FROM ratings
JOIN awards ON awards.id = (
    SELECT
        CASE
            -- I followed requirement "If higher than 7, it's 'Best of the Best'" 
            -- instead of screenshot which includes 7
            -- screenshot shows 1 for movie_id 38086 but it has a rating of 7
            -- which means it should be 2 as per requirement
            -- and falls under between 5.5 and 7
            WHEN ratings.rating > 7 THEN 1
            WHEN ratings.rating >= 5.5 THEN 2
            ELSE 3
        END rating_award
);
-- -- Get awarded table sorted in asc of movie_id
SELECT * FROM awarded
ORDER BY movie_id ASC
LIMIT 10;
-- -- Update movie_ratings view to include award type 
-- -- I moved Task 2 below this task to easily rerun the script




-- Task 2: Views

-- -- Create movie_ratings view
DROP VIEW IF EXISTS movie_ratings; -- added drop for me to be able to rerun the script without issues
CREATE VIEW movie_ratings AS
SELECT movies.title, ratings.movie_id, ratings.rating,
CASE
    WHEN JULIANDAY(DATE('now')) - JULIANDAY(last_rated) <= 30 THEN 1
    ELSE 0
END trending, awards.type
FROM movies
JOIN ratings ON movies.id = ratings.movie_id
JOIN awarded ON movies.id = awarded.movie_id
JOIN awards ON awarded.award_id = awards.id
ORDER BY ratings.last_rated DESC
LIMIT 10 OFFSET 0;
-- -- Update Kate & Leopold last_rated to today's date
UPDATE ratings
SET last_rated = DATE('now')
WHERE movie_id = (SELECT id FROM movies WHERE title = 'Kate & Leopold');
-- -- Use the view
SELECT * from movie_ratings;




-- Task 4: Triggers
-- -- Create trigger to update ratings when trying to insert to movie_ratings view
DROP TRIGGER IF EXISTS insert_new_vote; -- added drop for me to be able to rerun the script without issues
CREATE TRIGGER insert_new_vote
INSTEAD OF INSERT ON movie_ratings
BEGIN
    UPDATE ratings
    SET
        rating = (
            (
                (SELECT votes FROM ratings WHERE movie_id = NEW.movie_id) -- OLD. syntax doesn't work, AI suggest to write subquery
                * (SELECT rating FROM ratings WHERE movie_id = NEW.movie_id)
                + NEW.rating
            ) / ((SELECT votes FROM ratings WHERE movie_id = NEW.movie_id) + 1)),
        votes = (SELECT votes FROM ratings WHERE movie_id = NEW.movie_id) + 1,
        last_rated = DATE('now')
    WHERE movie_id = NEW.movie_id;
END;

-- -- Create trigger to update ratings reward type as side effect of updating ratings table
DROP TRIGGER IF EXISTS update_awards; -- added drop for me to be able to rerun the script without issues
CREATE TRIGGER update_awards
AFTER UPDATE ON ratings
BEGIN
    UPDATE awarded
    SET award_id =
        CASE
            WHEN NEW.rating > 7 THEN 1
            WHEN NEW.rating >= 5.5 THEN 2
            ELSE 3
        END
    WHERE NEW.movie_id = awarded.movie_id;
END;  

-- -- Check original values
SELECT 'Before Updates' as original_values;
SELECT * FROM ratings WHERE movie_id IN (31458, 38086);
SELECT * from movie_ratings;

INSERT INTO movie_ratings (movie_id, rating) VALUES (31458, 10);
INSERT INTO movie_ratings (movie_id, rating) VALUES (31458, 10);
INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0);
-- INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0); -- added more to test Total Dud
-- INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0);
-- INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0);
-- INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0);
-- INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0);
-- INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0);
-- INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0);
-- INSERT INTO movie_ratings (movie_id, rating) VALUES (38086, 0);

-- -- Check updated rating & movie_ratings
SELECT 'After Updates' as new_values;
SELECT * FROM ratings WHERE movie_id IN (31458, 38086);
SELECT * from movie_ratings;

-- -- Reset original values
UPDATE ratings
SET
    rating = 6.8,
    votes = 14
WHERE movie_id = 31458;

UPDATE ratings
SET
    rating = 7.0,
    votes = 26
WHERE movie_id = 38086;

-- -- Check updated rating & movie_ratings
SELECT 'After Reset' as original_values;
SELECT * FROM ratings WHERE movie_id IN (31458, 38086);
SELECT * from movie_ratings;