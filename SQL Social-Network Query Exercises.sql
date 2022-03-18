/*Q1
Find the names of all students who are friends with someone named Gabriel.
*/

SELECT DISTINCT name
FROM Highschooler
INNER JOIN Friend
ON Highschooler.ID = Friend.ID1
WHERE ID2 IN (SELECT ID
		FROM Highschooler
		WHERE name = 'Gabriel');

/*Q2
For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
*/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Likes L
LEFT JOIN HIGHSCHOOLER H1 ON H1.ID = L.ID1
LEFT JOIN HIGHSCHOOLER H2 ON H2.ID = L.ID2
WHERE ((H1.GRADE - H2.GRADE) >=2);

/*Q3
For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the
two names in alphabetical order.
*/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, Likes L1, Likes L2
WHERE (H1.ID = L1.ID1 AND H2.ID = L2.ID1)
	AND (H2.ID = L1.ID2 AND H1.ID = L2.ID2)
	AND (H1.name < H2.name);

/*Q4
Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by
grade, then by name within each grade.
*/

SELECT name, grade
FROM Highschooler
WHERE (ID NOT IN
	(SELECT DISTINCT ID1
	FROM Likes
	UNION
	SELECT DISTINCT ID2
	FROM Likes)
	);

/*Q5
For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an
ID1 in the Likes table), return A and B's names and grades.
*/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Likes L
INNER JOIN HIGHSCHOOLER H1 ON H1.ID = L.ID1
INNER JOIN HIGHSCHOOLER H2 ON H2.ID = L.ID2
AND (L.ID2 NOT IN
		(SELECT ID1
		FROM LIKES));

/*Q6
Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within
each grade.
*/

SELECT DISTINCT H1.name, H1.grade
FROM Highschooler H1, FRIEND F
WHERE ID NOT IN (
	SELECT ID1
	FROM FRIEND F, Highschooler H2
	WHERE (H1.ID = F.ID1) AND (H2.ID = F.ID2)
	AND (H1.GRADE <> H2.GRADE)
)
ORDER BY GRADE, NAME;

/*Q7
For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce
them!R. For all such trios, return the name and grade of A, B, and C.
*/

SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM HIGHSCHOOLER H1, HIGHSCHOOLER H2, HIGHSCHOOLER H3, LIKES L, FRIEND F1, FRIEND F2
WHERE (H1.ID = L.ID1) AND (H2.ID = L.ID2)
	AND (H2.ID NOT IN(
		SELECT ID2
		FROM FRIEND
		WHERE ID1 = H1.ID)
		AND (H1.ID = F1.ID1 AND H3.ID = F1.ID2)
		AND (H2.ID = F2.ID1 AND H3.ID = F2.ID2));

/*Q8
Find the difference between the number of students in the school and the number of different first names.
*/

SELECT COUNT(*) - COUNT(DISTINCT NAME)
FROM HIGHSCHOOLER;

/*Q9
Find the name and grade of all students who are liked by more than one other student.
*/

SELECT NAME, GRADE
FROM HIGHSCHOOLER H
WHERE H.ID IN (SELECT ID2
		FROM LIKES
		GROUP BY ID2
		HAVING COUNT(ID2)>1);