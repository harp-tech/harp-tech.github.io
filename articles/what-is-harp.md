Harp is a standardized platform for automatic, sub-millisecond synchronization of data acquisition and experimental control in neuroscience. It includes:

:::wrap-right
![Behavior Peripherals](~/images/behavior-peripherals.jpg)
:::

  - [Protocols](protocol.md) for communication between Harp devices and the host computer
  - [Software interfaces](interface.md) for interacting with devices and handling data
  - [Hardware templates](hardware.md) for developing new Harp-compatible devices

Commands and events processed by all Harp devices are hardware timestamped and streamed back to the host computer over USB with a one millisecond latency. The stateless and symmetric communication protocol allows temporally accurate logging while avoiding the need for fixed sampling rates and redundant processing. Harp devices can be connected to a shared clock line and continuously self-synchronise their clocks to a precision of tens of microseconds. This means that all experimental events are timestamped on the same clock and no post-hoc alignment of timing is necessary.

The Harp ecosystem currently includes [devices](../devices-page/harp-behaviour.md) to configure, control, and collect data from a wide range of peripheral devices such as cameras, LEDs, nosepokes, and motors. Combining Harp devices is an easy way to extend experimental setup functionality with integrated timestamp synchronisation across devices. To learn how to use your Harp device, head on over to the [tutorials](../tutorials/setup.md).