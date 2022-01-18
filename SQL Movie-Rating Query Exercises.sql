/* Stanford Online - Databases: Relational Databases & SQL
SQL Movie-Rating Query Exercises
Author - Shivanshi Sharma

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.
Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.
Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating `135e on a certain ratingDate.

*/


-- Q1
-- Find the titles of all movies directed by Steven Spielberg.

SELECT title
FROM movie
WHERE director = 'Steven Spielberg';

-- Q2
--Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT year
FROM Movie
Join Rating USING(mID)
WHERE Rating.stars BETWEEN 4 AND 5
ORDER BY year ASC;

-- Q3
-- Find the titles of all movies that have no ratings.
SELECT title
FROM Movie
WHERE mID NOT IN (SELECT mID FROM rating);

-- Q4
-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT name
from Reviewer
JOIN Rating
ON Reviewer.rID = Rating.rID
WHERE Rating.ratingDate IS NULL;

-- Q5
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by
--reviewer name, then by movie title, and lastly by number of stars.
SELECT name,
	title,
	stars,
	ratingDate
FROM Reviewer
JOIN Rating USING (rID)
JOIN Movie USING (mID)
ORDER BY name ASC, title ASC


-- Q6
-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the
--title of the movie.
SELECT DISTINCT name, title
FROM REVIEWER
JOIN Rating USING(rID)
JOIN Movie USING (mID)
GROUP BY Reviewer.name
HAVING COUNT(*) = 2
AND Rating.stars < 3;

-- Q7
-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by
--movie title.
SELECT DISTINCT title,
	stars
FROM Rating
JOIN Movie USING(mID)
GROUP BY title
HAVING MAX(stars) > 1;

-- Q8
-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating
--spread from highest to lowest, then by movie title.
SELECT DISTINCT title,
	(MAX(stars) - MIN(stars)) as rating_spread
FROM MOVIE
INNER JOIN Rating USING (mId)
GROUP BY mID
ORDER BY rating_spread DESC,
	title;

-- Q9
--Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. `Make sure to
--calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the
--overall average rating before and after 1980.)

SELECT
	AVG(before1980)-AVG(after1980)
FROM(
	SELECT AVG(STARS) before1980
	FROM MOVIE M,RATING R
	WHERE M.MID=R.MID and year<1980
	GROUP BY M.MID
	),

	(SELECT AVG(STARS) after1980
	FROM MOVIE M,RATING R
	WHERE M.MID=R.MID and year>1980
	GROUP BY M.MID
	);
