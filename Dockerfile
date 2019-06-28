FROM minio/mc

RUN apk add postgresql-client mysql-client bash tar influxdb

ENTRYPOINT ["/bin/bash"]