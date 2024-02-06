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