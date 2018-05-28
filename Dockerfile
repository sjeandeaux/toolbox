FROM debian:jessie-20180426

#CURL PYTHON PIP 
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
ARG MAVEN_VERSION=3.5.3


RUN apt-get update  &&  apt-get --yes install man sudo bash-completion iptables git tar apt-transport-https zsh \
    curl \
	python3=${PYTHON_VERSION} \
	python3-pip=${PIP3_VERSION} \
	libyaml-dev=${LIBYAML_VERSION}\
	vim=${VIM_VERSION} \
	unzip=${UNZIP_VERSION} \
	ssh=${SSH_VERSION} \
	jq=${JQ_VERSION} \
	libltdl7=${LIBLTDL7_VERSION} 

#PACKER
RUN curl -sS https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    -o /tmp/packer.zip && \
    unzip /tmp/packer.zip -d /usr/local/bin

#CHEF
RUN curl -sS https://packages.chef.io/files/stable/chefdk/${CHEF_VERSION_MAJOR}/debian/7/chefdk_${CHEF_VERSION}_amd64.deb \
    -o /tmp/chef.deb && \
    dpkg --install /tmp/chef.deb

#DOCKER
RUN curl -sS https://download.docker.com/linux/debian/dists/jessie/pool/stable/amd64/docker-ce_${DOCKER_VERSION}.deb \
    -o /tmp/docker.deb && \
    dpkg --install /tmp/docker.deb

#GO
RUN curl -sS https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz

#MAVEN
ENV MAVEN_HOME=/opt/maven
RUN curl -sS http://apache.claz.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    -o /tmp/maven.tar.gz && \
	mkdir -p /opt/maven && \
    tar --strip-components=1 -C ${MAVEN_HOME} -xzf /tmp/maven.tar.gz

COPY ./skel/* /etc/skel/

ONBUILD ARG LOGIN=bob
ONBUILD ARG BASE_DIR=/home
ONBUILD ARG GIT_NAME=UserName
ONBUILD ARG GIT_EMAIL=UserEmail
ONBUILD ARG UID=1000
ONBUILD ARG GID=50
ONBUILD ARG PASSWORD=youpi

ONBUILD RUN mkdir -p ${BASE_DIR} && useradd \
	--password $(openssl passwd -1 ${PASSWORD}) \
	--comment 'Go!!!' \
	--groups sudo,docker \
	--create-home \
	--shell /bin/bash \
	--uid ${UID} \
	--gid ${GID} \
	--base-dir ${BASE_DIR} \
	--home-dir ${BASE_DIR}/${LOGIN} \
	--skel /etc/skel \
	${LOGIN}

ONBUILD RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ONBUILD USER ${LOGIN}
ONBUILD WORKDIR /${BASE_DIR}/${LOGIN}

ONBUILD RUN git config --global user.name "${GIT_NAME}" && \
      		git config --global user.email ${GIT_EMAIL} 

#AWS
ONBUILD RUN pip3 install pyyaml awscli docker-compose --upgrade --user
ONBUILD ENV GOPATH=/${BASE_DIR}/${LOGIN}/project \
            PATH=${PATH}:/${BASE_DIR}/${LOGIN}/.local/bin:/usr/local/go/bin:/${BASE_DIR}/${LOGIN}/project/bin:${MAVEN_HOME}/bin \
			DOCKER_HOST="tcp://docker:2375"
