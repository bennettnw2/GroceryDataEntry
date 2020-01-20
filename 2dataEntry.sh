#!/bin/bash

echo "Welcome to the GroceryDB Data Entry Script"
sleep 1

entryFixed() {
    read -p "Please enter: Date and Storename: " date store
}

entryVary() {
    echo "Please enter: Item Name, Price, Category, Qty, Unit"
    read item price category qty unit
}

construct() {
  echo "adding to database" sqlite3 grocery.db "insert into grocerylist (\"$item\",$price,\"$date\",\"$store\",\"$category\",$qty,\"$unit\");"
  sqlite3 grocery.db "insert into grocerylist values (\"$item\",$price,\"$date\",\"$store\",\"$category\",$qty,\"$unit\");"
  read -p "(c)ontinue | new (r)ecipt | (q)uit: " CHOICE
  choice
}

choice() {
  if [ $CHOICE == "q" ]; then
    echo "See ya later!"
    exit 0
  elif [ $CHOICE == "r" ]; then
      entryFixed
      CHOICE="c"
    while [ $CHOICE == "c" ]; do
      entryVary
      construct
      read -p "(c)ontinue | new (r)ecipt | (q)uit: " CHOICE
      choice
    done
  else
    echo "That's not right!"
    read -p "(c)ontinue | new (r)ecipt | (q)uit: " CHOICE
    choice
  fi
}

CHOICE="r" 

choice
