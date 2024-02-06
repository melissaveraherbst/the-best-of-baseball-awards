# Project: Best of Baseball Awards ⚾ <!-- omit in toc -->

_Codecademy Backend Engineer Career Path Off Platform Project_

**Table of Contents**

- [Project Instructions](#project-instructions)
- [Downloading The Data](#downloading-the-data)
- [Investigate The Data](#investigate-the-data)
- [Handing Out Awards](#handing-out-awards)
  - [Heaviest Hitters](#heaviest-hitters)
  - [Shortest Sluggers](#shortest-sluggers)
  - [Biggest Spenders](#biggest-spenders)
  - [Most Bang For Their Buck In 2010](#most-bang-for-their-buck-in-2010)
  - [Priciest Starter](#priciest-starter)

## Project Instructions

Welcome! In this project, we will be looking at a massive baseball database containing information about players, teams,
managers, salaries, and just about anything you might want to know about baseball. This dataset contains data from 2019
all the way back to 1871. Let’s see what interesting facts we can learn from this database!

## Downloading The Data

In the starter files that you downloaded to begin this project, you will find a file called `baseball_database.sql`. In
your PostgreSQL client, create a new database and then import this `.sql` file. This should run all of the PostgreSQL
commands to completely set up your tables and populate the tables with the data.

If you’re using Postbird, you can create a new database under the “Select database” menu, by choosing “Create Database”.
Then you can then import the .sql file by selecting “Import .sql file” from the “File” menu.

If you’re having problems, [this forum post](https://discuss.codecademy.com/t/querying-baseball-data-off-platform-project/538527/21) has
some helpful debugging tips.

This is a remarkable dataset that was put together
by [Sean Lahman](http://www.seanlahman.com/baseball-archive/statistics), among others. This work is licensed under
a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/). We
ported Sean’s work to a PostgreSQL database to work for this project.

## Investigate The Data

Now that we’ve got the data in a database, it’s time to take a look at what we’re working with. Note that there is
a **_lot_** of data here — 29 tables to be exact. If you’re curious about any of the fields in any of these tables, you can
consult the `readme.txt` file provided in the downloaded files. You can also
find [more detailed documentation on Sean Lahman’s site](http://www.seanlahman.com/files/database/readme2017.txt).

## Handing Out Awards

Let’s use our querying skills to hold our own baseball awards show — The Best of Baseball. For each of these awards,
write a query to find the award winner.

### Heaviest Hitters

This award goes to the team with the highest average weight of its batters on a given year.

<details>

  <summary>Solution</summary>

  ```sql
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

  <br>

  **Breakdown**

  In this query, a CTE (common table expression) or “temporary table” named `avg_team_weight` is created to calculate the average weight per team by year.

  Then, a CTE named `max_avg_team_weight` is added to find the maximum average weight per team per year from the `avg_team_weight` CTE.

  In the final query, we join the `max_avg_team_weight` CTE with the `avg_team_weight` CTE on the `year_id` and the `avg_weight` to retrieve the corresponding `team_name`.

  This will give the desired result set containing:

  1. the year (`year_id`)
  2. the highest average weight (`max_avg_weight`) for each year
  3. the corresponding team (`team_name`).

</details>

### Shortest Sluggers

This award goes to the team with the smallest average height of its batters on a given year.

<details>

<summary>Solution</summary>

  ```sql
  WITH avg_team_height AS (
    SELECT ROUND(AVG(people.height), 2) AS avg_height,
            teams.name AS team_name,
            batting.yearid AS year_id
    FROM people
    JOIN batting
      ON people.playerid = batting.playerid
    JOIN teams
      ON batting.team_id = teams.id
    GROUP BY teams.name, batting.yearid
  ),
  min_avg_team_height AS (
    SELECT year_id, MIN(avg_height) AS min_avg_height
    FROM avg_team_height
    GROUP BY year_id
  )
  SELECT min_avg_team_height.year_id AS year,
          min_avg_team_height.min_avg_height AS "avg height",
          avg_team_height.team_name AS "team name"
  FROM min_avg_team_height
  JOIN avg_team_height
    ON min_avg_team_height.year_id = avg_team_height.year_id
    AND min_avg_team_height.min_avg_height = avg_team_height.avg_height
  ORDER BY year;
  ```

  <br>

  **Breakdown**

  In this query, a CTE (common table expression) or “temporary table” named `avg_team_height` is created to calculate the average height for each team by year.

  Then, a CTE named `min_avg_team_height` is added to find the minimum average height per team per year from the `avg_team_height` CTE.

  In the final query, we join the `min_avg_team_height` CTE with the `avg_team_height` CTE on the `year_id` and the `avg_height` to retrieve the corresponding `team_name`.

  This will give the desired result set containing

  1. the year (`year_id`)
  2. the smallest average height (`min_avg_height`) for each year
  3. the corresponding team (`team_name`).

</details>

### Biggest Spenders

This award goes to the team with the largest total salary of all players in a given year.

<details>

  <summary>Solution</summary>

  ```sql
  WITH yearly_salaries AS (
    SELECT salaries.yearid AS year_id,
            salaries.teamid AS team_id,
            teams.name AS team_name,
            ROUND(SUM(salaries.salary), 2) AS salaries_total
    FROM salaries
    JOIN teams ON salaries.team_id = teams.id
    GROUP BY 1, 2, 3
  ),
  largest_salaries_by_year AS (
    SELECT year_id,
            MAX(salaries_total) AS largest_salary
    FROM yearly_salaries
    GROUP BY year_id
    ORDER BY year_id
  )
  SELECT yearly_salaries.team_id AS team,
          yearly_salaries.team_name AS "team name",
          largest_salaries_by_year.year_id AS year,
          largest_salaries_by_year.largest_salary AS "salary amount"
  FROM yearly_salaries
  JOIN largest_salaries_by_year
    ON yearly_salaries.salaries_total = largest_salaries_by_year.largest_salary
  ORDER BY year;
  ```

  <br>

  **Breakdown**

  In this query, a CTE named `yearly_salaries` calculates the total salary (`salaries_total`) for each team (`team_id`) in a specific year (`year_id`).

  The next CTE, `largest_salaries_by_year`, helps identify the largest salary for each year.

  The final SELECT statement joins the `yearly_salaries` and `largest_salaries_by_year` CTEs.

  This will give the desired result set containing

  1. the corresponding team and team name (`team_id` and `team_name`)
  2. the year (`year_id`)
  3. the salary amount (`largest_salary`)

</details>

### Most Bang For Their Buck In 2010

This award goes to the team that had the smallest “cost per win” in 2010. Cost per win is determined by the total salary
of the team divided by the number of wins in a given year.

<details>

  <summary>Solution</summary>

  ```sql
  SELECT salaries.yearid AS year,
          salaries.teamid AS "team ID",
          teams.name AS "team full name",
          teams.w AS team_wins AS "wins",
          SUM(salaries.salary) AS "salaries total",
          ROUND(SUM(salaries.salary) / teams.w) AS "cost per win"
  FROM salaries
  JOIN teams
    ON salaries.team_id = teams.id
    AND salaries.yearid = 2010
  GROUP BY 1, 2, 3, 4
  ORDER BY 6
  LIMIT 1
  ```

</details>

### Priciest Starter

This award goes to the pitcher who, in a given year, cost the most money per game in which they were the starting
pitcher. To be eligible for this award, you had to start at least 10 games.

<details>

  <summary>Solution</summary>

  ```sql
  WITH pitcher_costs AS (
    SELECT salaries.playerid AS player_id,
            salaries.yearid AS year_id,
            pitching.gs AS games_started,
            salaries.salary,
            ROUND(salaries.salary / pitching.gs) AS cost_per_game
    FROM salaries
    JOIN pitching
      ON salaries.yearid = pitching.yearid
      AND salaries.playerid = pitching.playerid
      AND salaries.teamid = pitching.teamid
      AND pitching.gs > 9 --filters games started (minimum of 10 is required)
  ),
  highest_pitcher_costs AS (
    SELECT pitcher_costs.year_id,
            MAX(pitcher_costs.cost_per_game) AS cost_per_game
    FROM pitcher_costs
    GROUP BY 1
  )
  SELECT pitcher_costs.year_id AS year,
        pitcher_costs.player_id AS "Player ID",
          people.namefirst AS "first name",
          people.namelast AS "last name",
          highest_pitcher_costs.cost_per_game AS "cost per game"
  FROM pitcher_costs
  JOIN highest_pitcher_costs
    ON pitcher_costs.year_id = highest_pitcher_costs.year_id
    AND pitcher_costs.cost_per_game = highest_pitcher_costs.cost_per_game
  JOIN people
    ON pitcher_costs.player_id = people.playerid
  ```

</details>
