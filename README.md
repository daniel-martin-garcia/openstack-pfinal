# CNVR PFINAL2 - OPENSTACK

# Deploy Openstack
In order to download and start Openstack, you should run the next script:
```sh
$ ./deploy.sh
```
# Create images
First of all, it is necessary to create the images for both servers and datase.

For servers:
```sh
$ ./server_image_creation.sh
```

For database
```sh
$ ./db_image_creation.sh
```

# Deploy scenario
In order to deploy the scenario, it is necessary to run the next script:
```sh
$ ./script.sh
```

# Firewall SSH Admin rule
In order to set the FW rule and enable SSH between localhost and admin server:
```sh
$ ./ssh_rules.sh SET
```
In order to unset the FW rule and disable SSH between localhost and admin server:
```sh
$ ./ssh_rules.sh UNSET
```