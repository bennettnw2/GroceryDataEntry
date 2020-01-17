#!/bin/bash

echo "Inserting into testDB"
sqlite3 testDelete.db 'insert into testdel2 values("word", 3, "bird");'
