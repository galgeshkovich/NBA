
-- Create Table

CREATE TABLE nba (
    Name VARCHAR(255),
    Age INT,
    Weight DECIMAL(5, 2),
    BMI DECIMAL(5, 2),
    Salary DECIMAL(10, 2),
    Position VARCHAR(3),
    Team VARCHAR(255),
    College VARCHAR(255)
);

 -- Import csv
 
COPY nba(Name, Age, Weight, BMI, Salary, Position, Team, College)
FROM 'nba.csv' DELIMITER ',' CSV HEADER;

-- Retrieve the first few rows to check

SELECT * FROM nba LIMIT 5;

-- Count the number of rows

SELECT COUNT(*) FROM nba;

-- Remove rows with NULL values

DELETE FROM nba WHERE Name IS NULL OR Age IS NULL;

-- Average salary by position

SELECT Position, AVG(Salary) as AverageSalary
FROM nba
GROUP BY Position;

-- Using Join

SELECT nba.*, avg_salary.avg_position_salary
FROM nba
JOIN (
    SELECT Position, AVG(Salary) as avg_position_salary
    FROM nba
    GROUP BY Position
) avg_salary ON nba.Position = avg_salary.Position;


-- Players with above-average salary in each position

SELECT nba.*
FROM nba
WHERE Salary > (
    SELECT AVG(Salary)
    FROM nba AS sub
    WHERE sub.Position = nba.Position
);


-- Average salary by team

SELECT Team, AVG(Salary) as AverageSalary
FROM nba
GROUP BY Team;

-- Summary of player ages

SELECT Age, COUNT(*) as Frequency
FROM nba
GROUP BY Age
ORDER BY Age;

-- Teams with no players above a certain age

SELECT DISTINCT nba.Team
FROM nba
WHERE NOT EXISTS (
    SELECT 1
    FROM nba AS sub
    WHERE sub.Team = nba.Team AND sub.Age > 30
);


-- Position distribution

SELECT Position, COUNT(*) as Count
FROM nba
GROUP BY Position;


-- Calculate BMI
-- Calculate BMI and update the table

UPDATE nba SET BMI = (Weight / (75 * 75)) * 703;


-- Players with above-Average BMI

SELECT *
FROM nba
WHERE BMI > (SELECT AVG(BMI) FROM nba);



-- Players with the same college

SELECT College, Name
FROM nba
WHERE College IN (
    SELECT College
    FROM nba
    GROUP BY College
    HAVING COUNT(*) > 1
)
ORDER BY College, Name;



-- Players with the same age

SELECT Age, COUNT(*) as player_count
FROM nba
GROUP BY Age
HAVING COUNT(*) > 1
ORDER BY Age;




-- Highest salary by team

SELECT nba.*
FROM nba
JOIN (
    SELECT Team, MAX(Salary) as max_salary
    FROM nba
    GROUP BY Team
) max_salaries ON nba.Team = max_salaries.Team AND nba.Salary = max_salaries.max_salary;



-- Average salary of players from top colleges

SELECT College, AVG(Salary) as avg_college_salary
FROM nba
WHERE College IN (
    SELECT College
    FROM nba
    GROUP BY College
    ORDER BY COUNT(*) DESC
    LIMIT 5 -- Adjust the limit based on the number of top colleges you want to consider
)
GROUP BY College;


-- Youngest and Oldest Players by Team

SELECT nba.*
FROM nba
JOIN (
    SELECT Team, MIN(Age) as min_age, MAX(Age) as max_age
    FROM nba
    GROUP BY Team
) team_age ON nba.Team = team_age.Team AND (nba.Age = team_age.min_age OR nba.Age = team_age.max_age);


-- Youngest player per college

SELECT College, Name, Age
FROM nba
WHERE (College, Age) IN (
    SELECT College, MIN(Age) as min_age
    FROM nba
    GROUP BY College
);


-- Players with the highest salary gap

SELECT nba.*, (Salary - avg_salaries.avg_position_salary) AS salary_gap
FROM nba
JOIN (
    SELECT Position, AVG(Salary) AS avg_position_salary
    FROM nba
    GROUP BY Position
) avg_salaries ON nba.Position = avg_salaries.Position
ORDER BY salary_gap DESC;



