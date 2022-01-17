#!/bin/bash

echo " Select what action you would like to take"
echo "1. Install HANA DB"
echo "2. Deploy EMP-MDS Plugin"
echo "3. Create New Tenant DB"
echo "4. Create password policy"
echo "5. XSE in tenant and configure https"
echo "6. Stop Tenant"
echo "7. Drop DB"
echo "8. Uninstall HANA"
echo "9. Exit"

echo -n "Enter your menu choice [1-9]: "
while :
do
read choice

case $choice in
1)  
  # Pattern 2
  2)  echo "You have selected the option 2"
      echo "Selected Fruit is Grapes. ";;
  # Pattern 3
  3)  echo "You have selected the option 3"
      echo "Selected Fruit is Mango. ";;    
  # Pattern 4
  9)  echo "Exiting ..."
      exit;;
  # Default Pattern
  *) echo "invalid option";;
  
esac
  echo -n "Enter your menu choice [1-9]: "
done