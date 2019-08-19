echo 'Shutting Network Down...'

sudo docker-compose -f deployment/docker-compose-kafka.yml down
sleep 2
sudo docker-compose -f deployment/docker-compose-cli.yml down
sudo docker-compose -f deployment/docker-compose-cli1.yml down
sudo docker-compose -f deployment/docker-compose-cli2.yml down

CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd $CURRENT_DIR/deployment
sed -i "s/${PRIV_KEY}/CA_PRIVATE_KEY/g" docker-compose-kafka.yml
echo 'All done...'

exit 1
