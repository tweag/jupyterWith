#!/usr/bin/env sh

export PGDATA=.tmp/testdb

initdb
pg_ctl -l server.log start
createdb
