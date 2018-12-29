# Enables docker service as a normal user
# Sources:
# https://github.com/docker/docker-snap
sudo snap connect docker:home
sudo addgroup --system docker
sudo adduser $USER docker
newgrp docker
sudo snap disable docker
sudo snap enable docker
