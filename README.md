# HANAExpress2.0

HANA Express Edition comes in MDC format having 0 or more tenants. With HANA 2.0 SP03 the EPM-MDS plugion comes built in.
HANA Express Edition can be installed instantly by many ways such as by using SAP CAL which launches the instance in the Cloud environment like AWS, Azure, GCP, Alibaba Cloud.
For applying SSL certificate on the XSE there are to ways:
1. You can use self signed certificate for dev boxes if you do not have any signig CA
2. SAP provides its own CA and that can be applied on XSE as well 

Pre-req:

1. For hosting the instance on premise on your own personal laptop you can use VmWare Virtual Box or you can download appropriate OS from osboxes.org. 
2. To host these virtual boxes for HANA DB your PC needs to have atleast 16 GB of RAM and virtualisation should be enabled in BIOS for your PC.
3. Docker has to be installed in your virtual box by using the script docker.sh

The main application here is Menu.sh which provides the user all the catalog options mentioned in the case study.

1. HANA DB with EPM-MDS plugin will be installed by HANAsetup.sh script
2. Tenant DB will be created by HANAservice.sh by calling commands.sql file
3. HANA DB by default has password policy of min length 8 characters from the four categories, including: uppercase letters, lowercase letters, numbers, and characters 
4. XSE will be embedded in the tenant by the script embedXSE.sh by calling embedXSE.sql and https will be configured on the XSE by using the script signedcer.sh
5. Tenant DB will be stopped by the script Stoptenant.sh by calling Stoptenant.sql
6. Tenant DB is dropped by executing dropdb.sh by calling dropdb.sql
7. DB in uninstalled by executing the script uninstall.sh 
