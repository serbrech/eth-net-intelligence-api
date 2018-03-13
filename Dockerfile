## Build via:
#
# `docker build -t ethnetintel:latest .`
#
# You can pass all the relevant parameter through environment configuration
# They will be picked up by the application. 
# Run via:
#
# `docker run \
# -e WS_SERVER=netstatsfront:3000 \
# -e WS_SECRET=20170420devchain \
# -e RPC_HOST=geth \
# -e RPC_PORT=8544 \
# -e INSTANCE_NAME=${GETH_NODE}_node \
# -e CONTACT_DETAILS= \
# -e NODE_ENV=private \
# -e LISTENING_PORT=30303 \
# -e VERBOSITY=3 \
#  ethnetintel:latest`
#
# Alternatively, you can mount your configured 'app.json' into the container at
## '/root/app/app.json', e.g.
## '-v /path/to/app.json:/root/app/app.json'
## 
## Note: if you actually want to monitor a client, you'll need to make sure it can be reached from this container.
##       The best way in my opinion is to start this container with all client '-p' port settings and then 
#        share its network with the client. This way you can redeploy the client at will and just leave 'ethnetintel' running. E.g. with
##       the python client 'pyethapp':
##
#
# `docker run -d --name ethnetintel \
# -v /home/user/app.json:/root/app/app.json \
# -p 0.0.0.0:30303:30303 \
# -p 0.0.0.0:30303:30303/udp \
# ethnetintel:latest`
#
# `docker run -d --name pyethapp \
# --net=container:ethnetintel \
# -v /path/to/data:/data \
# pyethapp:latest`
#
## If you now want to deploy a new client version, just redo the second step.

#-- stage 1
FROM node

COPY ./package.json /home/ethnetintel/eth-net-intelligence-api/package.json

WORKDIR /home/ethnetintel/eth-net-intelligence-api

RUN npm set strict-ssl false &&\
    npm install

COPY . /home/ethnetintel/eth-net-intelligence-api

#--- stage 2 --

FROM keymetrics/pm2:latest-alpine  
WORKDIR /root/app

COPY --from=0 /home/ethnetintel/eth-net-intelligence-api /root/app
ENTRYPOINT ["pm2-docker", "start", "/root/app/app.json"]

