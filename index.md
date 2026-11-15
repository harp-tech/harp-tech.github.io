# Harp

:::: landing

::: landing-text
Harp is a standard for asynchronous real-time data acquisition and experimental control in neuroscience. It includes specifications for a lightweight and versatile binary communication protocol, a set of common registers for microcontroller firmware, and a clock synchronization protocol.

Commands and events processed by all Harp devices are hardware timestamped and streamed back to the host computer over USB with a one millisecond latency. The stateless and symmetric communication protocol allows temporally accurate logging while avoiding the need for fixed sampling rates and redundant processing. Harp devices can be connected to a shared clock line and continuously self-synchronize their clocks to a precision of tens of microseconds. This means that all experimental events are timestamped on the same clock and no post-hoc alignment of timing is necessary.

<div class="landing-actions">
<a class="landing-card" href="articles/harp-tech-devices.md">
<span class="landing-card-title"><i class="bi bi-box-seam"></i> Use</span>
<span class="landing-card-text">Find a device and control it from Bonsai or Python.</span>
</a>
<a class="landing-card" href="protocol/BinaryProtocol-8bit.md">
<span class="landing-card-title"><i class="bi bi-tools"></i> Build</span>
<span class="landing-card-text">Implement the protocol in a new device or controller.</span>
</a>
<a class="landing-card" href="connect/index.md">
<span class="landing-card-title"><i class="bi bi-share"></i> Connect</span>
<span class="landing-card-text">Ask questions and share projects with the community.</span>
</a>
</div>
:::

::: landing-image
![Harp Behavior board with peripherals](images/behavior-peripherals.jpg)
:::

::::
