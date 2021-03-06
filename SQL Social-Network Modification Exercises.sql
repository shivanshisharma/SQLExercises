/*Q1
It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */

DELETE FROM Highschooler
WHERE Grade = 12;

/*Q2
If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
*/

DELETE FROM Likes
WHERE
ID2 IN (SELECT ID2 FROM Friend F WHERE Likes.ID1 = F.ID1)
AND
ID1 NOT IN (SELECT Likes.ID1 FROM Likes L WHERE Likes.ID1 = L.ID2);

/*Q3
For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships
that already exist, or friendships with oneself. \This one is a bit challenging; congratulations if you get it right.)
*/

INSERT INTO Friend
SELECT DISTINCT f1.ID1, F2.ID2
FROM Friend f1, Friend f2
WHERE (f1.ID2 = f2.ID1) AND (f1.ID1 <> f2.ID2)
AND F1.ID1 NOT IN (SELECT F3.ID1 FROM Friend F3 WHERE F3.ID2=F2.ID2);