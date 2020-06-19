# JupyterWith CKernel

The CKernel kernel can be used as follows:

```nix
{
  cKernel = cKernelWith {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
    # Libraries to be available to the kernel.
    packages = pkgs: with pkgs; [ libcue ];
  };
}
```
