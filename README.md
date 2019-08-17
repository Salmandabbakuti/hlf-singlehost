# Steps
##### 1. Generate Crypto Matirials 
```
./generate.sh #Certificates Generation and channel configurations Setup
```

 ##### 2. Bringing Up Network
 ```
./start.sh # Starting Network, Channel creation, Peers Joining channel, Installing and Initiating Chaincode 
```
##### 3. Invoking and querying Chaincode from all 3 peers

```
./iq.sh   #Invoking and querying Chaincode from all 3 peers
```

# Work flow

#### 1. Generating Crypto matirials and Channel Configurations

```
git clone https://github.com/Salmandabbakuti/hlf-singlehost.git
cd hlf-singlehost

export PATH=${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/fabric-config

cryptogen generate --config=./fabric-config/crypto-config.yaml   #Certificates Generation
configtxgen -profile OneOrgsOrdererGenesis -outputBlock ./network-config/orderer.block   #Genesis block generation
configtxgen -profile OneOrgsChannel -outputCreateChannelTx ./network-config/channel.tx -channelID mychannel   #channel creation
configtxgen -profile OneOrgsChannel -outputAnchorPeersUpdate ./network-config/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP   #Anchor peer peer generation for org1

```
#### 2. Starting Network

Before starting network, we must modify Ca key file in ```docker-compose-kafka.yml```
 like below
 
 ```
 ca.example.com:
  image: hyperledger/fabric-ca
  environment: 
    - FABRIC_CA_SERVER_CA_CERTFILE=/etc/hyperledger/fabric-ca-server-config/ca.org1.example.com-cert.pem
    - FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric-ca-server-config//etc/hyperledger/fabric-ca-server-config/<Key file>
  volumes:
    - ../crypto-config/peerOrganizations/org1.example.com/ca/:/etc/hyperledger/fabric-ca-server-config
  container_name: ca.example.com
  ```
```
docker-compose -f deployment/docker-compose-kafka.yml up -d    #Main containers
docker-compose -f deployment/docker-compose-cli.yml up -d      #cli Container

```

#### 3. Creating Channel and Joining Peers

```
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer0.example.com:7050 -c mychannel -f /var/hyperledger/configs/channel.tx  #peer0 channel creation

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block    #peer0 joins channel

# copy mychannel.block from peer0 to host
docker cp peer0.org1.example.com:/mychannel.block .

# copy mychannel.block to peer1 and peer2
docker cp mychannel.block peer1.org1.example.com:/mychannel.block
docker cp mychannel.block peer2.org1.example.com:/mychannel.block

# remove mychannel.block from host
rm mychannel.block


docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org1.example.com/msp" peer1.org1.example.com peer channel join -b mychannel.block  #peer1 joins channel

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org1.example.com/msp" peer2.org1.example.com peer channel join -b mychannel.block   #peer2 joins channel
```
#### 4. Setting up Chaincode

```
docker exec -it cli peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 0 via cli


#define connecting peer to peer1 on docker-compose-cli.yaml
- CORE_PEER_ADDRESS=peer1.org1.example.com:7051

# install chaincode 
docker exec -it cli peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 1 via cli

# define connecting peer to peer2 on docker-compose-cli.yaml
- CORE_PEER_ADDRESS=peer2.org1.example.com:7051 

# install chaincode 
docker exec -it cli peer chaincode install -n mycc -p github.com/chaincode -v v0  #installing chaincode on peer 1 via cli
```
##### Instantiating Chaincode through channel

```
docker exec -it cli peer chaincode instantiate -o orderer0.example.com:7050 -C mychannel -n mycc github.com/chaincode -v v0 -c '{"Args": ["a", "100"]}'
```

#### 5. Invoking and Querying Chaincode from peers

```
# define connecting peer to your specified peer in docker-compose-cli.yaml 
- CORE_PEER_ADDRESS=peer0.org1.example.com:7051 in cli container

# invoke chaincode
docker exec -it cli peer chaincode invoke -o orderer0.example.com:7050 -n mycc -c '{"Args":["set", "a", "20"]}' -C mychannel

# define conneting peer to specified peerin docker-compose-cli.yaml
- CORE_PEER_ADDRESS=peer2.org1.example.com:7051

# query transaction
docker exec -it cli peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C mychannel


```


