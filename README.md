# Autoban groestlcoin nodes
Shell script to automatically identify and ban certain groestlcoin clients.
Define which clients you wish to ban and let the script autoban them.

## Requirements for the bash script (ban.sh)

### Command-line JSON processor jq.

Install on Debian-based Linux
````
sudo apt-get install jq
````

## Configuration

1. Adjust CLIENT variable so it calls groestlcoin-cli with the right parameters

````
CLIENT=/usr/local/bin/groestlcoin-cli
````

2. Enter a list of subversions of nodes, or just part of it, in the array in order to ban them

````
declare -a arr=("/bitcore:1.1.0/" "/Satoshi:1.14.4/" "/bitcoinj:0.14.5/")

````

3. Add script to the crontab to run periodically

````
crontab -e
````

## Download and use the script
````
git clone https://github.com/Groestlcoin/autoban-groestlcoin-nodes.git
cd autoban-groestlcoin-nodes
chmod u+x ban.sh
````

## Run the bash script
````
./ban.sh
````
