#!/bin/sh

if test -n "${DEFAULT_PG_VERSION}"; then
  pg_versions set-default "${DEFAULT_PG_VERSION}"
fi

if [ -z "$1" ]; then
  exec /bin/bash
else
  exec "$@"
fi
