# Running this example

There's a bit of setup to make the PostgreSQL server work which is contained in `setup.sh`.

```bash
nix-shell
./setup.sh
jupyter lab
```

Once you're done you can shut down the server with

```bash
pg_ctl -D .tmp/testdb stop
```
