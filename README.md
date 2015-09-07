# ngrok-server for Docker

## Pre-running environmental
Run the below commands in your host machine, Replace the "example.com" with your own domain.
```
[root@hello]# NGROK_DOMAIN="example.com"
[root@hello]# openssl genrsa -out base.key 2048
Generating RSA private key, 2048 bit long modulus
..............................+++
..................+++
e is 65537 (0x10001)
[root@hello]# openssl req -new -x509 -nodes -key base.key -days 3650 -subj "/CN=$NGROK_DOMAIN" -out base.pem
[root@hello]# openssl genrsa -out server.key 2048
Generating RSA private key, 2048 bit long modulus
..+++
...................................+++
e is 65537 (0x10001)
[root@hello]# openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
[root@hello]# openssl x509 -req -in server.csr -CA base.pem -CAkey base.key -CAcreateserial -days 3650 -out server.crt
Signature ok
subject=/CN=example.com
Getting CA Private Key
```

## Running the server after pre-running environmental setup
The example TLS_CERT TLS_KEY and CA_CERT folder is /root/ngrok. Replace the "example.com" with your own domain.

```
docker run -d --net host --name myngrok-server \
    -e TLS_CERT="`awk 1 ORS='\\n' /root/ngrok/server.crt`" \
    -e TLS_KEY="`awk 1 ORS='\\n' /root/ngrok/server.key`" \
    -e CA_CERT="`awk 1 ORS='\\n' /root/ngrok/base.pem`" \
    -e DOMAIN="example.com" \
    yumin9822/ngrok-server
```
The first time it will take about 1 minute to make the ngrok server affective, because it will compile the server and client binary. You could run "netstat -ntlp" on your host manchine to check if the ngrok server are running.

## Copy the ngrok client binaries from the container
The server and client binaries are located in the folder /ngrok/bin in the docker container after you successfully run it. Use below command copy client binary to host current folder 

```
[root@hello]# docker cp <CONTAINER ID>:/ngrok/bin/ngrok ./ 
```

## Environment Variables

    TLS_CERT        TLS cert file for setting up tls connection (such as: server.crt)
    TLS_KEY         TLS key file for setting up tls connection (such as: server.key)
    CA_CERT         CA cert file for compiling ngrok (such as: base.pem)
    DOMAIN          domain name that ngrok running on 
    TUNNEL_ADDR     address that ngrok server's control channel listens to, ":4443" by default
    HTTP_ADDR       address that ngrok server's http tunnel listents to, ":8080 by default"
    HTTPS_ADDR      address that ngrok server's https tunnel listents to, ":8081 by default"


### Optional step to get all platform ngrok server and client binaries

```
docker run -it -v /tmp/bin:/ngrok/bin \
  -e CA_CERT="`awk 1 ORS='\\n' /root/ngrok/base.pem`" \
  yumin9822/ngrok-server /build_all.sh
```

Server and client binaries will be available in `/tmp/bin` on the host.
