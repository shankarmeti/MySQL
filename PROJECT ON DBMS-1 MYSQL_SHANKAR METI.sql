#NAME : SHANKAR METI
#PROJECT NAME : IPL DATABASE

select * from ipl_bidding_details;
select * from ipl_match;
select * from ipl_match_schedule;
select * from ipl_player;
select * from ipl_stadium;
select * from ipl_team;
select * from ipl_team_players;
select * from ipl_team_standings;
select * from ipl_tournament;
select * from ipl_user;

#1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
#use tabeles(ipl_bidder_details,ipl_bidding_details,ipl_bidder_points)
select bdr_dt.bidder_id 'Bidder ID', bdr_dt.bidder_name 'Bidder Name', 
(select count(*) from ipl_bidding_details bid_dt 
where bid_dt.bid_status = 'won' and bid_dt.bidder_id = bdr_dt.bidder_id) / 
(select no_of_bids from ipl_bidder_points bdr_pt 
where bdr_pt.bidder_id = bdr_dt.bidder_id)*100 as 'Percentage of Wins (%)'
from ipl_bidder_details bdr_dt order by 3 desc;

#2.	Display the number of matches conducted at each stadium with stadium name, city from the database.
#tables(ipl_stadium,ipl_match_schedule)
select STADIUM_ID , 
(select STADIUM_NAME from ipl_stadium s where s.STADIUM_ID = ms.STADIUM_ID) STADIUM_NAME,  count(*) NO_OF_MATCHES
from ipl_match_schedule ms group by STADIUM_ID 
order by STADIUM_ID;




#3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

SELECT stad.stadium_id,stad.stadium_name,(select count(*)  
FROM ipl_match im JOIN ipl_match_schedule ims ON im.match_id =ims.match_id 
WHERE stad.STADIUM_ID=ims.STADIUM_ID and (toss_winner=match_winner)) /
(select count(*) from ipl_match_schedule ims where ims.STADIUM_ID = stad.STADIUM_ID) *
 100 as 'Percentage of Wins by teams who won the toss (%)' from ipl_stadium stad;

#4.	Show the total bids along with bid team and team name.
select count(*) 'TOTAL BIDS',ibd.BID_TEAM,it.TEAM_NAME  from ipl_bidder_points idp 
JOIN ipl_bidding_details ibd ON idp.BIDDER_ID=ibd.BIDDER_ID
JOIN ipl_team it ON it.TEAM_ID = ibd.BID_TEAM
GROUP BY TEAM_NAME ORDER BY BID_TEAM;
#5.	Show the team id who won the match as per the win details.
SELECT ip.match_id,it.TEAM_ID,ip.WIN_DETAILS,it.TEAM_NAME,it.REMARKS
FROM ipl_match ip
JOIN ipl_team it 
ON it.REMARKS=substring(ip.WIN_DETAILS,6,2)
union all
SELECT ip.match_id,it.TEAM_ID,ip.WIN_DETAILS,it.TEAM_NAME,it.REMARKS
FROM ipl_match ip
JOIN ipl_team it 
ON it.REMARKS=substring(ip.WIN_DETAILS,6,3)
union all
SELECT ip.match_id,it.TEAM_ID,ip.WIN_DETAILS,it.TEAM_NAME,it.REMARKS
FROM ipl_match ip
JOIN ipl_team it 
ON it.REMARKS=substring(ip.WIN_DETAILS,6,4)
ORDER BY MATCH_ID;
#6.	Display total matches played, total matches won and total matches lost by team along with its team name.
SELECT its.TEAM_ID,it.TEAM_NAME,its.TOURNMT_ID,its.MATCHES_PLAYED,its.MATCHES_WON,its.MATCHES_LOST
FROM ipl_team_standings its
JOIN ipl_team it ON its.TEAM_ID=it.TEAM_ID
ORDER BY TOURNMT_ID;
#7.	Display the bowlers for Mumbai Indians team.
SELECT itp.TEAM_ID,itp.PLAYER_ID,ip.PLAYER_NAME,itp.PLAYER_ROLE,it.TEAM_NAME FROM
ipl_team_players itp JOIN ipl_team it ON itp.TEAM_ID=it.TEAM_ID 
JOIN ipl_player ip ON ip.PLAYER_ID=itp.PLAYER_ID 
WHERE it.TEAM_NAME = 'Mumbai Indians' AND PLAYER_ROLE='Bowler';
#8.	How many all-rounders are there in each team, Display the teams with more than 4 
#all-rounder in descending order.
SELECT ITP.TEAM_ID,ITP.PLAYER_ROLE,IT.TEAM_NAME,COUNT(ITP.PLAYER_ROLE) 'NUMBER OF ALL-ROUNDERS' FROM ipl_team_players
itp JOIN ipl_team it ON itp.TEAM_ID=it.TEAM_ID
WHERE PLAYER_ROLE IN (SELECT PLAYER_ROLE FROM ipl_team_players WHERE PLAYER_ROLE='All-Rounder')
GROUP BY IT.TEAM_NAME;

#Display the teams with more than 4 all-rounder in descending order.
SELECT ITP.TEAM_ID,ITP.PLAYER_ROLE,IT.TEAM_NAME,COUNT(ITP.PLAYER_ROLE) 'NUMBER OF ALL-ROUNDERS' FROM ipl_team_players
itp JOIN ipl_team it ON itp.TEAM_ID=it.TEAM_ID
WHERE PLAYER_ROLE IN (SELECT PLAYER_ROLE FROM ipl_team_players WHERE PLAYER_ROLE='All-Rounder')
GROUP BY IT.TEAM_NAME
HAVING COUNT(ITP.PLAYER_ROLE)>4
ORDER BY COUNT(ITP.PLAYER_ROLE) DESC;