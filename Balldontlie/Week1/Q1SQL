SELECT player_stats.game_id as "Game ID", players.id as "Player ID", players.first_name, players.last_name, player_stats.fg3m, games.postseason FROM player_stats
JOIN players
ON players.id = player_stats.player_id
JOIN games
ON games.id = player_stats.game_id
WHERE player_stats.fg3m IS NOT NULL
AND games.postseason = 'FALSE'
ORDER BY player_stats.fg3m DESC
LIMIT 1;
