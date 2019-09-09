echo 'Shutting Network Down...'

sudo docker-compose -f deployment/docker-compose-kafka.yml down
sudo docker volume prune
sudo docker network prune
sleep 2
echo 'All done...'

exit 1
