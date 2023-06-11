# Bonsai.Harp

[Harp Devices](https://harp-tech.org/Devices/device_list.html) implement the [`Harp Protocol`](https://harp-tech.org/About/How-HARP-works/index.html) via which they can communicate with an host PC. The `Bonsai.Core` library provides an implementation of the `Harp Protocol` that can be used to interface these devices.

The Harp.Core library provides the following operators:

![Harp.Core Operators](./../Assets/core-operators.svg)

It is critical to conceptually understand the function of each of these operators as they are the building blocks of any Harp application. Additionally, when interfacing, using bonsai, with a particular model of an `Harp Device`, device-specific variants of these operators can be accessed to expose a device-specific, high-level, interface to the user.

## The `Device` operator

The [`Device`](xref:Bonsai.Harp.Device) is the first node you likely add to your workflow when using any `Harp Device`. It is responsible for establishing a serial connection with the device and for providing an interface that can be used to send and receive messages, in the form of [`HarpMessage`](xref:Bonsai.Harp.HarpMessage) objects(xref:Bonsai.Harp.HarpMessage). Messages sent by the board to the host will correspond to notifications(or replies), whereas messages sent from the host to the node will result in commands(or requests) being sent to the device.
Finally, the `Device` node also provides, via its default-editor (double-click the node while bonsai is not running), a user-interface that allows the user to configure core device settings as well as upload firmware `.hex` files to the device. (see #ref.... TODO)

The current specification of the `Harp Protocol` defines three [`HarpMessage types`](xref:Bonsai.Harp.MessageType):

- `Read`: A command from the host to the device, that will result in a [`HarpMessage`](xref:Bonsai.Harp.HarpMessage) response, from the device, containing the value stored in the specified `register`. All `registers` are expected to allow read access, as by protocol specification.
- `Write`: A command issued by the host to the device to request the change of a particular `register`'s value. As per the protocol standard, if the `write` operation is returns successfully, the device should return a timestamped [`HarpMessage`](xref:Bonsai.Harp.HarpMessage) of the `Write` type with the newly set value.
- `Event`: The only message type that is emitted from the device to the host without a corresponding prior command. These messages are used to notify the host of events that occur on the device, such as a periodic computations (*e.g.* ADC reads), or other sporadic events (*e.g.* toggle on a digital input pin).

The following `Bonsai.Harp` operators provide the core functionality for generating [`HarpMessage`](xref:Bonsai.Harp.HarpMessage) objects (to issue commands), and for processing `HarpMessages` (to handle notifications).

## [`CreateMessage`](xref:Bonsai.Harp.CreateMessage) & [`Format`](xref:Bonsai.Harp.Format) operators

In order to generate messages and thus be able to issue commands to the device two core operators are provided: [`CreateMessage`](xref:Bonsai.Harp.CreateMessage) and [`Format`](xref:Bonsai.Harp.Format). Both operators receive a single input and are able to generate a [`HarpMessage`](xref:Bonsai.Harp.HarpMessage) object. However, they differ on how the message is generated. [`CreateMessage`](xref:Bonsai.Harp.CreateMessage) will fully define a [`HarpMessage`](xref:Bonsai.Harp.HarpMessage) using the settings available in the property grid, whereas [`Format`](xref:Bonsai.Harp.Format) will use the input sequence to generate a [`HarpMessage`](xref:Bonsai.Harp.HarpMessage)'s payload. Conceptually, the latter operator is similar to [`Format`](xref:Bonsai.Harp.Format) methods present in several programming languages, such as [`String.Format`](https://learn.microsoft.com/en-us/dotnet/api/system.string.format?view=net-7.0) in `C#`.

Take as example the following hypothetical [`HarpMessage`](xref:Bonsai.Harp.HarpMessage):

```csharp
Address: 32
MessageType: Write
Length: 1
PayloadType: U16
Payload: 10
```

### [`CreateMessage`](xref:Bonsai.Harp.CreateMessage)

To generate it, one could use the [`CreateMessage`](xref:Bonsai.Harp.CreateMessage) operator:

![CreateMessage](./../Assets/create-message.svg)

### [`Format`](xref:Bonsai.Harp.Format)

or, equivalently, the the following [`Format`](xref:Bonsai.Harp.Format) operator:

![FormatMessage](./../Assets/format.svg)

## [`FilterMessage`](xref:Bonsai.Harp.FilterMessage) & [`Parse`](xref:Bonsai.Harp.Parse) operators

As opposed to the previous dyad of operators, the following are used to process [`HarpMessage`](xref:Bonsai.Harp.HarpMessage) objects that are received from the device. These operators can be used to filter, parse, and transform incoming messages.

### [`FilterMessage`](xref:Bonsai.Harp.FilterMessage)

In its simplest form, [`FilterMessage`](xref:Bonsai.Harp.FilterMessage) functions as a [`Condition`](xref:Bonsai.Core.Reactive.Condition) that checks, for each incoming message, whether the message's type and address match the ones specified in the property grid. If the condition is met, the message is passed through the operator, otherwise it is discarded.

For instance, if one would be interested in listening to the echo emitted from the device after the previous [`CreateMessage`](xref:Bonsai.Harp.CreateMessage) or [`Format`](xref:Bonsai.Harp.Format) operators, one could use the following [`FilterMessage`](xref:Bonsai.Harp.FilterMessage) operator:

![FilterMessage](./../Assets/filter-message.svg)

### [`Parse`](xref:Bonsai.Harp.Parse)

While [`FilterMessage`](xref:Bonsai.Harp.FilterMessage) can be used to filter incoming messages, the value of every single `HarpMessage` in the sequence will return unchanged. However, in many cases, one might be interested in extracting, and converting, the value of the message's payload. This is where the [`Parse`](xref:Bonsai.Harp.Parse) operator comes handy. This operator will extract and parse the payload of any incoming message and return a new sequence of parsed values. The type of the parsed values will depend on the `PayloadType` of the incoming message. For instance, if the `PayloadType` is `U16`, the operator will return a sequence of `ushort` values. The following workflow shows how to parse the payload of the previous example:

![Parse](./../Assets/parse.svg)

It should be noted that if an [`Address`](xref:Bonsai.Harp.Parse.Address), or [`MessageType`](xref:Bonsai.Harp.Parse.MessageType), are defined, the node will additionally filter the incoming sequence of messages prior to the parsing operation.
## Registers and Names blah blah