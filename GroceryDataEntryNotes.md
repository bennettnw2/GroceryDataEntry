
Fri Jan 17 14:40:33 EST 2020
So in trying to organize this and my thoughts on this project is the reason for this journal.

Where am I now?
I got a skeleton of a program together.  The logic works so far and to my surprise was not as difficult as I am accustomed to.  However, I cannot get the command to run from the script that will allow me to insert data into the database.  It seems I am having troubles with the quotes and double quotes.  I do have another idea to just write the data to a file and then use a .import statement with sqlite3.  I am going to give it a few more tries before I get to trying out the backup idea with .import.

* so it seems that with the command being run from the commandline/script, there needs to be quotes surrounding the sql statement and quotes for the text objects that are being passed into the data base.
* this command works when run from the command line:
  * `sqlite3 grocery.db "insert into grocerylist values('milk', 3.55, '10-10-2000'
  , 'IGA', 'Dairy', 1, 'lb');"
* but when ran from the command line:
  ```
  Please enter: Item Name, Price, Category, Qty, Unit
  Egg 1.55 Dairy 1 doz
  adding to database sqlite3 grocery.db insert into grocerylist ("Egg",1.55,"01-20-2020","IGA","Dairy",1,"doz");
  Error: near "1.55": syntax error
  ```
  is the result.  It seems it get's pass "Egg" but then borks at 1.55. Hmm, maybe all the values need double quotes.  Trying now...
  ```
  Bread 2.60 Grain 24 slcs
  adding to database sqlite3 grocery.db insert into grocerylist ("Bread",2.60,"10-20-2020","IGA","Grain",24,"slcs");
  Error: near "2.60": syntax error
  ```
  Same result...lets try swapping out the double quotes for the single quotes and no quotes around the "floating" numbers (i forget what they are called) 
sqlite3 grocery.db "insert into grocerylist ('$item',$price,'$date','$store','$category',$qty,'$unit');"
No dice with this one either
What I will try is a test database with one entry and hard code everything!

Test:
`sqlite3 testDelete.db insert into testdel values("word", 3);`
Result:
```
$ ./test.sh
Inserting into testDB
./test.sh: line 5: syntax error near unexpected token `('
./test.sh: line 5: `sqlite3 testDelete.db insert into testdel values("word", 3);'
```

Test:
`sqlite3 'testDelete.db insert into testdel values("word", 3);'`
Result:
```
$ ./test.sh
Inserting into testDB
SQLite version 3.26.0 2018-12-01 12:34:55
Enter ".help" for usage hints.
sqlite>
```
Whoa, what!  Oh I see, I put the ' before the db name... brb

Test:
`sqlite3 testDelete.db 'insert into testdel values("word", 3);'`
Result:
```
$ ./test.sh
Inserting into testDB
___________________ JavaDev | bennettnw2 ~/GroceryDataEntry
$ sqlite3 testDelete.db "select * from testdel"
word|3
```
It worked!

Now lets add some complexity with two text types and therefore two sets of quotes...  I'll create a new table in the db with word integer word
Test:
`sqlite3 testDelete.db 'insert into testdel2 values("word", 3, "bird");'`
Result:
```
$ ./test.sh
Inserting into testDB
___________________ JavaDev | bennettnw2 ~/GroceryDataEntry
$ sqlite3 testDelete.db "select * from testdel2"
word|3|bird
```
That worked too!

Now I'll need to pass variables into the command as it works when hard coded