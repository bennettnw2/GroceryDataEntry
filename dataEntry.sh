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
# So testing this out is tough going as I have not figured out how to get past passing these varialbes in the proper format so that
# sqlite3 will accept it; keep plugging away; I think i do have a fool proof plan to simply write everything out to a file and then at the end
# use the .import command it import the data from the file....
construct() {
  # args="'$item', $price, '$date', '$store', '$category', $qty, '$unit'"
  # sqlite3 grocery.db 'INSERT INTO grocerylist values($args);'
  echo "adding to database" sqlite3 grocery.db "insert into grocerylist (\"$item\",$price,\"$date\",\"$store\",\"$category\",$qty,\"$unit\");"
  sqlite3 grocery.db 'insert into grocerylist ("$item",$price,"$date","$store","$category",$qty,"$unit");'
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

