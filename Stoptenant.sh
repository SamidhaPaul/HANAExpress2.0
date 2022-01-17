#!/bin/bash
sudo su - bobadm -c 'echo hdbsql -i 90 -d SystemDB -u SYSTEM -p Welcome@1 -I /my_folder/StopTenant.sql'


sleep 3600;