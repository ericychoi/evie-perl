FROM perl:5.20

MAINTAINER eric.yongjun.choi@gmail.com

RUN curl -L http://cpanmin.us | perl - Dancer2

COPY . /usr/src/evie
WORKDIR /usr/src/evie

EXPOSE 3000
CMD [ "perl", "./evie.pl" ]
