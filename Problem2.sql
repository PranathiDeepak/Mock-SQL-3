WITH CTE AS(
Select first_player as player, first_score as score from Matches
UNION all
Select second_player as player, second_score as score from Matches
),
CTE2 as(
Select distinct player, SUM(score) OVER (partition by player) as 'sum' from CTE 
),
CTE3 as(
SELECT p.group_id,c.player, c.sum, DENSE_RANK()OVER(partition by p.group_id order by sum desc, c.player asc) as 'rnk' from CTE2 c  JOIN Players p ON c.player = p.player_id
order by group_id)


Select group_id, player  as 'player_id' from CTE3  where rnk = 1
order by group_id