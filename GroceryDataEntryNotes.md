
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

Schema for the test databases:
```
CREATE TABLE testdel (word text not null, number integer not null);
CREATE TABLE testdel2 (word text not null, number integer not null, word2 text not null);
CREATE TABLE testdel3 (number integer not null);
```

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

Test:
```
var1=word
var2=3
var3=bird
sqlite3 testDelete.db 'insert into testdel2 values("$var1", $var2, "$var3");'
```
Result:
```
$ ./test.sh
Inserting into testDB
Error: NOT NULL constraint failed: testdel2.number
```
Hmmm, lets dial it back to one integer to pass into a third table

Test:
```
var1=word
var2=3
var3=bird
qlite3 testDelete.db 'insert into testdel3 values($var2);'
```
Result:
```
$ ./test.sh
Inserting into testDB
Error: NOT NULL constraint failed: testdel3.number
```
This is odd as I was not getting this error ever...

Ok!  So after a bit of just testing a bunch of different stuff I figured it out.  Well, not me personally but StackOverflow helped me out. [How to Insert into Sqlite Using Bash](https://stackoverflow.com/questions/4152321/how-to-insert-into-sqlite-database-using-bash)
I attempted to use this post's method before but I ~think I must have~ obviously had a syntactical error as It was not working.

Test:
```
#!/bin/bash

echo "Inserting into testDB"
var1=word
var2=3
var3=bird
sqlite3 testDelete.db "insert into testdel2 values (\"$var1\", $var2, \"$var3\");"
```
Result:
```
$ ./test.sh
Inserting into testDB
___________________ JavaDev | bennettnw2 ~/GroceryDataEntry
$ sqlite3 testDelete.db "select * from testdel2";
word|3|bird
word|3|bird
```


What did I learn?  Break down complex problems into small isolated parts and test different stuff systematically until you read the same stackoverflow post for the 6th time and then it works!  I think it still helped to keep track of what I tested so I could keep everything straight.  So now on to get it to work with my bigger input string.


Sun Jan 19 10:17:52 EST 2020
So I got the dataEntry.sh to work and to be able to add rows to the table.  Next is working on the logic flow a bit and get more functionality.  Right now you are able to start a session by entering the date and store of a receipt and the script will continue to add the date and the store so you do not have to enter it in over and over again with each receipt.  But does not have the functionality to where you can start a new receipt without exiting the program.  That is the next step.


Sun Jan 19 13:22:41 EST 2020
Ok.  So next step this time around is to get the logic of the looping correct.  It seems I may have created a recursive function?  I'll have to get the looping get into the c selection.


Mon Jan 20 13:20:41 EST 2020
Wow.  This is complicated for some reason.  I think I may need to do a case statement?  This is what I want to do.  Have the user enter in c to continue, r for new receipt and q for quit

So not so bad now that I used a case statement! I finally got the logic I wanted and it now works! Used this video for support in making a menu with a case statement.  [Youtube Link](https://www.youtube.com/watch?v=7GvAJhcjNOs)

Added an option to repeat an entry also need to be able to enter in data without entering a quantity and unit.  Right now I get the error:
```bash
OrgBabySpinach 2.49 Produce
adding to database sqlite3 grocery.db insert into grocerylist ("OrgBabySpinach",2.49,"12/15/2019","Aldi","Produce",,"");
Error: near ",": syntax error
```
Seems this is due to the commas next to each other... maybe able to resolve that by placing quotes around the variable so that it will just pass an empty string....
Entered in the first receipt and so far so good!
