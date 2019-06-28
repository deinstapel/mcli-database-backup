# mc-database-backup

This is the `minio/mc` image with some additional database clients, which we need for backups.

1. Create a configuration for your bucket. `mcli config host add deinstapel https://backups.deinstapel.de $ACCESS_KEY $SECRET_KEY --api "s3v4"`
2. Create a backup from your database and pipe it into your bucket. `pg_dump -U username -d database | mcli pipe deinstapel/bucket/folder/filename.sql`