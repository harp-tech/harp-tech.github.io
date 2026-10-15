## Overview

[Harp Core ATxmega](https://harp-tech.org/core.atxmega/) implements the Harp protocol on the Microchip ATxmega family of microcontrollers and underlies the first generation of Harp devices. It is compiled as a library and included in each device's Atmel Studio project, providing communication with the host computer with transmit and receive buffering, the common and application register banks, timestamp and synchronization management, and control of the state LED. Device firmware then only adds the registers and logic specific to the device.

The core and its documentation are hosted in the [harp-tech/core.atxmega](https://github.com/harp-tech/core.atxmega) repository. Devices built on this core include the Harp Behavior, Sound Card, and Timestamp Generator boards.

For the API reference and integration guide, visit the [Harp Core ATxmega documentation](https://harp-tech.org/core.atxmega/).
