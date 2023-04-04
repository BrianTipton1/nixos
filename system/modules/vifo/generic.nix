inputs: pci-ids: user: gpu-type: cpu-type:
{ lib, ... }:
with lib; {

  # Add options for whether to build mesa GPU drivers from master git branch
  kernelModules = boot.initrd.kernelModules
    ++ [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
  kernelParams = boot.kernelParams ++ [ "vfio-pci.ids=${pci-ids}" ];

  ## Possibly Needed because memory page limit errors when using vfio
  loginLimits = [
    {
      domain = user;
      item = "memlock";
      type = "hard";
      value = "unlimited";
    }
    {

      domain = user;
      item = "memlock";
      type = "soft";
      value = "unlimited";
    }
  ];
}
