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

# some notes regarding this section
# Need to figure out how to get the command out properly so that it will render
# all the quotes and double quotes are getting kind of messy
# I think I should test this with the actual, live command to see if it will work
# I don't want to waste time formating if it would not even go through due to command sub
# being all wonky
construct() {
  args="'$item', $price, '$date', '$store', '$category', $qty, '$unit'"
  sqlite3 test.db 'INSERT INTO tab1 values($args);'
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

