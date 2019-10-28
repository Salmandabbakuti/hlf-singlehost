echo 'Installing chaincode on Peer0'
sudo docker exec -it cli peer chaincode install -n mycc -v 1.0 -p "/opt/gopath/src/github.com/events" -l "node"
sleep 3
echo 'Installing chaincode on Peer1'
sudo docker exec -it cli1 peer chaincode install -n mycc -v 1.0 -p "/opt/gopath/src/github.com/events" -l "node"
sleep 3
echo 'Installing chaincode on Peer2'
sudo docker exec -it cli2 peer chaincode install -n mycc -v 1.0 -p "/opt/gopath/src/github.com/events" -l "node"

sleep 5
echo 'Instantiating chaincode..'
sudo docker exec -it cli peer chaincode instantiate -o orderer0.example.com:7050 -C mychannel -n mycc -l "node" -v 1.0 -c '{"Args":[]}'


echo 'All done..'
exit 1
