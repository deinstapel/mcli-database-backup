FROM alpine:3.11

RUN apk add --no-cache ca-certificates
RUN apk add --no-cache --virtual .build-deps curl && curl https://dl.min.io/client/mc/release/linux-amd64/mc > /usr/bin/mc && chmod +x /usr/bin/mc && apk del .build-deps
RUN apk add --no-cache postgresql-client mysql-client bash tar influxdb curl jq
ADD s3_to_s3.sh /usr/bin/s3_to_s3.sh
RUN chmod +x /usr/bin/s3_to_s3.sh

ENTRYPOINT ["/bin/bash"]
