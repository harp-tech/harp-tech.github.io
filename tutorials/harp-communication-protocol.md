# Communication Protocol

The Harp standard has two parts: a communication protocol that allows devices and controllers to speak the same language, and a [synchronization clock](harp-synchronization-clock.md) protocol that governs how devices in a setup keep the same time. This article covers the communication protocol.

A Harp device is controlled by a computer, which we call the controller. The device exposes its configuration settings and functions through numbered addresses called **registers**. Every exchange between the two is a **Harp message** that targets a register and carries a value, called the **payload**. It also includes other kinds of metadata, like the timestamp on the clock or the length of the message. There are three different groups of Harp messages: **Commands**, **Replies** and **Events**.

::: harp-figure
![Harp messages between a controller and a device](~/images/harp-messages.svg)

Commands go from the controller to the device, and the device answers each one with a reply. Events come from the device on its own.
:::

## Command-Reply

A command from the controller can be one of two types:

- **Write** sets a register to a new value. For example, a sound card device might have a register that starts sound playback. A Write command would target that register with a payload that corresponds to the sound to play.
- **Read** asks for the current value of a register. For example, a device might have a register that reports the state of the digital inputs. Sending a Read command does not need a payload value.

The device answers every command with a reply. The reply reports the same register and the payload value (in these examples either the sound index or state of the digital inputs). Importantly, it also includes the time on the device's clock when the command was executed, so all commands are hardware timestamped.

::: harp-figure
![Two commands and their replies](~/images/harp-command-reply.svg)

A Write to the StartSound register carries the sound index to play, and a Read of the DigitalInputs register only identifies the register. In both cases the device replies with the same register, the payload value, and the timestamp from its own clock.
:::

## Events

The third type of message is an **Event**, which the device sends on its own without instruction from the controller. For example, the device might broadcast a stream of analog input readings without an explicit Read command from the device. Events carry a hardware timestamp in the same way as replies.

::: harp-figure
![An Event message from the device](~/images/harp-event.svg)

An Event from the AnalogInput register carries the reading as the payload and, like a reply, a hardware timestamp. The stream is broadcast at 1 kHz without a request from the controller.
:::

## Additional resources

For the byte-level details, see the [Binary Protocol](../protocol/BinaryProtocol-8bit.md) specification.
