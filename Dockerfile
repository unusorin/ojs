FROM ubuntu:14.04
MAINTAINER Sorin Badea <sorin.badea91@gmail.com>
RUN apt-get update
RUN apt-get install php5 php5-mysql php5-curl  -y

ADD bin /docker/bin
RUN bash /docker/bin/install-composer.sh

ADD . /opt/ojs
RUN bash /docker/bin/provision.sh

WORKDIR /opt/ojs
RUN mkdir /opt/files; apt-get install gettext-base -y
CMD ["/docker/bin/boot.sh"]
