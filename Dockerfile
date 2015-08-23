# FROM perl:latest
# somehow official perl hangs
FROM zakame/perl:5.14

MAINTAINER eric.yongjun.choi@gmail.com

RUN curl -L http://cpanmin.us | perl - Dancer2
RUN curl -L http://cpanmin.us | perl - DBD::SQLite

COPY . /usr/src/evie
WORKDIR /usr/src/evie

EXPOSE 3000
CMD [ "perl", "./evie.pl" ]
