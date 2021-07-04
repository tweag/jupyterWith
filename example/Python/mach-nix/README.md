In this example we use [mach-nix](https://github.com/DavHau/mach-nix)
to load python packages from a `requirements.txt`.

Here is how it works:

1. Update the mach-nix and jupyter revision inside the shell.nix to recent versions.

1. Put your python requirements inside `requirements.txt`.

1. Enter the desired shell:
    ```
    $ nix-shell
    ```

mach-nix can be tweaked in many ways.  
For more details check its [readme](https://github.com/DavHau/mach-nix) or [examples](https://github.com/DavHau/mach-nix/blob/master/examples.md)
