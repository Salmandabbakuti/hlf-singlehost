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
