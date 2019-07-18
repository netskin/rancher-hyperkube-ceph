FROM netskin/hyperkube-amd64:v1.11.5

RUN clean-install lsb-release apt-transport-https curl gnupg1

# needed as long as there's no ceph mimic in stretch
RUN curl -s "https://mirror.croit.io/keys/release.asc" | apt-key add -
RUN echo deb https://mirror.croit.io/debian-mimic/ $(lsb_release -sc) main >> /etc/apt/sources.list.d/ceph-croit.list

RUN curl -s "https://download.ceph.com/keys/release.asc" | apt-key add -
RUN echo deb https://download.ceph.com/debian-mimic/ $(lsb_release -sc) main | tee /etc/apt/sources.list.d/ceph.list

RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN clean-install rbd-nbd

# these empty files are needed so ceph is not emitting warnings (which break the parsing in k8s)
RUN touch /etc/ceph/ceph.conf
RUN touch /etc/ceph/ceph.keyring

COPY /docker/rbd-wrapper /usr/local/bin/rbd
