echo 'Network Restarting....'

sudo docker-compose -f deployment/docker-compose-kafka.yml up -d

echo 'Network Booting up... Should takes 20 seconds'
sleep 20

echo 'Channel Creation Taking Place...'

sudo docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer0.example.com:7050 -c mychannel -f /var/hyperledger/configs/channel.tx  #peer0 channel creation

echo 'Channel Creation done..'

sudo docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block    #peer0 joins channel

echo 'Peer0 joinined Channel...'

echo 'copying mychannel.block from peer0 to peer1 and peer2'
sudo docker cp peer0.org1.example.com:/mychannel.block .

# copy mychannel.block to peer1 and peer2
sudo docker cp mychannel.block peer1.org1.example.com:/mychannel.block
sudo docker cp mychannel.block peer2.org1.example.com:/mychannel.block

# remove mychannel.block from host
sudo rm mychannel.block

echo 'Peers Joining Takes place...'
sudo docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org1.example.com/msp" peer1.org1.example.com peer channel join -b mychannel.block  #peer1 joins channel
echo 'Peer1 Joined Channel Successfully...'
sudo docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org1.example.com/msp" peer2.org1.example.com peer channel join -b mychannel.block   #peer2 joins channel

echo 'Peer2 Joined Succesfully..'

echo 'All Done....Ready To test..'
