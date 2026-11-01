{
  description = "QMK firmware development environment";

  inputs = {
    # Pinned to 22.05 to match the age of this firmware: newer qmk CLI
    # releases drop the appdirs dependency the firmware's python lib needs,
    # and newer avr-gcc versions fail to build older QMK code
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "qmk-firmware";

          # The qmk package brings the qmk CLI along with the AVR/ARM
          # toolchains and flashing utilities it depends on
          packages = with pkgs; [
            qmk
            clang-tools
            gnumake
            git
          ];

          shellHook = ''
            # Prevent the avr-gcc wrapper from picking up host GCC flags
            unset NIX_CFLAGS_COMPILE_FOR_TARGET
            export QMK_HOME="$PWD"
          '';
        };
      });
}
