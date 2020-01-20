#!/bin/bash

echo "Welcome to the GroceryDB Data Entry Script"
sleep 2


choice() {
    read -p "Would you like to enter some data? (y or n): " CHOICE
}

entryFixed() {
    read -p "Please enter: Date and Storename: " date store
}

entryVary() {
    echo "Please enter: Item Name, Price, Category, Qty, Unit"
    read item price category qty unit
}

construct() {
  # args="'$item', $price, '$date', '$store', '$category', $qty, '$unit'"
  # sqlite3 grocery.db 'INSERT INTO grocerylist values($args);'
  echo "adding to database" sqlite3 grocery.db "insert into grocerylist (\"$item\",$price,\"$date\",\"$store\",\"$category\",$qty,\"$unit\");"
  sqlite3 grocery.db "insert into grocerylist values (\"$item\",$price,\"$date\",\"$store\",\"$category\",$qty,\"$unit\");"
  read -p "Continue? (y or n): " CHOICE
}

choice

if [ $CHOICE == "n" ]; then
  echo "See ya later!"
  exit 0
elif [ $CHOICE == "y" ]; then
    entryFixed
  while [ $CHOICE != "n" ]; do
    entryVary
    construct
  done
else
  echo "That's not right!"
  exit 0
fi

# should I do a if loop to check the entry and then a while loop to continue 
# Yes becasue that is what just happened!

