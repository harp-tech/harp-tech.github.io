# Firmware

## Updating device firmware

As `Harp Devices` are updated, new features are added and bugs are fixed. To ensure that your device is running the latest firmware, you can use the `Device Setup` tool available in Bonsai. This tool will be available with the `Bonsai.Harp.Design` package. To launch it, simply add a generic `Device` node to your workflow, and open its default editor (by double-clicking on the node). If an `Harp Device` is detected on the currently selected `COM port`, the following dialog will appear:

![firmware update](~/images/fw-update.png)

To update the device's firmware version:

1. Click `Bootloader`;
2. Click `Open`;
3. Select a `.hex` file containing the new firmware. These files should be available on the device's releases page (e.g.: [Harp Behavior](https://github.com/harp-tech/device.behavior/releases) under the `fwX.Y-harpV.W` release name). Importantly, as stated in the dialog window, please ensure the the new firmware is compatible with the targeted device;
4. Click `Update`

![firmware update step2](~/images/fw-update_hex.png)

If everything goes well, the device will reboot with the new firmware.