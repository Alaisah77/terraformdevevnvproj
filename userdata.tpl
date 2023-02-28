sudo apt-get update

# install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add the Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

# update the package index (again)
sudo apt-get update

# install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# add current user to the docker group
sudo usermod -aG docker $USER

# enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker