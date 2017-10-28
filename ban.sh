#!/bin/bash

# ban.sh
# shell script to automatically identify and ban certain bitcoin clients

# You need to install jq in order to use this script
command -v jq >/dev/null 2>&1 || { echo >&2 "Please install \"jq\" first. Aborting."; exit 1; }

# Adjust CLIENT variable so it calls bitcoin-cli with the right parameters
# Non standart installations need to add -conf=/PATHtoYOUR/bitcoin.conf -datadir=/PATH/to/YOUR/Datadir/
CLIENT=/usr/local/bin/bitcoin-cli

# Ban Time in seconds, 2592000 = 30 days
BAN_TIME="2592000"

# Temp files
NODES_FILE="`mktemp /tmp/connected-nodes.XXXXXXXXXX`"
BANNED_FILE="`mktemp /tmp/banned-nodes.XXXXXXXXXX`"

# Counter
COUNT=0

# Declaration of array of nodes subversion names.
# Here you can add the nodes subversion or parts of it in order to ban them
declare -a arr=("BitcoinUnlimited" "Bitcoin ABC" "Classic" "Bitcoin Gold" "Satoshi:1.1" "Bitcoin XT" "BUCash" "/bitcore:1.1.0/" "/ViaBTC:bitpeer.0.2.0/" "/BitcoinUnlimited:1.0.3(EB16;AD12)/" "/Satoshi:1.14.4(2x)/" "/bitcoinj:0.14.5/")

# Write connected nodes to NODES_FILE
$CLIENT getpeerinfo >$NODES_FILE

# Extract subversion text and the corresponding IP adress
NODES_TO_BAN=`jq -r '.[] | .addr, .subver'  $NODES_FILE`

# Ban clients with the same or partial subversion as in the array
TEMP_COUNT=0
for NODE in ${NODES_TO_BAN[@]}; do
        if [ $TEMP_COUNT -eq 0 ]; then
                IP=$NODE
                TEMP_COUNT=$((TEMP_COUNT + 1))
        else
                SUBVER=$NODE
                TEMP_COUNT=$((TEMP_COUNT - 1))
                for i in "${arr[@]}"
                do
                        if [[ "$SUBVER" == *"$i"* ]]; then
                                 $($CLIENT setban ${IP%:*} "add" ${BAN_TIME})
                                echo Banned client with Subversion: $SUBVER and IP: $IP >> $BANNED_FILE
                                COUNT=$((COUNT + 1))
                        fi
                done
        fi

done
cat $BANNED_FILE
echo Found and banned $COUNT nodes.

rm $NODES_FILE
rm $BANNED_FILE
