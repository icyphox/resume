{
  description = "site";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs =
    { self
    , nixpkgs
    ,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.tectonic
            ];
          };
        }
      );

      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = {
            type = "app";
            program = "${pkgs.writeShellScriptBin "s3-sync" ''
                #!/usr/bin/env bash
                ${pkgs.awscli2}/bin/aws s3 cp resume.pdf s3://files/resume.pdf
            ''}/bin/s3-sync";
          };
        }
      );
    };
}
