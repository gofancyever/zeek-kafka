FROM zeek/zeek:latest

RUN apt install apt-transport-https ca-certificates
RUN apt-get -q update \
 && apt-get install -q -y --no-install-recommends \
     curl \
     bind9 \
     bison \
     ccache \
     cmake \
     flex \
     g++ \
     gcc \
     make \
     python3 \
    python3-dev \
    python3-pip \
    libssl-dev \
    libpcap-dev
RUN curl -L https://github.com/edenhill/librdkafka/archive/v1.4.4.tar.gz | tar xvz
WORKDIR /librdkafka-1.4.4/

RUN pwd

RUN ./configure --enable-sasl
RUN make
RUN make install

WORKDIR /
RUN git clone https://github.com/SeisoLLC/zeek-kafka.git
WORKDIR /zeek-kafka/
RUN ./configure --with-librdkafka=$librdkafka_root
RUN make
RUN make install
RUN ldconfig
RUN zkg autoconfig --force


RUN zeek -N Seiso::Kafka
