{ self, ... }@inputs: {
  "brian@nyx" = self.lib.mkHome "brian" "nyx" "x86_64-linux";
}
