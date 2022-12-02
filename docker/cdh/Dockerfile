FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && \
apt-get install -y python-pip openjdk-8-jre-headless \
libsasl2-2 libsasl2-modules libsasl2-modules-gssapi-mit \
sudo netcat-openbsd less curl wget iproute2 vim iputils-ping \
tzdata liblzo2-2 krb5-user && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

USER root
ARG CONTEXT_DIR
ADD ${CONTEXT_DIR} /opt/

ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_HOME=/opt/hive
ENV HBASE_HOME=/opt/hbase
ENV SENTRY_HOME=/opt/sentry
ENV RANGER_HOME=/opt/ranger
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/conf

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
ENV PATH="${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${HIVE_HOME}/bin:${HBASE_HOME}/bin:${SENTRY_HOME}/bin:${RANGER_HOME}/bin"
WORKDIR /opt/hadoop
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]