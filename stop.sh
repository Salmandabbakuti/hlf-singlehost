echo 'Shutting Network Down...'

sudo docker-compose -f deployment/docker-compose-kafka.yml down
sleep 2
sudo docker-compose -f deployment/docker-compose-cli.yml down
sudo docker-compose -f deployment/docker-compose-cli1.yml down
sudo docker-compose -f deployment/docker-compose-cli2.yml down

echo 'All done...'

exit 1
