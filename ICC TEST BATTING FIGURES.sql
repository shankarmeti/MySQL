#NAME: SHANKAR METI 
#MINI PROJECT : ICC TEST BATTING FIGURES


CREATE DATABASE DBMS2_MINI_PROJECT_ICC;

#Tasks to be performed:

#1.Import the csv file to a table in the database.

# DONE 


#2.	Remove the column 'Player Profile' from the table.
ALTER TABLE icc_test_batting_figures  DROP COLUMN `Player Profile`;

#3.	Extract the country name and player names from the given data and store it in seperate columns for further usage.
ALTER TABLE icc_test_batting_figures
ADD Player_name VARCHAR(80) AFTER Player,
ADD Country_name VARCHAR(80) AFTER Player_name;
UPDATE icc_test_batting_figures SET
Player_name =trim(substr(Player,1,instr(player,'(')-1)),
Country_name=trim('ICC/' FROM trim(')' from substr(Player,instr(player,'(')+1,instr(player,')'))));
						

#4.	From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.
#CREATE TABLE DUMY AS
ALTER TABLE icc_test_batting_figures
ADD Start_year INT AFTER Span,
ADD End_year INT AFTER start_year;
UPDATE icc_test_batting_figures SET
Start_year= trim(substr(Span,1,instr(span,'-')-1)),
End_year= trim( substr(span,instr(span,'-')+1));

#5.	The column 'HS' has the highest score scored by the player so far in any given match. 
#The column also has details if the player had completed the match in a NOT OUT status. 
#Extract the data and store the highest runs and the NOT OUT status in different columns.

ALTER TABLE icc_test_batting_figures
ADD Highest_run INT AFTER HS,
ADD NOT_OUT_STATUS TEXT AFTER Highest_run;
ALTER TABLE icc_test_batting_figures MODIFY Highest_run TEXT;
UPDATE icc_test_batting_figures SET
Highest_run=trim(substr(HS,1)),           
NOT_OUT_STATUS = trim(substr(HS,instr(HS,'*')));

UPDATE icc_test_batting_figures SET NOT_OUT_STATUS = 'OUT' WHERE NOT_OUT_STATUS NOT LIKE '*';
UPDATE icc_test_batting_figures SET NOT_OUT_STATUS = 'NOT OUT' WHERE NOT_OUT_STATUS  LIKE '*';

ALTER TABLE icc_test_batting_figures CHANGE NOT_OUT_STATUS STATUS VARCHAR(80);

#6.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for India.
SELECT *, RANK() OVER(ORDER BY AVG DESC) AS BATTING_ORDER 
FROM icc_test_batting_figures WHERE End_year= 2019 and Country_name = 'INDIA' and avg>43; 

#7.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for India.
SELECT *, RANK() OVER(ORDER BY `100` DESC) AS BATTING_ORDER 
FROM icc_test_batting_figures WHERE End_year= 2019 and Country_name ='INDIA' LIMIT 6 ; 
 

#8.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using 2 selection criterias of your own for India.

# I USED TWO SELECTION CRITERIAS 1) AVG 2) HS 

SELECT *, RANK() OVER(ORDER BY runs DESC) AS BATTING_ORDER 
FROM icc_test_batting_figures WHERE End_year= 2019 and Country_name = 'INDIA' and avg>43 and HS>150 and Avg>40; 





#9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
#considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for South Africa.
 CREATE VIEW  Batting_Order_GoodAvgScorers_SA AS
 SELECT *,RANK() OVER(ORDER BY Avg desc) as BATTING_ORDER FROM icc_test_batting_figures WHERE End_year = 2019 AND Country_name = 'SA' LIMIT 6;

SELECT * FROM Batting_Order_GoodAvgScorers_SA;


#10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, 
#considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.

CREATE VIEW Batting_Order_HighestCenturyScorers_SA AS
SELECT *,RANK() OVER(ORDER BY `100` desc) AS BATTING_ORDER FROM icc_test_batting_figures 
WHERE End_year = 2019 AND Country_name = 'SA' LIMIT 6;

SELECT * FROM Batting_Order_HighestCenturyScorers_SA;

