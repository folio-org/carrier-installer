# Carrier | Installer
### Prerequisites
Install Docker.  
Required ports for SSH and Local installation:
22, 80, 3100, 6379, 8086.
### How to use
!! Make sure that you have at least 16GB of RAM on VM where you want install Carrier !!

#### Local installation:

1) Run the docker command:

``
docker run -it -v /opt:/opt -v /var/run/docker.sock:/var/run/docker.sock -p 1337:1337 getcarrier/installer
``  
2) Open http://localhost:1337/ in your browser  
3) Choose local  

#### Other installation:
1) Run the docker command:

``
docker run -it -p 1337:1337 getcarrier/installer
``

2) Open http://localhost:1337/ in your browser
3) Choose your preferred option

## Current status
### Clouds
AWS - Only Ubuntu Server 18.04 LTS.  
GCP - Ubuntu: 18.04, 19.10, 20.04. Centos: 7, 8.  
AZURE - Under Development.
### SSH
Working correctly with [Ubuntu: 18.04, 19.10, 20.04. Centos: 7, 8.]
### Local
Working correctly with [Ubuntu: 18.04 Centos: 7 ]
### Kubernetes
Under Development.
