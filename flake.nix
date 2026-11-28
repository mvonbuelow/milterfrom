{
  description = "MilterFrom - Postfix envelope/header sender validation milter";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      pkgsFor = forAllSystems (system:
        import nixpkgs { inherit system; }
      );
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          milterfrom = pkgs.stdenv.mkDerivation {
            pname = "milterfrom";
            version = if self ? rev then self.rev else "dev";

            src = self;

            nativeBuildInputs = with pkgs; [
              cmake
              pkg-config
            ];

            buildInputs = with pkgs; [
              libmilter
            ];

            meta = with pkgs.lib; {
              description = "Postfix milter checking envelope and header sender consistency";
              homepage = "https://github.com/mvonbuelow/milterfrom";
              license = licenses.bsd3;
              platforms = platforms.linux;
              mainProgram = "milterfrom";
            };
          };

          default = pkgs.milterfrom;
        }
      );

      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cmake
              gnumake
              gcc
              libmilter
              systemd
              pkg-config
            ];
          };
        }
      );
    };
}
