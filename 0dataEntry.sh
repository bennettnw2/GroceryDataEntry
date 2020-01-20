#!/bin/bash

clear
echo "Welcome to the GroceryDB Data Entry Script"
sleep 1

# enter the fixed part of each receipt
entryFixed() {
    read -p "Please enter: Date and Store Name: " date store
}

# enter the items on each recipt
entryVary() {
    echo "Please enter: Item Name | Price | Category | Qty | Unit"
    read item price cat qty unit
}

# construct the string to enter the data into the database
construct() {
  echo "adding to database" sqlite3 grocery.db "insert into grocerylist (\"$item\",$price,\"$date\",\"$store\",\"$cat\",$qty,\"$unit\");"
  sqlite3 grocery.db "insert into grocerylist values (\"$item\",$price,\"$date\",\"$store\",\"$cat\",$qty,\"$unit\");"
}

# Runs the above functions once before we get into the loop
entryFixed
entryVary
construct

# Menu so the user can either start a new receipt, continue entering items, or quit
x=0
while [ $x = 0 ]
do
  read -p "(c)ontinue | new (r)eceipt | (re)peat entry | (cl)ear | (q)uit: " RES

  case $RES in
    c)
    entryVary
    construct
    ;;
    r)
    entryFixed
    entryVary
    construct
    ;;
    re)
    construct
    ;;
    cl)
    clear
    ;;
    q)
    echo "See you later!"
    sleep 1
    x=1
    ;;
    *)
    echo "You missed. Please try again."
    sleep 1
    ;;
  esac
done
