{ pkgs }: {
  script = pkgs.writeShellScriptBin "show-iommu.sh"
    (builtins.readFile ./show-iommu.sh);
}
