#!/bin/bash

#INSTANCE='<YOUR_HANA_SID>'
#SIDADM='<YOUR_HANA_SIDADM>'
#INSTNO='<YOUR_HANA_INST_NO>'
#HOST='<YOUR_HANA_NETWORK_HOST>'
#DOMAIN='<YOUR_HANA_NETWORK_DOMAIN>'
#ORG='<YOUR_CERTIFICATE_ORGNANIZATION>'
#COUNTRY='<YOUR_CERTIFICATE_COUNTRY>'

INSTANCE='TST'
SIDADM='tstadm'
INSTNO='90'
HOST='hxehost'
DOMAIN='pal.sap.corp'
ORG='SAP'
COUNTRY='DE'
PIN=''

DIR_SECURITY_LIB="/usr/sap/$INSTANCE/SYS/global/security/lib"
cp libsapcrypto.so $DIR_SECURITY_LIB
cp sapgenpse $DIR_SECURITY_LIB
cp SAPNetCA.cer $DIR_SECURITY_LIB
mkdir $SECUDIR

##########################################
# sapssl
##########################################
# Create the SSL key pair and the certificate request in $SECUDIR
# This creates the Personal Security Environment (SAPSSL.pse) and the corresponding certificate request (SAPSSL.req).
$DIR_SECURITY_LIB/sapgenpse get_pse -p $SECUDIR/SAPSSL.pse -x $PIN -r $SECUDIR/SAPSSL.req "CN=${HOST}.${DOMAIN}, OU=${INSTANCE}, O=$ORG, C=$COUNTRY"
cat $SECUDIR/SAPSSL.req
read -p "
Now go to your signing CA (SAP also offers CA services where you can have test certificates signed instantly at
        http://service.sap.com/Trust
        https://websmp106.sap-ag.de/SSLTest
) and sign the certificate.
In the SAP in house case it works like this:
    - Go to https://secsrvtest.wdf.sap.corp/TCS/cgi-bin/secuWPCA.pl
    - paste the content from SAPSSL.req (printed above) to the text area
    - leave SAPNetCA as CA
    - select 'certify the cert. req.' as command
    - submit
    - Copy the resulting certificate from the output (everything including -----BEGIN CERTIFICATE----- and -----END CERTIFICATE-----)
      to a new text file (here: SAPSSL.cert) and save it to '$SECUDIR'
      ( here: $SECUDIR/SAPSSL.cert ) .
    -> Hit <ENTER> when finished
"
#Import the certificate into the PSE:
$DIR_SECURITY_LIB/sapgenpse import_own_cert -c $SECUDIR/SAPSSL.cert -p $SECUDIR/SAPSSL.pse -x $PIN -r $DIR_SECURITY_LIB/SAPNetCA.cer
#Create a Credential File to enable access for HDB (which runs as <sid>adm) to the PSE: Use
$DIR_SECURITY_LIB/sapgenpse seclogin -p $SECUDIR/SAPSSL.pse -x $PIN -O $SIDADM
# and make the credentials file read only for <sid>adm
chmod 600 $SECUDIR/cred_v2
##########################################
# sapsrv
##########################################
$DIR_SECURITY_LIB/sapgenpse get_pse -p $SECUDIR/sapsrv.pse -x '' -r $SECUDIR/sapsrv.req "CN=${HOST}.${DOMAIN}, OU=${INSTANCE}, O=$ORG, C=$COUNTRY"
cat $SECUDIR/sapsrv.req
read -p "
Now go to your signing CA (SAP also offers CA services where you can have test certificates signed instantly at
        http://service.sap.com/Trust
        https://websmp106.sap-ag.de/SSLTest
) and sign the certificate.
In the SAP in house case it works like this:
    - Go to https://secsrvtest.wdf.sap.corp/TCS/cgi-bin/secuWPCA.pl
    - paste the content from sapsrv.req (printed above) to the text area
    - leave SAPNetCA as CA
    - select 'certify the cert. req.' as command
    - submit
    - Copy the resulting certificate from the output (everything including -----BEGIN CERTIFICATE----- and -----END CERTIFICATE-----)
      to a new text file (sapsrv.cert) and save it to '$SECUDIR'
      ( $SECUDIR/sapsrv.cert ) .
    -> Hit <ENTER> when finished
"
#Import the certificate into the PSE:
$DIR_SECURITY_LIB/sapgenpse import_own_cert -c $SECUDIR/sapsrv.cert -p $SECUDIR/sapsrv.pse -r $DIR_SECURITY_LIB/SAPNetCA.cer
#Create a Credential File to enable access for HDB (which runs as <sid>adm) to the PSE: Use
$DIR_SECURITY_LIB/sapgenpse seclogin -p $SECUDIR/sapsrv.pse -x $PIN -O $SIDADM
##########################################
# sapcli.pse
##########################################
$DIR_SECURITY_LIB/sapgenpse gen_pse -p $SECUDIR/sapcli.pse -x '' "CN=${HOST}.${DOMAIN}, OU=${INSTANCE}, O=$ORG, C=$COUNTRY"
##########################################
# Configure the HDB Web Dispatcher for SSL
##########################################
echo "
wdisp/ssl_encrypt = 0
ssl/ssl_lib = /usr/sap/$INSTANCE/SYS/global/security/lib/libsapcrypto.so
ssl/server_pse = SAPSSL.pse
icm/HTTPS/verify_client = 0
icm/HTTPS/forward_ccert_as_header = true
" >>  /usr/sap/$INSTANCE/HDB$INSTNO/$HOST/wdisp/sapwebdisp.pfl
kill -9 `pidof sapwebdisp_hdb`
kill -9 `pidof hdbxsengine`

echo "You can check whether the https setup was successfull via
https://$HOST$DOMAIN:43$INSTNO/sap/hana/xs/admin/
- you may need to wait a little bit for a restart of some processes
- you need the according roles
check: Go to the trust manager. If there is no error message on the bottom of the screen you are all setup."
# DEBUGGING
#
# Reset the system (pls adapt the wdisp.pfl on your own (not a must))
# rm -f $DIR_SECURITY_LIB/*; rm -f $SECUDIR/*; kill -9 `pidof sapwebdisp_hdb`; kill -9 `pidof hdbxsengine`
#
#Troubleshooting SSL for HANA/XS
# In HANA Studio, open the Administration perspective for the HANA system and set the following configuration parameters in indexserver.ini, section communication:
# sslcryptoprivder = sapcrypto
# sslkeystore = /usr/sap/<SID>/HDB<instno>/<host>/sec/SAPSSL.pse
# ssltruststore = /usr/sap/<SID>/HDB<instno>/<host>/sec/SAPSSL.pse
# sslvalidatecertificate = false
# sslvalidatecertificate should be set to false, as most of the internal systems won't resolve the hostnames properly.
