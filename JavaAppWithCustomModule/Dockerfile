FROM centos:6.7
MAINTAINER Zeshan <xeshan.ahmed@gmail.com>

ARG JAVA_VERSION=1.8.0_112
ARG UPDATE_VERSION=8u112
ARG BUILD=b15
ARG GOSU_VERSION=1.9

ENV CERT_CLIENT_STOREPASS="changeit"
RUN yum install -y gpg
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm -fr /usr/local/bin/gosu.asc \
    && rm -fr /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

RUN yum install -y wget tar cronie ganglia-gmond util-linux-ng which  && \
    yum install -y mx && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}-${BUILD}/jdk-${UPDATE_VERSION}-linux-x64.rpm \
      --output-document="jdk-${UPDATE_VERSION}-linux-x64.rpm" && \
    rpm -i jdk-${UPDATE_VERSION}-linux-x64.rpm && \
    alternatives --install /usr/bin/java java /usr/java/jdk${JAVA_VERSION}/bin/java 1 && \
    alternatives --set java /usr/java/jdk${JAVA_VERSION}/bin/java && \
    echo "export JAVA_HOME=/usr/java/jdk${JAVA_VERSION}/" | tee /etc/environment && \
    ln -s /usr/java/jdk${JAVA_VERSION} /usr/java/jdk && \
    source /etc/environment && \
    rm -fr jdk-${UPDATE_VERSION}-linux-x64.rpm \
    yum clean all

RUN echo "export JAVA_HOME=/usr/java/jdk${JAVA_VERSION}" >> ~/.bashrc

COPY /docker_bin/packages /tmp/packages

RUN rpm -Uvh /tmp/packages/*.rpm

RUN mkdir -p /var/log/ems && \
    mkdir -p /var/tmp && \
    mkdir -p /var/log/oom && \
    mkdir -p /ems/var/spool && \
    mkdir -p /ems/shared && \
    mkdir -p /ems/sysconf && \
    mkdir -p /ems/archive && \


RUN ln -s /opt/ems/lib/jcharset.jar /usr/java/jdk/jre/lib/ext/jcharset.jar
COPY /docker_bin/res/import_certificate.sh /opt/ems/share/
RUN chmod 755 /opt/ems/share/*.sh

#Copy ems files to valid directories
COPY /docker_bin/res/conf/discovery.properties /opt/ems/conf
COPY /docker_bin/res/conf/product.version /opt/ems/conf/wfe
COPY /docker_bin/res/conf/rabbitmq-monitor-context.xml /opt/ems/conf
COPY /docker_bin/res/conf/update_unassigned_reconstitute.jy /opt/ems/admin/service
COPY /docker_bin/res/conf/rabbitmq-monitor-context.xml /opt/ems/conf
COPY /docker_bin/res/conf/partition_headroom.py /opt/ems/admin/service
COPY /docker_bin/res/conf/index_sla_maintenance.jy /opt/ems/admin/service
COPY /docker_bin/res/conf/fixSearchDuplicates.jy /opt/ems/admin/service
COPY /docker_bin/res/conf/purgePreCalc.cfg /opt/ems/purge
COPY /docker_bin/res/conf/run_fault_notifier.sh /opt/ems/bin
COPY /docker_bin/res/conf/policy_stats* /opt/ems/bin
COPY /docker_bin/res/conf/wfe /opt/ems/conf/wfe
COPY files/resources/overlays /opt/ems/conf/wfe
COPY files/resources/stopwords /opt/ems/conf/wfe
COPY files/resources/scripts/send-measurement /usr/local/bin/

RUN chmod 755 /usr/local/bin/send-measurement

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

#Copy s6 services
COPY files/services /etc/services.d

#COPY bootstrap.sh /bootstrap.sh

#RUN chmod 755 /bootstrap.sh

#ENTRYPOINT ["/init"]

#CMD ["/bootstrap.sh"]
