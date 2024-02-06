<div align=center>

<img src="https://github.com/melissaveraherbst/the-best-of-baseball-awards/assets/84316275/dd788272-76e7-422b-ba63-eacd9f75d207" width=100px />

# The Best of BaseBall Awards
### A Codecademy Pro Project from the Backend Engineer Career Path

</div>

### Overview

This repository contains the project files for an online course on databases, focusing on a massive baseball database. The dataset spans from 1871 to 2019 and covers various aspects of baseball, including players, teams, managers, and salaries. The primary goal of the project is to analyze the data and create queries for a fictional "The Best of Baseball" award event.

**Awards**

1. "Heaviest Hitters"  
This award goes to the team with the highest average weight of its batters on a given year.
2. "Shortest Sluggers"  
This award goes to the team with the smallest average height of its batters on a given year.
3. "Biggest Spenders"  
This award goes to the team with the largest total salary of all players in a given year.
4. "Most bang for their Buck in 2010"  
This award goes to the team that had the smallest “cost per win” in 2010.
5. "Priciest Starter"  
This award goes to the pitcher who, in a given year, cost the most money per game in which they were the starting pitcher.

### Project Structure

- `queries/`: Here, you will find the SQL files containing the query solutions for the award show analysis
- `docs/`: This directory contains the following documentation:
  - `Project Best of Baseball Awards.md`: A markdown file that I wrote to contain the project instructions as well as my query solutions in one single file for ease of access. 
  - `TheBestOfBaseballAwardsStarterFiles.zip`: Starter Files provided by Codecademy
    -  **baseball_database.sql**: the database that is used in this project 
    -  **readme.txt**: contains information about the dataset
    -  **TheBestOfBaseballAwards**: project instructions

### Example Query

```sql
-- heaviest_hitters.sql

WITH avg_team_weight AS (
  SELECT ROUND(AVG(people.weight), 2) AS avg_weight,
          teams.name AS team_name,
          batting.yearid AS year_id
  FROM people
  JOIN batting
    ON people.playerid = batting.playerid
  JOIN teams
    ON batting.team_id = teams.id
  GROUP BY teams.name, batting.yearid
),
max_avg_team_weight AS (
  SELECT year_id, MAX(avg_weight) AS max_avg_weight
  FROM avg_team_weight
  GROUP BY year_id
)
SELECT max_avg_team_weight.year_id AS year,
        max_avg_team_weight.max_avg_weight AS "avg weight",
        avg_team_weight.team_name AS "team name"
FROM max_avg_team_weight
JOIN avg_team_weight
  ON max_avg_team_weight.year_id = avg_team_weight.year_id
 AND max_avg_team_weight.max_avg_weight = avg_team_weight.avg_weight
ORDER BY year;
```
