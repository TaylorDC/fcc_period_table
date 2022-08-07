#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
 then
  if [[ $1 =~ ^[0-9]$ ]]
    then
      ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements left join properties on properties.atomic_number = elements.atomic_number left join types on types.type_id = properties.type_id WHERE elements.atomic_number = $1")
  elif [[ $1 =~ ^[a-zA-Z]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements left join properties on properties.atomic_number = elements.atomic_number left join types on types.type_id = properties.type_id WHERE elements.symbol = '$1' OR elements.name = '$1'")
  fi
  if [[ -z $ELEMENT ]]
    then
      echo "I could not find that element in the database."
  else
    read -r ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE <<< "${ELEMENT}"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi 
else  
  echo "Please provide an element as an argument."
fi
