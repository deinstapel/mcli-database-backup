FROM minio/mc

RUN apk add postgresql-client mysql-client bash

ENTRYPOINT ["/bin/bash"]