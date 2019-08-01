echo 'Starting Cli container for Peer0..'
sudo docker-compose -f deployment/docker-compose-cli.yml up -d
sleep 3
echo 'Invoking Chaincode From Peer0'
sudo docker exec -it cli peer chaincode invoke -o orderer0.example.com:7050 -n mycc -c '{"Args":["set", "a", "20"]}' -C mychannel
sleep 5
echo 'Querying For Result on Peer0'
sudo docker exec -it cli peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C mychannel

echo 'Starting Cli container for Peer1..'
sudo docker-compose -f deployment/docker-compose-cli1.yml up -d
sleep 3
echo 'Invoking Chaincode From Peer1'
sudo docker exec -it cli1 peer chaincode invoke -o orderer0.example.com:7050 -n mycc -c '{"Args":["set", "a", "40"]}' -C mychannel
sleep 5
echo 'Querying For Result on Peer1'
sudo docker exec -it cli1 peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C mychannel

echo 'Starting Cli container for Peer2..'
sudo docker-compose -f deployment/docker-compose-cli2.yml up -d
sleep 3
echo 'Invoking Chaincode From Peer2'
sudo docker exec -it cli2 peer chaincode invoke -o orderer0.example.com:7050 -n mycc -c '{"Args":["set", "a", "60"]}' -C mychannel
sleep 5
echo 'Querying For Result on Peer2'
sudo docker exec -it cli2 peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C mychannel

exit 1
