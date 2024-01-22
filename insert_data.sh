#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOALS OPPGOALS
do
  echo -e "\n $YEAR, $ROUND, $WINNER, $OPPONENT, $WINGOALS, $OPPGOALS"
  if [[ $YEAR != "year" ]]
  then
    # Get the team id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    # Confirm if winner exist in teams
    if [[ -z $WINNER_ID ]]
    then
      # Insert into teams
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")

      # Confirm insertion
      if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
      then
        # Print insert message
        echo -e "\nTeam successfully inserted"
      
      fi

    fi

    # Confirm if opponent exist in teams
    if [[ -z $OPPONENT_ID ]]
    then
      # Insert into teams
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")

      # Confirm insertion
      if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
      then
        # Print insert message
        echo -e "\nTeam successfully inserted"
      
      fi

    fi

    # Get the new id of the two teams
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    # Insert into games
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, opponent_goals, winner_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $OPPGOALS, $WINGOALS)")

    #Confirm insertion
    if [[ $INSERT_GAMES_RESULT == 'INSERT 0 1' ]]
    then
    # Print insertion message.
      echo -e "\nGames successfully inserted"
    
    fi


  fi
done

