# this flake installs all tools required for the dev env
{
  description = "mydumper";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  inputs.nur.url = "github:nix-community/NUR";

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , nur
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      assertVersion = version: pkg: (
        assert (pkgs.lib.assertMsg (builtins.toString pkg.version == version) ''
          Expecting version of ${pkg.name} to be ${version} but got ${pkg.version};
        '');
        pkg
      );
      pkgs = import nixpkgs
        {
          system = system;
          overlays = [ nur.overlay ];
        };
    in
    {
      formatter = pkgs.nixpkgs-fmt;
      devShells.default = pkgs.mkShell {
        packages = [
          (assertVersion "0.16.3-6" pkgs.nur.repos.michaelglass.mydumper)
        ];
      };
    });
}
