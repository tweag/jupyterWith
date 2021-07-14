{ stdenv
, python3
, name ? "nixpkgs"
}:
let
  kernelEnv =
    (python3.withPackages
      (p: [ p.ansible-kernel p.ansible ])
    ).override (args: { ignoreCollisions = true; });

  kernelFile = {
    argv = [
      "${kernelEnv.interpreter}"
      "-m"
      "ansible_kernel"
      "-f"
      "{connection_file}"
    ];
    codemirror_mode = "yaml";
    display_name = "Ansible - " + name;
    language = "ansible";
    logo64 = "logo-64x64.svg";
  };

  ansibleKernel = stdenv.mkDerivation {
    name = "ansible-kernel";
    phases = "installPhase";
    src = ./ansible.png;
    buildInputs = [ ];
    installPhase = ''
      mkdir -p $out/kernels/ansible_${name}
      cp $src $out/kernels/ansible_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ansible_${name}/kernel.json
    '';
  };
in
{
  spec = ansibleKernel;
  runtimePackages = [ python3.pkgs.ansible ];
}
