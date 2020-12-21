# Carrier | Installer
### Prerequisites
Install Docker.  
Required ports for SSH and Local installation:
22, 80, 3100, 6379, 8086.
### How to use
!! Make sure that you have at least 32GB of RAM on VM where you want install Carrier !!  
!! Make sure that you have public ip address!!
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

### Clouds
AWS:
1) Provide AWS key pairs, AWS Access Key Id, AWS Secret Key, Region, Virtual Machine, Operating System.  
2) Click "Install".  
      
GCP:
1) Provide Google Cloud Platform credentials (json file), Google Cloud Platform Account Name, Region, Virtual Machine, Operating System.  
2) Click "Install".  
      
AZURE:
1) Login to https://microsoft.com/devicelogin and type device CODE that provided you on installation page.   
2) Choose your Region, Virtual Machine type and Operating System.   
3) Click "Install".  
  
### Kubernetes
Under Development.
