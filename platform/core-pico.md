## Overview

[Harp Pico Core](https://harp-tech.org/core.pico/) implements the Harp protocol on the Raspberry Pi RP2040 and RP2350 microcontrollers. It is included in a device project as a CMake dependency alongside the Pico SDK and provides the shared behavior every Harp device needs: synchronization to an external Harp clock, parsing of incoming request messages, dispatch to the right register, and timestamped replies. Device firmware then only adds the registers and logic specific to the device.

The core and its documentation are hosted in the [harp-tech/core.pico](https://github.com/harp-tech/core.pico) repository. Devices built on this core include the [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin).

For the API reference, examples, and integration guide, visit the [Harp Pico Core documentation](https://harp-tech.org/core.pico/).
