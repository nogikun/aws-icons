{
  description = "Odekake development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          # 全OS共通で必要なツール
          buildInputs = [
            pkgs.mise      # ランタイム管理（Node / Python 等）
            pkgs.direnv    # 環境自動切り替え
            pkgs.go-task   # タスクランナー（Taskfile.yml）
          ];

          # Nix の shellHook は Bash で評価される。
          shellHook = ''
            eval "$(mise activate bash)"
          '';
        };
      });
}
