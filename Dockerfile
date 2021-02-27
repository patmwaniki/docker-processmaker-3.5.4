# Base Image
#FROM centos:7
FROM amazonlinux:2018.03
CMD ["/bin/bash"]

# Maintainer
#MAINTAINER Jaja <jaelsonrc@ymail.com>

# Extra
LABEL version="3.5.4"
LABEL description="ProcessMaker 3.5.4 Docker Container - Apache & PHP 7.1"

# Initial steps
RUN yum clean all && yum install epel-release -y && yum update -y
RUN cp /etc/hosts ~/hosts.new && sed -i "/127.0.0.1/c\127.0.0.1 localhost localhost.localdomain `hostname`" ~/hosts.new && cp -f ~/hosts.new /etc/hosts
RUN yum install yum-utils -y

#RUN yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y

#RUN yum-config-manager --enable remi-php71
RUN yum install \
  wget \
  nano \
  vim \
  sendmail \
  php71 \
  php71-opcache \
  php71-gd \
  php71-mysqlnd \
  php71-soap \
  php71-mbstring \
  php71-ldap \
  php71-mcrypt \
  -y

COPY php.ini /etc/php.ini

# Download processmaker-3.5.4-community
RUN wget -O "/tmp/processmaker-3.5.4-community.tar.gz" \
      "https://tenet.dl.sourceforge.net/project/processmaker/ProcessMaker/3.5.4/processmaker-3.5.4-community.tar.gz"
# Copy configuration files
COPY pmos.conf /etc/httpd/conf.d
RUN mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bk
COPY httpd.conf /etc/httpd/conf

# Apache Ports
EXPOSE 80

# Docker entrypoint
COPY docker-entrypoint.sh /bin/
RUN chmod a+x /bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]