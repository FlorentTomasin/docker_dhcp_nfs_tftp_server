# DHCP, NFS and TFTP server based on Alpine OS running in a Docker container

This project helps to setup a DHCP, NFS, TFTP server.
This toolset can be used in the Embedded world to boot a device through the network or for automated testing. <br/>
It eases the network configuration process and does not affect the Host environment.

This README does not explains how to write the DHCP, NFS and TFTP configurations. Please refer to specific document if needed.

## Install
First install Docker:
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
sudo usermod -aG docker $USER
```
Log out and log in.

Then build the Docker image:
```
./setup.sh
```
## Usage
You can configure your setup by editing the .env file and the DHCP configuration files in "./dhcp". <br/>
By default the NFS fils are stored in "./nfs" and the DHCP config are empty. <br/>
Please complete the config file according to your use case.

The container port mappping can be manually configured.

Once you have edited the configuration files execute the following command to launch the Docker container:
```
./run.sh
```

## Usefull links
Alpine OS network Wiki: <br/>
https://wiki.alpinelinux.org/wiki/Configure_Networking <br/>
Editing dhcpd.conf: <br/>
https://www.isc.org/wp-content/uploads/2017/08/dhcp41conf.html <br/>
Editing interfaces: <br/>
https://wiki.debian.org/NetworkConfiguration <br/>
