echo 'Network Restarting....'

sudo docker-compose -f deployment/docker-compose-kafka.yml up -d

echo 'Network Booting up... Should takes 20 seconds'
sleep 30

echo 'Channel Creation Taking Place...'

sudo docker exec -i cli peer channel create -o orderer0.example.com:7050 -c mychannel -f /var/hyperledger/configs/channel.tx  #peer0 channel creation

echo 'Channel Creation done..'

sudo docker exec -i cli peer channel join -b mychannel.block    #peer0 joins channel

echo 'Peer0 joinined Channel...'

echo 'copying mychannel.block from peer0 to peer1 and peer2'
# copy mychannel.block to peer1 and peer2
docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/mychannel.block .

docker cp mychannel.block cli1:/opt/gopath/src/github.com/hyperledger/fabric/peer/mychannel.block
docker cp mychannel.block cli2:/opt/gopath/src/github.com/hyperledger/fabric/peer/mychannel.block
rm mychannel.block

echo 'Peers Joining Takes place...'
sudo docker exec -i cli1 peer channel join -b mychannel.block  #peer1 joins channel
echo 'Peer1 Joined Channel Successfully...'
sudo docker exec -i cli2 peer channel join -b mychannel.block   #peer2 joins channel

echo 'Peer2 Joined Succesfully..'

echo 'All Done....Ready To test..'
