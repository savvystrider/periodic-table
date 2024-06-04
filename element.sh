#!/bin/bash

START_SCRIPT() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
    
  else
    # set PSQL variable based on argument
    if [[ $1 == "test" ]]
    then
      PSQL="psql --username=postgres --dbname=periodic_table -t --no-align -c"
    else
      PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
    fi

    SEARCH_DATABASE $1
  fi
}

SEARCH_DATABASE() {
  INPUT=$1

  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT' OR name = '$INPUT'")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $INPUT")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT types.type FROM types JOIN properties ON types.type_id = properties.type_id WHERE properties.atomic_number = $ATOMIC_NUMBER")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
}

START_SCRIPT "$1"
