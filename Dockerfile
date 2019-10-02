FROM minio/mc

RUN apk add postgresql-client mysql-client bash tar influxdb curl jq
ADD s3_to_s3.sh /usr/bin/s3_to_s3.sh
RUN chmod +x /usr/bin/s3_to_s3.sh

ENTRYPOINT ["/bin/bash"]