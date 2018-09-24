FROM ubuntu:16.04

RUN set -x\
 && groupadd --gid 1000 mona\
 && useradd -m -u 1000 -g mona mona\
 && mkdir /data\
 && chown mona:mona /data

RUN mkdir /tmp/build
RUN set -x\
 && apt-get update \
 && apt-get install -y\
      build-essential\
      libtool\
      autotools-dev\
      automake\
      pkg-config\
      libssl-dev\
      libevent-dev\
      bsdmainutils\
      libboost-system-dev\
      libboost-filesystem-dev\
      libboost-chrono-dev\
      libboost-program-options-dev\
      libboost-test-dev\
      libboost-thread-dev\
      libminiupnpc-dev\
      libzmq3-dev\
      wget\
 && mkdir -p /tmp/build \
 && cd /tmp/build \
 && wget https://github.com/monacoinproject/monacoin/archive/monacoin-0.16.3.tar.gz \
 && tar xf monacoin-0.16.3.tar.gz \
 && cd monacoin-monacoin-0.16.3 \
 && ./autogen.sh \
 && ./configure --prefix=/usr --enable-hardening --disable-wallet --without-gui \
 && make install \
 && cd / \
 && rm -rf /tmp/build \
 && apt-get remove -y wget

USER mona
RUN mkdir /home/mona/.monacoin
COPY monacoin.conf /home/mona/.monacoin/monacoin.conf

VOLUME /data

ENV RPCUSER mona
ENV RPCPASSWORD mona
ENV RPCALLOWIP "172.0.0.0/8"

EXPOSE 9401 9402 29000

WORKDIR /mona
CMD /usr/bin/monacoind --rpcuser=$RPCUSER --rpcpassword=$RPCPASSWORD --rpcallowip=$RPCALLOWIP
