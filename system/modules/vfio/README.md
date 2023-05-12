# VFIO Module for nixos

## Notable Features

- Ease of use
- Included Helper script to hot swap devices and list information related to passthrough

## Setup
>
> Add to your flake inputs

```nix
vfio-module.url = "github:BrianTipton1/nixos";
```

> Where ever you add all your nixos modules add

```nix
inputs.vfio-module.nixosModules."x86_64-linux".vfio
```

## Configuration

If enabling the following values are required at minimum

```nix
vfio.enable
vfio.pcie-ids
vfio.cpu-type
vfio.users
```

You can either pass the required PCIE ids for the device via plain strings or an attribute set with descriptions. The attribute set works well with the python script so it can give more detailed information of what devices are system defined to be passed through. This goes the same for usb-ids.

### Base Setup
>
> configuration.nix

```nix
...
vfio.enable = true;
vfio.cpu-type = "amd or intel";
vfio.users = [ "users" "who" "you" "want" "to" "have" "vfio" "permissions" ];
...
```

### PCIE Setup

To get the required device ids for pass through running the iommu-script is helpful to group them all together. Additional questions see arch wiki. Section 2.2 is the script below. [PCI_passthrough_via_OVMF](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)

```bash
nix run github:BrianTipton1/nixos#packages.x86_64-linux.vfio.script
```

> Sample output


```console
...
IOMMU Group 15:
 01:00.0 Non-Volatile memory controller [0108]: Intel Corporation SSD 660P Series [8086:f1a8] (rev 03)
...
IOMMU Group 24:
 09:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU104 [GeForce RTX 2070 SUPER] [10de:1e84] (rev a1)
 09:00.1 Audio device [0403]: NVIDIA Corporation TU104 HD Audio Controller [10de:10f8] (rev a1)
 09:00.2 USB controller [0c03]: NVIDIA Corporation TU104 USB 3.1 Host Controller [10de:1ad8] (rev a1)
 09:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU104 USB Type-C UCSI Controller [10de:1ad9] (rev a1)
...
```

The above output is used in the samples below

- Passing PCIE device ids plain strings

> configuration.nix

```nix
vfio.pcie-ids = [ "10de:1e84" "10de:10f8" "10de:1ad8" "10de:1ad9" "8086:f1a8" ];
```

- Passing PCIE device ids as attribute sets with descriptions

```nix
vfio.pcie-ids = [
    {
    name = "nvidia-rtx-2070-super";
    ids = [
        {
            id = "10de:1e84";
            description = "VGA compatible controller";
        }
        {
            id = "10de:10f8";
            description = "HD Audio Controller";
        }
        {
            id = "10de:1ad8";
            description = "Host Controller";
        }
        {
            id = "10de:1ad9";
            description = "USB Type-C UCSI Controller";
        }
    ];
    }
    {
        name = "intel-m1-drive";
        ids = [
            {
                id = "8086:f1a8";
                description = "Non-Volatile memory controller";
            }
        ];
    }
];
```

## USB passthrough

- Optional usb setup passing usb vendor ids as plain strings or attr sets
  - Creates udev rules for each device to allow
  - This is not required for SPICE usb redirection

Ids below aquired from running lsusb command

```
...
Bus 005 Device 006: ID 0416:3fcd Winbond Electronics Corp. VD104M
...
Bus 003 Device 002: ID 046d:c539 Logitech, Inc. Lightspeed Receiver
```

- Passing usb ids as strings

> configuration.nix

```nix
vfio.usb-ids = [ "046d" "0416" ];
```

- Passing usb ids as attribute sets with descriptions

```nix
vfio.usb-ids = [
    {
        name = "Logitech Mouse Receiver";
        id = "046d";
    }
    {
        name = "Varmillo Keyboard";
        id = "0416";
    }
];
```

## Pam Fix

Fixes issue with memory paging limits when attempting to pass through gpu

```nix
vfio.pam-fix.enable = true;
```

## Python Helper Script (TODO..) 

Python script I have wrapped with nix to pass through the current systems vfio configuration.
> Enabling

```nix
vfio.script.enable = true;
```

### Swapping PCIE Devices

Swapping makes sure that all other devices are do not have it plugged in and if one does then it removes it. If the vm is running and is connected to the device in question then it errors.

```bash
vfio swap VM_NAME DEVICE
```

The DEVICE can either be the following

- The name of a list of ids
  - From the above example either (nvidia-rtx-2070-super or intel-m1-drive)
  - Essentially allows you to swap a whole group at once
- The individual id itself

### Adding or Removing USB Devices #TODO

>Tenative plan for this when I have time
The DEVICE can either be the name or id

```bash
vfio add VM_NAME DEVICE
vfio remove VM_NAME DEVICE
```

### Showing Groups

Just runs the iommu group script

```bash
vfio groups
```

### Help menu

```bash
vfio --help
```

output:

```
```

## Other related issues

On nixos I had an issue with UEFI boot not working. libvirt needed some extra help added to the below file. [Issue on nixpkgs github](https://github.com/NixOS/nixpkgs/issues/115996).
> ~/.config/libvirt/qemu.conf

```

nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
```
