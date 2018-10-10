FROM rancher/hyperkube:v1.11.3-rancher1

# remove because we don't need it and it makes the build extremely slow
RUN apt-get remove --purge azure-cli

RUN apt-get -y update
RUN apt-get -y install lsb-release

# needed as long as there's no ceph mimic in stretch
RUN curl -s "https://mirror.croit.io/keys/release.asc" | apt-key add -
RUN echo deb https://mirror.croit.io/debian-mimic/ $(lsb_release -sc) main >> /etc/apt/sources.list.d/ceph-croit.list

RUN curl -s "https://download.ceph.com/keys/release.asc" | apt-key add -
RUN echo deb https://download.ceph.com/debian-mimic/ $(lsb_release -sc) main | tee /etc/apt/sources.list.d/ceph.list

RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN apt-get -y install ceph-common rbd-nbd
