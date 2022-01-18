#!/bin/bash

echo "Installing Docker"
./docker.sh

echo " Select what action you would like to take"
echo "1. Install HANA DB with EPM-MDS Plugin"
echo "2. Create New Tenant DB"
echo "3. Embed XSE in tenant and configure https"
echo "4. Stop Tenant"
echo "5. Drop DB"
echo "6. Uninstall HANA"
echo "7. Exit"

echo -n "Enter your menu choice [1-7]: "
while :
do
read choice

case $choice in
1)  sudo ./HANAsetup.sh 
  # Pattern 2
  2)  sudo ./HANAservice.sh
  # Pattern 3
  3)  sudo ./embedXSE.sh
      sudo ./signedcer.sh
  # Pattern 4
  4) sudo ./Stoptenant.sh
  # Pattern 5
  5) sudo ./dropdb.sh
  # Pattern 6
  6) sudo ./uninstall.sh
  7)  echo "Exiting ..."
      exit;;
  # Default Pattern
  *) echo "invalid option";;
  
esac
  echo -n "Enter your menu choice [1-7]: "
done
