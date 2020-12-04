final: prev:
{
  cppzmq = prev.cppzmq.overrideAttrs (o: {
    src = prev.fetchFromGitHub {
      owner = "zeromq";
      repo = "cppzmq";
      rev = "76bf169fd67b8e99c1b0e6490029d9cd5ef97666";
      sha256 = "sha256-VSTD/8gHKi+L9Eb2C6SdV99FzWaCxXycussOkfYdiwI=";
    };
  });
}
