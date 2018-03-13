Ethereum Network Intelligence API
============
[![Build Status][travis-image]][travis-url] [![dependency status][dep-image]][dep-url]

This is the backend service which runs along with ethereum and tracks the network status, fetches information through JSON-RPC and connects through WebSockets to [eth-netstats](https://github.com/cubedro/eth-netstats) to feed information. For full install instructions please read the [wiki](https://github.com/ethereum/wiki/wiki/Network-Status).


## Prerequisite
* eth, geth or pyethapp
* node
* npm

## Installation as docker container (optional)

There is a `Dockerfile` in the root directory of the repository. Please read through the header of said file for
instructions on how to build/run/setup. Configuration instructions below still apply.

## Configuration

Configure the app modifying [app.json](/root/app/app.json). The following environment variables are accepted :

```json
"env":
	{
		"NODE_ENV"        : "production", // tell the client we're in production environment
		"RPC_HOST"        : "localhost", // eth JSON-RPC host
		"RPC_PORT"        : "8545", // eth JSON-RPC port
		"LISTENING_PORT"  : "30303", // eth listening port (only used for display)
		"INSTANCE_NAME"   : "", // whatever you wish to name your node
		"CONTACT_DETAILS" : "", // add your contact details here if you wish (email/skype)
		"WS_SERVER"       : "wss://rpc.ethstats.net", // path to eth-netstats WebSockets api server
		"WS_SECRET"       : "see http://forum.ethereum.org/discussion/2112/how-to-add-yourself-to-the-stats-dashboard-its-not-automatic", // WebSockets api server secret used for login
		"VERBOSITY"       : 2 // Set the verbosity (0 = silent, 1 = error, warn, 2 = error, warn, info, success, 3 = all logs)
	}
```

## Run

 You can pass all the relevant parameter through docker environment variable configuration
 They will be picked up by the application:

```shellscript
 docker run \
 -e WS_SERVER=netstatsfront:3000 \
 -e WS_SECRET=20170420devchain \
 -e RPC_HOST=geth \
 -e RPC_PORT=8544 \
 -e INSTANCE_NAME=${GETH_NODE}_node \
 -e CONTACT_DETAILS= \
 -e NODE_ENV=private \
 -e LISTENING_PORT=30303 \
 -e VERBOSITY=3 \
  ethnetintel:latest
```

 Alternatively, you can mount your configured `app.json` shown in the above section into the container at
 `/root/app/app.json`, e.g. `-v /path/to/app.json:/root/app/app.json`

 > Note: if you actually want to monitor a client, you'll need to make sure it can be reached from this container.
 > The best way in my opinion is to start this container with all client '-p' port settings and then 
 > share its network with the client. This way you can redeploy the client at will and just leave 'ethnetintel' running. 

 E.g. with the python client 'pyethapp':

 ```shellscript
 docker run -d --name ethnetintel \
 -v /home/user/app.json:/root/app/app.json \
 -p 0.0.0.0:30303:30303 \
 -p 0.0.0.0:30303:30303/udp \
 ethnetintel:latest

 docker run -d --name pyethapp \
 --net=container:ethnetintel \
 -v /path/to/data:/data \
 pyethapp:latest
 ```

 If you now want to deploy a new client version, just redo the second step.


## Updating

To update the API client use the following command:

```bash
~/bin/www/bin/update.sh
```

It will stop the current netstats client processes, automatically detect your ethereum implementation and version, update it to the latest develop build, update netstats client and reload the processes.

[travis-image]: https://travis-ci.org/cubedro/eth-net-intelligence-api.svg
[travis-url]: https://travis-ci.org/cubedro/eth-net-intelligence-api
[dep-image]: https://david-dm.org/cubedro/eth-net-intelligence-api.svg
[dep-url]: https://david-dm.org/cubedro/eth-net-intelligence-api
