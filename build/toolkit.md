# Harp Toolkit

The [Harp Toolkit](https://harp-tech.org/toolkit/) is a command-line tool for inspecting, updating and interfacing with Harp devices. It is published as the `Harp.Toolkit` .NET tool package and runs as `dotnet harp.toolkit`.

- **Device inspection** lists the serial ports on the system and reads the identity and versions of a device connected to a port.
- **Firmware update** writes a firmware image to a connected device, after checking that the image is compatible with it.
- **Code generation** generates device interfaces for Bonsai.Harp and Harp Python, firmware headers and stubs, and reference documentation from a `device.yml` file.
- **Device verification** checks a connected device against the Harp specification, covering the common registers, the reply behavior required by the binary protocol and synchronization clock alignment, and can save the results as a shareable HTML report.

The [toolkit documentation](https://harp-tech.org/toolkit/) covers installation and every command.
