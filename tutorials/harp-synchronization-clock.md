# Synchronization Clock

The Harp standard has two parts: a [communication protocol](harp-communication-protocol.md) that allows devices and controllers to speak the same language, and a synchronization clock protocol that governs how devices in a setup keep the same time. This article covers the synchronization clock.

Each device has its own clock, so two devices that saw the same event would normally record it with two unrelated timestamps. Harp solves this with a dedicated clock cable. One device, the Timestamp Generator, broadcasts the current time once per second, and every device connected to it aligns its clock to that time.

::: harp-figure
![Device timelines without and with the synchronization clock](~/images/harp-clock.svg)

Without a shared clock the same event is recorded at three unrelated times. With the synchronization clock every device records it at the same time.
:::

Once devices share the clock, their timestamps can be compared directly, with no alignment step afterwards. Devices stay synchronized to within tens of microseconds, and the clock cable is separate from the USB connection, so devices plugged into different computers still share the same time.

For the electrical and timing details, see the [Synchronization Clock](../protocol/SynchronizationClock.md) specification.
