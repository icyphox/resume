{
  description = "Tools to build my résumé";

  outputs = { self, nixpkgs }: {
    devShell.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgs.mkShell {
        src = null;
        nativeBuildInputs = with pkgs; [
            tectonic
        ];
      };
  };
}
