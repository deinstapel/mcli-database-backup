#!/usr/bin/env bash

# This script fetches a configmap with a comma-separated list of s3 buckets from the kubernetes api
# and runs mcli mirror for all of them

mcli config host add "local" "$LOCAL_S3_URL" "$LOCAL_ACCESS_KEY" "$LOCAL_SECRET_KEY"
mcli config host add "remote" "$REMOTE_S3_URL" "$REMOTE_ACCESS_KEY" "$REMOTE_SECRET_KEY"

TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

CAFILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
CONFIGMAP=$(curl --cacert $CAFILE -H "Authorization: Bearer $TOKEN" -H 'Accept: application/json' "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT/api/v1/namespaces/$NAMESPACE/configmaps/$BUCKET_LIST_CONFIGMAP")

declare -a failed_buckets

for bucket in $(echo $CONFIGMAP | jq -r '.data.bucketList' | sed s/\,/\\n/g)
do
    echo "----------------------------------------------------------------------------"
    SOURCE_BACKUP="local/$bucket"
    TARGET_BACKUP="remote/$REMOTE_PREFIX-$bucket-s3-backup"
    echo "Mirroring $SOURCE_BACKUP to $TARGET_BACKUP"
    mcli ls "$SOURCE_BACKUP" > /dev/null 2>&1 && echo '> Source bucket OK' || (echo '> Source bucket does not exist or no access' && failed_buckets+=($bucket) && continue)
    mcli ls "$TARGET_BACKUP" > /dev/null 2>&1 && echo '> Target bucket exists' || (mcli mb "$TARGET_BACKUP" && echo '> Target bucket created')
    mcli mirror -q "$SOURCE_BACKUP" "$TARGET_BACKUP" && echo '> Backup done' || (echo '> Backup failed, see logs above' && failed_buckets+=($bucket) && continue)
done

echo "Backup finished, ${#failed_buckets[@]} buckets failed."
echo "Failed buckets: ${failed_buckets[@]}"
