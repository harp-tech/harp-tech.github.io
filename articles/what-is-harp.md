Harp is a standard for asynchronous real-time data acquisition and experimental control in neuroscience. It includes specifications for a lightweight and versatile binary communication protocol, a set of common registers for microcontroller firmware, and a clock synchronization protocol.

:::wrap-right
![Behavior Peripherals](~/images/behavior-peripherals.jpg)
:::

Commands and events processed by all Harp devices are hardware timestamped and streamed back to the host computer over USB with a one millisecond latency. The stateless and symmetric communication protocol allows temporally accurate logging while avoiding the need for fixed sampling rates and redundant processing. Harp devices can be connected to a shared clock line and continuously self-synchronise their clocks to a precision of tens of microseconds. This means that all experimental events are timestamped on the same clock and no post-hoc alignment of timing is necessary.

The Harp ecosystem currently includes devices to configure, control, and collect data from a wide range of peripheral devices such as cameras, LEDs, nosepokes, and motors. Combining Harp devices is an easy way to extend experimental setup functionality with integrated timestamp synchronisation across devices.