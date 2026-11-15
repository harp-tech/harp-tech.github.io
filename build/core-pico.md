# Pico core

The [Harp Pico core](https://harp-tech.org/core.pico/) implements the Harp protocol on the Raspberry Pi RP2040 and RP2350 microcontrollers. Device projects include it as a submodule alongside the Pico SDK. The core handles synchronization to the synchronization clock, parsing of incoming requests, dispatch to the appropriate register, and timestamped replies. Device firmware adds only the registers and logic specific to the device.

Devices built on this core include the [Harp Hobgoblin](https://harp-tech.org/device.hobgoblin/) and many devices from the Allen Institute for Neural Dynamics. The source is in the [harp-tech/core.pico](https://github.com/harp-tech/core.pico) repository, and the [core documentation](https://harp-tech.org/core.pico/) covers its API and examples.
