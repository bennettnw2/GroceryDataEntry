#!/bin/bash

echo "Inserting into testDB"
var1=word
var2=3
var3=bird
sqlite3 testDelete.db "insert into testdel2 values (\"$var1\", $var2, \"$var3\");"
