## Overview

The [Harp Toolkit](https://harp-tech.org/toolkit/) is a command-line tool for inspecting, updating, and interfacing with Harp devices. It is distributed as the NET tool package and is invoked as `dotnet harp.toolkit`. The source is hosted in the [harp-tech/toolkit](https://github.com/harp-tech/toolkit) repository under the MIT license.

## Main functions

- **Device inspection** - List the serial ports available on the system and read the identity, hardware version, and firmware version of a device connected to a given port.
- **Firmware update** - Write a firmware image to a connected device over its serial port. Only devices built on the ATxmega core are currently supported.
- **Code generation** - Generate device interface and firmware code from a `device.yml` metadata file. Interfaces can target .NET, for use with [Bonsai.Harp](https://harp-tech.org/api/Bonsai.Harp.html), or Python, for use with [Harp Python](https://harp-tech.org/python/). Firmware headers and implementation stubs can be generated for the ATxmega core.
- **Device verification** - Check a connected device against the Harp specification and report where its behavior departs from the standard. Checks cover the core register set, the reply behavior required by the binary protocol, and alignment on the synchronization clock. Results print to the console and can be saved as a shareable HTML report.

Visit the [documentation](https://harp-tech.org/toolkit/) to learn how to use the Harp Toolkit.
