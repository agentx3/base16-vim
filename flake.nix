{
  description = "Base-16 theme for the fish shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        base16-builder-go =
          { buildGoModule
          , lib
          , fetchFromGitHub
          }:
          buildGoModule rec {
            pname = "base16-builder-go";
            version = "0.3.0";

            src = fetchFromGitHub {
              owner = "tinted-theming";
              repo = "base16-builder-go";
              rev = "v${version}";
              sha256 = "sha256-096l9RLmT7es2Y9fLKFLeKAYhkT8FcE5u2RYu3bZIoA=";
            };
            vendorHash = "sha256-fqnGU86L4tEQhujv2opsQs3mQIvp3m2zjfAQ9yfpyOk=";
            meta = with lib; {
              description = "A Go implementation of the base16-builder tool.";
              license = licenses.mit;
            };
          };
      in
      {
        # Usage:
        # `nix develop` to enter a shell with base16-builder-go available
        # Then just run base16-builder-go to generate the themes
        devShells.default = pkgs.mkShell {
          buildInputs = [ (pkgs.callPackage base16-builder-go { }) ];
        };
      }
    );
}
