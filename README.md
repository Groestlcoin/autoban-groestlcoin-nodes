# Autoban bitcoin nodes
Shell script to automatically identify and ban certain bitcoin clients.
Define which clients you wish to ban and let the script autoban them.

## Requirements for the bash script (ban.sh)

### Command-line JSON processor jq.

Install on Debian-based Linux
```` 
sudo apt-get install jq
```` 

## Configuration

1. Adjust CLIENT variable so it calls bitcoin-cli with the right parameters

```` 
CLIENT=/usr/local/bin/bitcoin-cli
````

2. Enter the list of nodes you wish to ban in the array

```` 
declare -a arr=("/bitcore:1.1.0/" "/ViaBTC:bitpeer.0.2.0/" "/BitcoinUnlimited:1.0.3(EB16;AD12)/" "/Satoshi:1.14.4(2x)/" "/bitcoinj:0.14.5/")

````

3. Add script to the crontab to run periodically!

```` 
crontab -e
````

## Download and use the script
````
git clone https://github.com/iioch/autoban-bitcoin-nodes.git
cd autoban-bitcoin-nodes
chmod u+x ban.sh
````

## Run the bash script
```` 
./ban.sh
````
