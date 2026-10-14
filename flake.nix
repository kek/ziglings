
{
  description = "Dev shell for Zig";

  inputs = {
    nixpkgs.url = "nixpkgs";
    zig.url = "github:silversquirl/zig-flake/compat";
    zls.url = "github:zigtools/zls";

    zig.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.zig-overlay.follows = "zig";
  };

  outputs = {
    nixpkgs,
    zig,
    zls,
    ...
  }: let
    forAllSystems = f: builtins.mapAttrs f nixpkgs.legacyPackages;
  in {
    devShells = forAllSystems (system: pkgs: {
      default = pkgs.mkShellNoCC {
        name = "ziglings";
        packages = [
          pkgs.fish
          pkgs.watchexec
          zig.packages.${system}.nightly
          zls.packages.${system}.zls
        ];
      };
      shellHook = ''
      echo "Zig dev shell — zig $(zig --version)"
      '';

    });
  };
}

