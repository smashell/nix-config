self: super: {
  # 利用你在 flake.nix 中定义的 inputs
  # 在 nix-darwin 和 NixOS 中，通过 specialArgs 传递的 inputs 
  # 通常可以从 super.inputs 或 self.inputs 中获取
  claude-code = super.inputs.claude-code.packages.${super.stdenv.hostPlatform.system}.default;
  
  # 如果你想使用启动更快的 bun 版本，也可以加上这个：
  # claude-code-bun = super.inputs.claude-code.packages.${super.stdenv.hostPlatform.system}.claude-code-bun;
}
