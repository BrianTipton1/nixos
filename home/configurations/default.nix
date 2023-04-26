{ self, ... }@inputs: {
  "brian@nyx" = self.lib.mkHome "brian" "nyx" "x86_64-linux";
  "brian@mac" = self.lib.mkHome "brian" "mac" "aarch64-darwin";
}
