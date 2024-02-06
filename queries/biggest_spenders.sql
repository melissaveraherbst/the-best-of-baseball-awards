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