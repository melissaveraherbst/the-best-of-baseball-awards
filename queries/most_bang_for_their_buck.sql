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