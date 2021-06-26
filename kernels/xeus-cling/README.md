# JupyterWith Xeus Cling C++ Kernel

The `xeus-cling` kernel can be used as follows:

```nix
{
  kernel = xeusCling {
    # The flag can be set to c++11 14 17;
    extraFlag = "c++17";
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
  };
}
```
