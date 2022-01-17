#!/bin/bash

sudo /hana/shared/HXE/hdblcm/hdblcm --uninstall --components=all;

sleep 3600;

sudo /usr/sap/hostctrl/exe/saphostexec -uninstall;

sleep 3600;