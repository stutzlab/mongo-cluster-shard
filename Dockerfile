FROM mongo:4.2.8-bionic

RUN apt-get update && apt-get install -y netcat

ENV SHARD_REPLICA_SET ''
ENV INIT_SHARD_NODES ''

ADD /startup.sh /
ADD /config.sh /

EXPOSE 27017

CMD [ "/startup.sh" ]

