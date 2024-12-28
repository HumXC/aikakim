{ pkgs, ... }: {
  default = pkgs.mkShell {
    buildInputs =
      (with pkgs;[
        # Build-Tools
        lldb
        pkg-config
        vala
        vala-lint
        meson
        mesonlsp
        ninja
        vala-language-server
        uncrustify
        blueprint-compiler
        sass

        # Dependencies
        gtk4
        gtk4-layer-shell
        librsvg
      ]);
    shellHook = ''
      echo "${pkgs.lldb}/bin/lldb-dap"
      echo "${pkgs.wayland-protocols}"
    '';
  };
}
