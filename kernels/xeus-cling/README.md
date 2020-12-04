# JupyterWith Xeus Cling C++ Kernel

The `xeus-cling` kernel can be used as follows:

```nix
{
  kernel = xeusCling {
    ## the flag can be set to c++11 or 14 17.
    extraFlag = "c++17"
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
  };
}
```
