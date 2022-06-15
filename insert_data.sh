#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  if [[ $YEAR != "year" ]]
  then 
    #CHECK IF TEAM IS UNIQUE OR 
    CHECK_TEAM=$($PSQL "SELECT name FROM teams WHERE team='$WINNER'")
      # if not found
      if [[ -z $CHECK_TEAM ]]
        then
          # insert course
          INSERT_COURSE_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          if [[ $INSERT_COURSE_RESULT == "INSERT 0 1" ]]
          then
            echo Inserted into team 
          fi
      fi
    
    CHECK_TEAM=$($PSQL "SELECT name FROM teams WHERE team='$OPPONENT'")

      if [[ -z $CHECK_TEAM ]]
      then
          # insert course
      INSERT_COURSE_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_COURSE_RESULT == "INSERT 0 1" ]]
        then
            echo Inserted into team 
        fi
      fi
  fi
done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  if [[ $YEAR != "year" ]]
  then 
  #CHECK IF TEAM IS UNIQUE OR 
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      
  
    INSERT_GAMES=$($PSQL "INSERT INTO games(year ,round ,winner_id ,opponent_id ,winner_goals ,opponent_goals) VALUES($YEAR, '$ROUND', '$WINNER_ID', '$OPPONENT_ID',$WINNER_G,$OPPONENT_G)")
    if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then
      echo "Inserted into GAMES"
    fi
  
    
  fi
done