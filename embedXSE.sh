#!/bin/bash
sudo su - bobadm -c 'echo hdbsql -i 90 -d SystemDB -u SYSTEM -p Welcome@1 -I /my_folder/embedXSE.sql'

sleep 3600;

sudo su - bobadm -c 'echo hdbsql -i 90 -d SystemDB -u SYSTEM -p Welcome@1 -I /my_folder/dbstart.sql'

sleep 3600;