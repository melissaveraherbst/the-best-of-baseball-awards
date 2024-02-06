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