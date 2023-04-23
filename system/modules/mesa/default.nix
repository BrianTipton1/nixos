inputs:
{ config, lib, pkgs, ... }:

with lib; {
  # Add options for whether to build mesa GPU drivers from master git branch
  options.mesa.enable = lib.mkEnableOption "mesa";
  options.mesa.git.enable = lib.mkEnableOption "mesa git";

  config = mkMerge [
    (mkIf (config.mesa.git.enable) {

      hardware.opengl = let
        attrs = oa: {
          name = "mesa-git";
          src = inputs.mesa-git;
          nativeBuildInputs = oa.nativeBuildInputs ++ [ pkgs.glslang ];
          # mesonFlags = oa.mesonFlags
          #   ++ [ "-Dvulkan-layers=device-select,overlay" ];
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
      # nixpkgs.overlays = [
      #   (final: prev: rec {
      #     libsForQt5 = prev.libsForQt5.overrideScope' (qt5final: qt5prev:
      #       let
      #         plasma5 = qt5prev.plasma5.overrideScope' (pFinal: pPrev: {
      #           kpipewire = pPrev.kpipewire.override { mesa = prev.mesa_23; };
      #           kwin = pPrev.kwin.override { mesa = prev.mesa_23; };
      #           xdg-desktop-portal-kde = pPrev.xdg-desktop-portal-kde.override {
      #             mesa = prev.mesa_23;
      #           };
      #         });
      #       in plasma5 // { inherit plasma5; });
      #     plasma5Packages = libsForQt5;
      #   })
      # ];
    })

    (mkIf (config.mesa.enable && !config.mesa.git.enable) {
      hardware.opengl.enable = true;
      hardware.opengl.driSupport = true;
      hardware.opengl.package = pkgs.mesa_23;
      hardware.opengl.extraPackages = with pkgs; [ amdvlk ];

      ## For 32 bit applications
      hardware.opengl.driSupport32Bit = true;
      hardware.opengl.package32 = pkgs.pkgsi686Linux.mesa_23;
      hardware.opengl.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
      nixpkgs.overlays = [
        (final: prev: rec {
          libsForQt5 = prev.libsForQt5.overrideScope' (qt5final: qt5prev:
            let
              plasma5 = qt5prev.plasma5.overrideScope' (pFinal: pPrev: {
                kpipewire = pPrev.kpipewire.override { mesa = prev.mesa_23; };
                kwin = pPrev.kwin.override { mesa = prev.mesa_23; };
                xdg-desktop-portal-kde = pPrev.xdg-desktop-portal-kde.override {
                  mesa = prev.mesa_23;
                };
              });
            in plasma5 // { inherit plasma5; });
          plasma5Packages = libsForQt5;
        })
      ];
    })
  ];
}
