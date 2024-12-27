#!/bin/bash
PSQL="psql --username=postgres --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Join the proerties and the elements tables
  if [[ $1 =~ ^[0-9]+$ ]]
  then

    ELEMENT_NUMBER=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties 
                          LEFT JOIN elements
                          USING(atomic_number)
                          WHERE atomic_number = $1")

    echo "$ELEMENT_NUMBER" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
    do
      echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It is a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done

    else
      ELEMENT_NAME=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties
                            LEFT JOIN elements
                            USING(atomic_number)
                            WHERE symbol = '$1'
                            OR name = '$1'")
    if [[ -z $ELEMENT_NAME ]]
    then
      echo -e "\nI could not find that element in the database. Please enter a valid element name or symbol that starts with a capital letter..."
    else
      echo "$ELEMENT_NAME" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
      do
        echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It is a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  fi
fi
