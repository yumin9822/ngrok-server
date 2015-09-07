FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y build-essential wget golang mercurial git

RUN wget -qO- https://github.com/inconshreveable/ngrok/releases | grep tar.gz| awk -F "\"" '{print $2;exit}' |wget -i - -B https://github.com -O /ngrok.tar.gz
RUN tar zxvf /ngrok.tar.gz; rm /ngrok.tar.gz; mv /ngrok-* /ngrok

ADD *.sh /; chmod a+x /*.sh

ENV TLS_KEY **None**
ENV TLS_CERT **None**
ENV CA_CERT **None**
ENV DOMAIN **None**
ENV TUNNEL_ADDR :4443
ENV HTTP_ADDR :8080
ENV HTTPS_ADDR :8081

VOLUME ["/ngrok/bin"]

CMD ["/run-server.sh"]
