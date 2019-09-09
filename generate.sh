echo 'Generating Crypto Certificates for Network...'

export PATH=${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/fabric-config

CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR/deployment"
sed -i "s/${PRIV_KEY}/CA_PRIVATE_KEY/g" docker-compose-kafka.yml

rm -rf network-config
mkdir network-config


cryptogen generate --config=./fabric-config/crypto-config.yaml   

echo 'Certificates Generated for All Participants and Stored in crypto-config folder...'
configtxgen -profile OneOrgsOrdererGenesis -outputBlock ./network-config/orderer.block  
echo 'Network Initiated with Genesis block'

echo 'Channel Configuration Started...'
configtxgen -profile OneOrgsChannel -outputCreateChannelTx ./network-config/channel.tx -channelID mychannel  

echo 'Anchor Peer Configurations for Org1 Updating...' 
configtxgen -profile OneOrgsChannel -outputAnchorPeersUpdate ./network-config/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP   #Anchor peer peer generation for org1

echo 'Setting Up your CA Container'
CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR/deployment"
sed -i "s/CA_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-kafka.yml

echo 'All Done..Bye..'
exit 1
