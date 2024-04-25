{
  description = "zzz script";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        my-name = "zzz";
        my-buildInputs = with pkgs; [ cowsay ddate ];
        zzz = (pkgs.writeScriptBin my-name (builtins.readFile ./script.sh)).overrideAttrs(old: {
          buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
      in rec {
        defaultPackage = packages.zzz;
        packages.zzz = pkgs.symlinkJoin {
          name = my-name;
          paths = [ zzz ] ++ my-buildInputs;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
        };
      }
    );
}

