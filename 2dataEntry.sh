#!/bin/bash

echo "Welcome to the GroceryDB Data Entry Script"
sleep 1

entryFixed() {
    read -p "Please enter: Date and Store Name: " date store
}

entryVary() {
    echo "Please enter: Item Name | Price | Category | Qty | Unit"
    read item price cat qty unit
}

construct() {
  echo "adding to database" sqlite3 grocery.db "insert into grocerylist (\"$item\",$price,\"$date\",\"$store\",\"$cat\",$qty,\"$unit\");"
  sqlite3 grocery.db "insert into grocerylist values (\"$item\",$price,\"$date\",\"$store\",\"$cat\",$qty,\"$unit\");"
}

choice() {
  if [ $CHOICE == "q" ]; then
    echo "See ya later!"
    exit 0
  elif [ $CHOICE == "r" ]; then
      entryFixed
      echo $CHOICE
      CHOICE="c"
    while [ $CHOICE == "c" ]; do
      echo $CHOICE
      entryVary
      construct
      read -p "(c)ontinue | new (r)ecipt | (q)uit: " CHOICE
      if [ $CHOICE == "q" ]; then
        echo "See ya later!"
        exit 0
      elif [ $CHOICE == "r" ]; then
        choice
      else
        echo "That's not right!"
        read -p "(c)ontinue | new (r)ecipt | (q)uit: " CHOICE
        choice
      fi
    done
  else
    echo "That's not right!"
    read -p "(c)ontinue | new (r)ecipt | (q)uit: " CHOICE
    choice
  fi
}

CHOICE="r" 

choice
