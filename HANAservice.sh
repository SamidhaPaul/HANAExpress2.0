#!/bin/bash
sudo docker exec -it HXE_DOCKER1 bash 
sudo su - bobadm -c 'echo HDB info' > services.txt

sudo su - bobadm -c 'echo hdbsql -i 90 -d SystemDB -u SYSTEM -p Welcome@1 -I /my_folder/commands.sql'
	





