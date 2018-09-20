# Use an official Python runtime as a parent image
FROM debian:jessie
#arguments

# Set the working directory to /app
WORKDIR /app

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y \
git \
build-essential \
libncurses5-dev \
bridge-utils \
net-tools \
uml-utilities


# Get 6Lbr
RUN git clone https://github.com/cetic/6lbr \
&& cd 6lbr \
&& git checkout develop \
&& git submodule update --init --recursive


#Build
WORKDIR /app/6lbr/examples/6lbr
RUN make all \
&& make plugins \
&& make tools

# Installation
RUN make install \
&& make plugins-install \
&& update-rc.d 6lbr defaults

# config file
WORKDIR /app/6lbr/Docker/settings
COPY settings/6lbr.conf /etc/6lbr/6lbr.conf
COPY settings/interfaces /etc/network/interfaces
RUN touch /etc/6lbr/nvm.dat

# Clean
RUN apt-get remove --auto-remove -y git \
build_essential
RUN rm -r /app/6lbr
