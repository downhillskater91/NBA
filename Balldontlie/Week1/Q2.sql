WITH player3p (id, fname, team_id, game_id, home_team_id, visitor_team_id, season) AS (
  SELECT players.id, CONCAT(players.first_name, ' ', players.last_name), players.team_id, player_stats.game_id, games.home_team_id, games.visitor_team_id, games.season FROM player_stats
  JOIN players
  ON players.id = player_stats.player_id
  JOIN games
  ON games.id = player_stats.game_id
  WHERE player_stats.fg3m IS NOT NULL
  AND games.postseason = 'FALSE'
  ORDER BY player_stats.fg3m DESC
  LIMIT 1)

, opp_team (id, season) AS (
  SELECT (CASE WHEN player3p.team_id = player3p.home_team_id THEN player3p.visitor_team_id
               WHEN player3p.team_id = player3p.visitor_team_id THEN player3p.home_team_id END) id, season
  FROM player3p
  )
  
, opp_team1 (id, full_name, season) AS (
  SELECT opp_team.id, teams.full_name, opp_team.season
  FROM opp_team
  JOIN teams
  ON teams.id = opp_team.id
  )
  
, opp_games AS (
  SELECT games.*, opp_team1.full_name FROM games, opp_team1
  WHERE games.season = opp_team1.season
  AND (games.home_team_id = opp_team1.id OR games.visitor_team_id = opp_team1.id)
  )
  
, fg3m_games AS (SELECT opp_games.id, opp_games.full_name, opp_games.season, SUM(player_stats.fg3m) AS "threes" FROM opp_games
  JOIN player_stats
  ON player_stats.game_id = opp_games.id
  GROUP BY opp_games.id, opp_games.season, opp_games.full_name
  )
  
SELECT full_name, season, AVG(threes) FROM fg3m_games
GROUP BY season, full_name
;
