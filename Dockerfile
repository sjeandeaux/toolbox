FROM debian:jessie-20180426

ARG LOGIN=bob
ARG UID=1000
ARG GID=50
ARG PASSWORD=youpi

#CURL PYTHON PIP 
ARG CURL_VERSION=7.38.0-4+deb8u10
ARG PYTHON_VERSION=3.4.2-2
ARG PIP3_VERSION=1.5.6-5
ARG VIM_VERSION=2:7.4.488-7+deb8u3
ARG UNZIP_VERSION=6.0-16+deb8u3
ARG LIBYAML_VERSION=0.1.6-3
ARG SSH_VERSION=1:6.7p1-5+deb8u4
ARG JQ_VERSION=1.4-2.1+deb8u1
ARG PACKER_VERSION=1.2.3
ARG CHEF_VERSION_MAJOR=2.5.3
ARG CHEF_VERSION=${CHEF_VERSION_MAJOR}-1

RUN apt-get update; apt-get --yes install man sudo \
    curl=${CURL_VERSION} \
	python3=${PYTHON_VERSION} \
	python3-pip=${PIP3_VERSION} \
	libyaml-dev=${LIBYAML_VERSION}\
	vim=${VIM_VERSION} \
	unzip=${UNZIP_VERSION} \
	ssh=${SSH_VERSION} \
	jq=${JQ_VERSION}

#PACKER
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip /tmp/packer.zip
RUN unzip /tmp/packer.zip -d /usr/local/bin

#CHEF
ADD https://packages.chef.io/files/stable/chefdk/${CHEF_VERSION_MAJOR}/debian/7/chefdk_${CHEF_VERSION}_amd64.deb /tmp/chef.deb
RUN dpkg --install /tmp/chef.deb

RUN useradd --password $(openssl passwd -1 ${PASSWORD}) --comment 'Go!!!' --groups sudo --create-home --shell /bin/bash --uid ${UID} --gid ${GID} --home-dir /home/${LOGIN} ${LOGIN}

USER ${LOGIN}
WORKDIR /home/${LOGIN}

#AWS
RUN pip3 install pyyaml awscli --upgrade --user
ENV PATH=~/.local/bin:$PATH