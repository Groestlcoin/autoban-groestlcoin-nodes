#!/bin/bash

# ban.sh
# shell script to automatically identify and ban certain bitcoin clients

# Step 1) Adjust BTC_CLI variable so it calls bitcoin-cli with the right parameters
# Non standart installations need to add -conf=/PATHtoYOUR/bitcoin.conf -datadir=/PATH/to/YOUR/Datadir/

BTC_CLI=/usr/local/bin/bitcoin-cli

# Step 2) Enter the list of nodes you wish to ban separated with a comma
# make sure the peer version doesn't contain any commas

BANNED="/bitcore:1.1.0/,/ViaBTC:bitpeer.0.2.0/,/BitcoinUnlimited:1.0.3(EB16;AD12)/,/Satoshi:1.14.4(2x)/,/bitcoinj:0.14.5/"

# The main script 

$BTC_CLI getpeerinfo | mawk -F":" -v banned="$BANNED" -v btccli="$BTC_CLI" -- '
BEGIN {
    split(banned,BAN,",");
}
/\"id\"*/ {
    id=substr($2,2,length($2)-2);ID[id]=id;
}
/^....\"addr\"/ {
    if (substr($2,3,1)=="[") {
        sadr = substr($0,index($0,":"));
        start = index(sadr,"[");
        end = index(sadr,"]");
        IP[id]=substr(sadr,start,end-3);
    } else {
        IP[id]=substr($2,3);
    }
}
/\"subver\"*/ {
    s=length($1)+4;
    VER[id]=substr($0,s,(length($0)-s-1));
}
END {
    for (id in ID) {
        for (banned in BAN) {
            if(VER[id]==BAN[banned]) {
                system(btccli" setban "IP[id]" add");
                echo "Found and banned node version "VER[id]" IP: "IP[id]""
            }
        }
    }
}'
if [ "$COUNT" -eq "0" ];then
 echo No client was banned
fi

# Add script to the crontab to run periodically!
