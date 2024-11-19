FROM alpine:3.18
ARG DEFAULT_PG_VERSION=12
ARG INFLUXDB_VERSION=1.11.7
ARG INFLUXDB_SHA256="00c85ff0abbfbc165663ac5feae7e4e36b6d13c9c003e7a400edd013b356da08"

RUN apk add --no-cache ca-certificates
RUN apk add --no-cache --virtual .build-deps curl && curl https://dl.min.io/client/mc/release/linux-amd64/mc > /usr/bin/mc && chmod +x /usr/bin/mc && apk del .build-deps
RUN apk add --no-cache \
  postgresql12-client \
  postgresql13-client \
  postgresql14-client \
  postgresql15-client
RUN pg_versions set-default ${DEFAULT_PG_VERSION}
RUN apk add --no-cache mysql-client bash tar curl jq
WORKDIR /tmp
RUN curl -SsfL https://download.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-linux-amd64.tar.gz -o influxdb.tar.gz \
  && test "$(sha256sum influxdb.tar.gz | awk 'NR==1{print $1}')" = "${INFLUXDB_SHA256}" \
  && tar -xf influxdb.tar.gz \
  && mkdir -p /etc/influxdb \
  && mv influxdb.conf /etc/influxdb \
  && mv influx* /usr/local/bin \
  && rm -f influxdb.tar.gz
ENV INFLUXDB_CONFIG_PATH="/etc/influxdb/influxdb.conf"
WORKDIR /
ADD s3_to_s3.sh /usr/bin/s3_to_s3.sh
RUN chmod +x /usr/bin/s3_to_s3.sh
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
