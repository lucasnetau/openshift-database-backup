FROM lucasnetau/php-70-centos7

# This image provides backup environment for OpenShift v3 Containerised Databases
MAINTAINER James Lucas <james@lucas.net.au>

# Image metadata
ENV PERL_VERSION=5.16 \
    PATH=$PATH:/opt/rh/perl516/root/usr/local/bin

LABEL io.k8s.description="Platform for backup of databases" \
      io.k8s.display-name="Apache 2.4 with PHP + backup tools" \

# TODO: Cleanup cpanp cache after cpanminus is installed?
RUN yum install -y centos-release-scl && \
    INSTALL_PKGS="perl516 perl516-perl-Digest-SHA rh-mariadb100 rh-mariadb101 rh-postgresql95-postgresql" && \
    yum install -y --setopt=tsflags=nodocs  $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    curl -L -v -k "https://raw.githubusercontent.com/timkay/aws/master/aws" -o /tmp/aws && \
    scl enable perl516 -- perl /tmp/aws --install && \
    rm /tmp/aws

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

USER 1001
