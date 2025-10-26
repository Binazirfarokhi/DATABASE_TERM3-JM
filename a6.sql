-- Task 1: Altering the Ratings Table

-- ALTER TABLE ratings
--     DROP COLUMN id;


ALTER TABLE ratings
    RENAME TO ratings_temp;

CREATE TABLE ratings (
    movie_id INTEGER PRIMARY KEY,
    rating REAL,
    votes INTEGER,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

INSERT INTO ratings(movie_id, rating, votes)
    SELECT movie_id, rating, votes FROM ratings_temp;


DROP TABLE ratings_temp;

ALTER TABLE ratings 
    ADD COLUMN last_rated DATE
        DEFAULT '2024-01-01';





-- Task 2: Views

DROP VIEW IF EXISTS movie_ratings;
-- CREATE VIEW movie_ratings AS 
--     SELECT m.title, r.movie_id, r.rating,
--         CASE 
--             WHEN (JULIANDAY(DATE('now')) - JULIANDAY(r.last_rated)) <= 30 THEN 1
--             ELSE 0
--         END AS trending
--     FROM ratings r 
--     JOIN movies m ON r.movie_id = m.id
--     ORDER BY r.last_rated DESC
--     LIMIT 10;


CREATE VIEW movie_ratings AS 
SELECT 
    m.title, 
    r.movie_id, 
    r.rating, 
    CASE 
        WHEN (JULIANDAY(DATE('now')) - JULIANDAY(r.last_rated)) <= 30 THEN 1
        ELSE 0
    END AS trending,
    (
        SELECT a.type
        FROM awarded aw
        JOIN awards a ON a.id = aw.award_id
        WHERE aw.movie_id = r.movie_id
    ) AS type
FROM ratings r 
JOIN movies m ON r.movie_id = m.id
ORDER BY r.last_rated DESC
LIMIT 10;



UPDATE ratings 
    SET last_rated = DATE('now')
    WHERE movie_id = 35423;



-- Task 3: Awards

DROP TABLE IF EXISTS awards;

CREATE TABLE awards(
    id INTEGER,
    type TEXT,
    PRIMARY KEY(id)
);

INSERT INTO awards (type) 
VALUES
    ('Best of the Best'), 
    ('Not a Bad Choice'), 
    ('A Total Dud');


SELECT * FROM awards;


DROP TABLE IF EXISTS awarded;
CREATE TABLE awarded (
    movie_id INTEGER,
    award_id INTEGER,
    PRIMARY KEY(movie_id, award_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (award_id) REFERENCES awards(id)
);

INSERT INTO awarded (movie_id, award_id)
    SELECT ratings.movie_id, awards.id FROM ratings
    JOIN awards ON awards.id = (
        CASE 
            WHEN ratings.rating < 5.5 THEN 3
            WHEN ratings.rating >= 5.5 AND ratings.rating < 7 THEN 2
            ELSE 1
        END
    );

SELECT * FROM awarded 
    ORDER BY movie_id
    LIMIT 10;




-- Task 4: Triggers

-- reset
-- UPDATE ratings
-- SET
-- rating = 6.8,
-- votes = 14
-- WHERE movie_id = 31458;
-- UPDATE ratings
-- SET
-- rating = 7.0,
-- votes = 26
-- WHERE movie_id = 38086;



DROP TRIGGER IF EXISTS insert_new_vote;
CREATE TRIGGER insert_new_vote
INSTEAD OF INSERT ON movie_ratings
BEGIN   
    UPDATE ratings
    SET 
        rating = ((rating * votes) + NEW.rating) / (votes+1),
        votes = votes + 1,
        last_rated = Date('now')
    WHERE movie_id = NEW.movie_id;

    UPDATE ratings
    SET last_rated = last_rated
    WHERE movie_id = NEW.movie_id;
END;

DROP TRIGGER IF EXISTS update_awards;
CREATE TRIGGER update_awards
AFTER UPDATE ON ratings 
BEGIN 
    UPDATE awarded
    SET award_id = CASE
        WHEN NEW.rating < 5.5 THEN 3
        WHEN NEW.rating >= 5.5 AND NEW.rating < 7 THEN 2
        ELSE 1
    END
    WHERE movie_id = NEW.movie_id;    
END;


INSERT INTO movie_ratings (movie_id, rating) VALUES
(31458, 10);

INSERT INTO movie_ratings (movie_id, rating) VALUES
(31458, 10);
INSERT INTO movie_ratings (movie_id, rating) VALUES
(31458, 10);
INSERT INTO movie_ratings (movie_id, rating) VALUES
(38086, 0);



SELECT * FROM movie_ratings;
