# mcli-database-backup

This is the `minio/mc` image with some additional database clients, which we need for backups.

1. Create a configuration for your bucket. `mcli config host add deinstapel $S3_ENDPOINT $ACCESS_KEY $SECRET_KEY --api "s3v4"`
2. Create a backup from your database and pipe it into your bucket. `pg_dump -U username -d database | mcli pipe deinstapel/bucket/folder/filename.sql`

## S3 to S3 mirroring

- Use s3_to_s3.sh as entrypoint
- Mount a service account with permissions to read configmaps in the namespace into your pod
- Populate environment for local and remote s3
  - `LOCAL_S3_URL` - Local S3 server address
  - `LOCAL_ACCESS_KEY` - Local S3 access key
  - `LOCAL_SECRET_KEY` - Local S3 secret key
  - vice versa for `REMOTE`
  - `REMOTE_PREFIX` - Prefix for the remote backups bucket names.
- This will e.g. copy from `local/bucket` to `remote/prefix-bucket-s3-backup`

## Postgresql backup

For running postgresql backup, the used postgresql client version must match the server version. This image currently contains postgresql clients 12-15 (default=12).

To change the postgresql client version, set the environment variable `DEFAULT_PG_VERSION` accordingly when running this image.
