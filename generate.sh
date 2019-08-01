echo 'Generating Crypto Certificates for Network...'

export PATH=${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/fabric-config

cryptogen generate --config=./fabric-config/crypto-config.yaml   

echo 'Certificates Generated for All Participants and Stored in crypto-config folder...'
configtxgen -profile OneOrgsOrdererGenesis -outputBlock ./network-config/orderer.block  
echo 'Network Initiated with Genesis block'

echo 'Channel Configuration Started...'
configtxgen -profile OneOrgsChannel -outputCreateChannelTx ./network-config/channel.tx -channelID mychannel  

echo 'Anchor Peer Configurations for Org1 Updating...' 
configtxgen -profile OneOrgsChannel -outputAnchorPeersUpdate ./network-config/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP   #Anchor peer peer generation for org1

echo 'All Done..Bye..'
