FROM mongo:4.4.0-bionic

RUN apt-get update && apt-get install -y netcat inetutils-ping

ENV SHARD_REPLICA_SET ''
ENV INIT_SHARD_NODES ''

ADD /startup.sh /
ADD /health.sh /
ADD /config.sh /

HEALTHCHECK CMD [ "/health.sh" ]

VOLUME [ "/data" ]

EXPOSE 27017

CMD [ "/startup.sh" ]

