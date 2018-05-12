FROM debian:jessie-20180426

#CURL PYTHON PIP 
ARG CURL_VERSION=7.38.0-4+deb8u10
ARG PYTHON_VERSION=3.4.2-2
ARG PIP3_VERSION=1.5.6-5
ARG VIM_VERSION=2:7.4.488-7+deb8u3
ARG UNZIP_VERSION=6.0-16+deb8u3
ARG LIBYAML_VERSION=0.1.6-3
ARG SSH_VERSION=1:6.7p1-5+deb8u4
ARG JQ_VERSION=1.4-2.1+deb8u1
#LIBLTDL7 and iptables for docker
ARG LIBLTDL7_VERSION=2.4.2-1.11+b1
ARG PACKER_VERSION=1.2.3
ARG CHEF_VERSION_MAJOR=2.5.3
ARG CHEF_VERSION=${CHEF_VERSION_MAJOR}-1
ARG DOCKER_VERSION=18.03.1~ce-0~debian_amd64
ARG GO_VERSION=1.10.2

RUN apt-get update; apt-get --yes install man sudo bash-completion iptables git tar \
    curl=${CURL_VERSION} \
	python3=${PYTHON_VERSION} \
	python3-pip=${PIP3_VERSION} \
	libyaml-dev=${LIBYAML_VERSION}\
	vim=${VIM_VERSION} \
	unzip=${UNZIP_VERSION} \
	ssh=${SSH_VERSION} \
	jq=${JQ_VERSION} \
	libltdl7=${LIBLTDL7_VERSION}

#PACKER
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip /tmp/packer.zip
RUN unzip /tmp/packer.zip -d /usr/local/bin

#CHEF
ADD https://packages.chef.io/files/stable/chefdk/${CHEF_VERSION_MAJOR}/debian/7/chefdk_${CHEF_VERSION}_amd64.deb /tmp/chef.deb
RUN dpkg --install /tmp/chef.deb

#DOCKER
ADD https://download.docker.com/linux/debian/dists/jessie/pool/stable/amd64/docker-ce_${DOCKER_VERSION}.deb /tmp/docker.deb
RUN dpkg --install /tmp/docker.deb

#GO
ADD https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz /tmp/go.tar.gz
RUN tar -C /usr/local -xzf /tmp/go.tar.gz

ONBUILD ARG LOGIN=bob
ONBUILD ARG UID=1000
ONBUILD ARG GID=50
ONBUILD ARG PASSWORD=youpi

ONBUILD RUN useradd \
	--password $(openssl passwd -1 ${PASSWORD}) \
	--comment 'Go!!!' \
	--groups sudo,docker \
	--create-home \
	--shell /bin/bash \
	--uid ${UID} \
	--gid ${GID} \
	--home-dir /home/${LOGIN} \
	${LOGIN}

ONBUILD USER ${LOGIN}
ONBUILD WORKDIR /home/${LOGIN}

#AWS
ONBUILD RUN pip3 install pyyaml awscli docker-compose --upgrade --user
ONBUILD ENV GOPATH=/home/${LOGIN}/project \
            PATH=${PATH}:/home/${LOGIN}/.local/bin:/usr/local/go/bin:/home/${LOGIN}/project/bin \
			DOCKER_HOST="tcp://docker:2375"