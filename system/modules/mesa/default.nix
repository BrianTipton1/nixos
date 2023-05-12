inputs:
{ config, lib, pkgs, ... }:

with lib; {
  options.mesa.enable = lib.mkEnableOption "mesa";
  options.mesa.git.enable = lib.mkEnableOption "mesa git";

  config = mkMerge [
    (mkIf (config.mesa.git.enable) {

      hardware.opengl = let
        attrs = oa: {
          name = "mesa-git";
          src = inputs.mesa-git;
          nativeBuildInputs = oa.nativeBuildInputs ++ [ pkgs.glslang ];
          mesonFlags = oa.mesonFlags
            ++ [ "-Dvulkan-layers=device-select,overlay" ];
          postInstall = oa.postInstall + ''
            # #Device Select layer
            # layer=VkLayer_MESA_device_select
            # substituteInPlace $drivers/share/vulkan/implicit_layer.d/''${layer}.json \
            #   --replace "lib''${layer}" "$drivers/lib/lib''${layer}"
            #
            # #Overlay layer
            # layer=VkLayer_MESA_overlay
            # substituteInPlace $drivers/share/vulkan/explicit_layer.d/''${layer}.json \
            #   --replace "lib''${layer}" "$drivers/lib/lib''${layer}"
          '';
        };
      in with pkgs; {
        enable = true;
        driSupport = true;
        package = (mesa.overrideAttrs attrs).drivers;
        extraPackages = with pkgs; [ amdvlk ];

        driSupport32Bit = true;
        extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
        package32 = (pkgsi686Linux.mesa.overrideAttrs attrs).drivers;
      };
    })

    (mkIf (config.mesa.enable && !config.mesa.git.enable) {
      hardware.opengl.enable = true;
      hardware.opengl.driSupport = true;
      hardware.opengl.package = pkgs.mesa_23;
      hardware.opengl.extraPackages = with pkgs; [ amdvlk ];

      hardware.opengl.driSupport32Bit = true;
      hardware.opengl.package32 = pkgs.pkgsi686Linux.mesa_23;
      hardware.opengl.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    })
  ];
}
