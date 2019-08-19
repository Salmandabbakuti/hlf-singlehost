echo 'Restarting Network..'

echo 'Re-creating Certificates for network 

CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd $CURRENT_DIR/deployment
sed -i "s/${PRIV_KEY}/CA_PRIVATE_KEY/g" docker-compose-kafka.yml
cd ..
rm -rf crypto-config
rm -rf network-config
mkdir network-config

./generate.sh

./start.sh

./iq.sh

echo 'All Done..'
