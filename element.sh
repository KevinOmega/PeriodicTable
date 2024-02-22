#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c "

ATOMIC_NUMBER=0
SYMBOL=''
NAME=''

if [[ ! -z $1 ]]
then
#if the argument is a number case
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SYMBOL=$($PSQL "SELECT symbol from elements WHERE atomic_number=$1")
    #if symbol exist
    if [[ ! -z $SYMBOL ]]
    then
      NAME=$($PSQL "SELECT name from elements WHERE atomic_number=$1")
      NUMBER=$1
    fi
  else
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1' ")
    if [[ ! -z $NUMBER ]]
    then
      NAME=$($PSQL "SELECT name FROM elements WHERE name='$1' OR symbol='$1' ")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1' OR symbol='$1' ")
    fi
  fi
  if [[ $NUMBER == 0 || $NAME == '' || $SYMBOL == '' ]]
  then
    echo "I could not find that element in the database."
  else
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$NUMBER ")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$NUMBER ")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$NUMBER ")
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$NUMBER")
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi 
else
#if there is no argument case
  echo "Please provide an element as an argument."
fi
