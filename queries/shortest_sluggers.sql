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