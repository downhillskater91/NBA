WITH player_3p (player_id, season) AS (
  SELECT player_id, season FROM player_stats
  JOIN games
  ON games.id = player_stats.game_id
  WHERE fg3m IS NOT NULL AND postseason = 'FALSE'
  ORDER BY fg3m DESC
  LIMIT 1
  )
  
, player_games AS (
  SELECT * FROM player_3p, player_stats
  JOIN games
  ON games.id = player_stats.game_id
  WHERE player_stats.player_id = player_3p.player_id AND games.season = player_3p.season 
    AND games.postseason = 'FALSE'
  ORDER BY game_id
  )

, teams_3s (team_id, fg3m) AS (
  SELECT (CASE WHEN player_games.team_id = player_games.home_team_id THEN player_games.visitor_team_id
               WHEN player_games.team_id = player_games.visitor_team_id THEN player_games.home_team_id END)team_id, fg3m
  FROM player_games
  )
  
SELECT team_id, teams.full_name, ROUND(AVG(fg3m), 2) FROM teams_3s
JOIN teams
ON teams.id = teams_3s.team_id
GROUP BY team_id, teams.full_name
ORDER BY teams.full_name
;
