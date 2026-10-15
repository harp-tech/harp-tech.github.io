# Harp Framework

Building a Harp compatible device or software means implementing a set of shared specifications regarding the communication protocol, device functionality and interface language. To help builders and developers, we have also released a set of common microcontroller cores  and utilities.

:::: framework-grid

::: framework-card
## Protocol

Every device speaks the same [Binary Protocol](../protocol/BinaryProtocol-8bit.md): a compact message format used in both directions between a device and the host, with the device stamping replies and events using its own hardware clock. The [Synchronization Clock](../protocol/SynchronizationClock.md) is a separate hardware bus that keeps the clocks of every connected device on a common timebase, so data from different devices can be compared without any alignment step.
:::

::: framework-card
## Device Contract

The [Common Registers](../protocol/Device.md) fix the behavior every device must provide: identity and version reporting, operating modes, heartbeat, and timestamp handling. What is specific to your device is declared in the [Interface Specification](device-yml.md), a `device.yml` file that lists each application register with its address, type, access mode, and meaning. That file is the single source for the firmware declarations, the host interfaces, and the documentation.
:::

::: framework-card
## Reference Cores

A reference core implements the protocol, the common registers, and clock synchronization for a microcontroller family, so device firmware only has to add the device-specific logic. [ATxmega](core-atxmega.md) targets the ATxmega family used by the first generation of Harp devices. [Pico](core-pico.md) targets the RP2040 and RP2350 families.
:::

::: framework-card
## Utilities

The [Harp Toolkit](toolkit.md) is a command-line tool that generates Harp compatible firmware, interfaces and verifying Harp devices. It generates firmware scaffolding and host interface code from `device.yml`, writes firmware images to a connected device, and verifies that an assembled device conforms to the specifications. 
:::

::::
