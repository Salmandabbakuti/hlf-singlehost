echo 'Installing Chaincode on Peer0'

sudo docker exec -it cli peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 0 via cli

echo 'Installing on Peer1'

sudo docker exec -it cli1 peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 1 via cli

echo 'Installing on Peer2'

sudo docker exec -it cli2 peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 2 via cli

echo 'Chaincode Succesfully installed on All Peers..'

echo 'Instantiating Chaincode On Channel..'

sudo docker exec -it cli peer chaincode instantiate -o orderer0.example.com:7050 -C mychannel -n mycc github.com/chaincode -v v0 -c '{"Args": ["a", "100"]}'

sleep 5
echo 'Invoking Chaincode From Peer0'
sudo docker exec -it cli peer chaincode invoke -o orderer0.example.com:7050 -n mycc -c '{"Args":["set", "a", "20"]}' -C mychannel
sleep 3
echo 'Querying for Result on Peer0 
sudo docker exec -it cli peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C mychannel

echo 'Invoking Chaincode From Peer1'
sudo docker exec -it cli1 peer chaincode invoke -o orderer0.example.com:7050 -n mycc -c '{"Args":["set", "a", "40"]}' -C mychannel
sleep 5
echo 'Querying For Result on Peer1'
sudo docker exec -it cli1 peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C mychannel

echo 'Invoking Chaincode From Peer2'
sudo docker exec -it cli2 peer chaincode invoke -o orderer0.example.com:7050 -n mycc -c '{"Args":["set", "a", "60"]}' -C mychannel
sleep 5
echo 'Querying For Result on Peer2'
sudo docker exec -it cli2 peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C mychannel

echo 'All Done..'
exit 1
