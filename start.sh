echo 'Network Restarting....'

sudo docker-compose -f deployment/docker-compose-kafka.yml up -d
sudo docker-compose -f deployment/docker-compose-cli.yml up -d
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

echo 'All Done.................'


echo 'Installing Chaincode on Peer0'

sudo docker exec -it cli peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 0 via cli

echo 'Installing on Peer1'

sudo docker-compose -f deployment/docker-compose-cli1.yml up -d
sleep 3
sudo docker exec -it cli1 peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 1 via cli

echo 'Installing on Peer2'
sudo docker-compose -f deployment/docker-compose-cli2.yml up -d
sleep 3

sudo docker exec -it cli2 peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 2 via cli

echo 'Chaincode Succesfully installed on All Peers..'

echo 'Instantiating Chaincode On Channel..'

sudo docker exec -it cli2 peer chaincode instantiate -o orderer0.example.com:7050 -C mychannel -n mycc github.com/chaincode -v v0 -c '{"Args": ["a", "100"]}'

echo 'All Done... You are Good to go.. Bye..'
