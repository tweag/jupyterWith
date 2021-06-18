let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/a5d03577f0161c8a6e713b928ca44d9b3feb2c37.tar.gz";
    sha256 = "16zm06arcwkkp8yw37gr365msvgb1yyqrpy7lan4l85l6ids1jjh";
  };
in
  import src
