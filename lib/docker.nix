{ pkgs }:

{
  mkDockerImage = { name ? "jupyterwith", jupyterlab }:
    pkgs.dockerTools.buildImage {
      inherit name;
      tag = "latest";
      created = "now";
      contents = [ jupyterlab pkgs.glibcLocales ];
      config = {
        Env = [
          "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
          "LANG=en_US.UTF-8"
          "LANGUAGE=en_US:en"
          "LC_ALL=en_US.UTF-8"
        ];
        CMD = [ "/bin/jupyter-lab" "--ip=0.0.0.0" "--no-browser" "--allow-root" ];
        WorkingDir = "/data";
        ExposedPorts = {
          "8888" = { };
        };
        Volumes = {
          "/data" = { };
        };
      };
    };
}
