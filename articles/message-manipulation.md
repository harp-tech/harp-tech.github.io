# Manipulating `HarpMessage` objects

## Modifying `HarpMessage` Fields

So far, we have covered how to generate `HarpMessages` using a constructor operator (*i.e.* [`CreateMessage`](xref:Bonsai.Harp.CreateMessage)) or by using [`Format`](xref:Bonsai.Harp.Format) with compatible data types. However, in specific cases, we might want to take a given `HarpMessage` and simply change the value of one or more of it fields, for example its `Address`. While one could, in theory, [`Parse`](xref:Bonsai.Harp.Parse) the incoming message into its components and "reassemble" everything with the aforementioned operators, this tends to be too cumbersome. As an alternative, one can use a different overload of [`Format`](xref:Bonsai.Harp.Format) that takes an `HarpMessage` and replaces the value of one or more of its fields by non-null values defined in the properties of the operator. This overload is only available when the `Register` property of the [`Parse`](xref:Bonsai.Harp.Format) operator is set to [`FormatMessagePayload`](xref:Bonsai.Harp.FormatMessagePayload). For instance, if one would like to change the `Address` of an `HarpMessage`:

:::workflow
![ModifyHarpMessageAddress](~/workflows/modify-message-address.bonsai)
:::

It should be noted that multiple fields can be changed simultaneously by settings the corresponding property to a non-null value.

## Injecting timestamps in `HarpMessage` `Payload`

Finally, we can inject a timestamp into a `HarpMessage` by also using the [`Format`](xref:Bonsai.Harp.Format) operator. This is done by providing an input in the form of a `Timestamped<T>`, where `T` must be a compatible type. For instance, if one would want to set the timestamp of a given message to `0`:

:::workflow
![ModifyHarpMessageTimestampFromDouble](~/workflows/modify-message-double-timestamp.bonsai)
:::

Alternatively, one can also construct the [`Timestamped<T>`](xref:Bonsai.Harp.Timestamped) from another using another timestamped `HarpMessage`:

:::workflow
![ModifyHarpMessageTimestamp](~/workflows/modify-message-timestamp.bonsai)
:::

## Manipulating timestamped streams

While the `Timestamped` portion of an Harp Message is optional, it is often useful to have access to it. After all, it provides temporal information on `Events` and `Commands`, and can be used to perform time-based operations on the data. The `Bonsai.Harp` library provides a set of operators that can be used to manipulate the `Timestamped` portion of a [`HarpMessage`](xref:Bonsai.Harp.HarpMessage).

## Accessing the `Timestamp` portion of an HarpMessage payload.

As per protocol specifications, the `Payload` portion of an Harp Message might contain information pertaining to the timestamp of the message as given by the device. To access this information, we use the [`Parse`](xref:Bonsai.Harp.Parse) as shown in the previous tutorial. In its simplest form, the [`Parse`](xref:Bonsai.Harp.Parse) can, for any `HarpMessage`, extract the timestamp information by setting the `Payload` property to `Timestamp`.

:::workflow
![ParseTimestamp](~/workflows/parse-timestamp.bonsai)
:::

It is important to keep in mind that:

- If a `HarpMessage` does not contain the optional `Timestamp` field, the operator will throw an error. A user can check if a message has a valid `Timestamp` field using the the `IsTimestamped`(xref:Bonsai.Harp.HarpMessage.IsTimestamped) field of the `HarpMessage` class:

:::workflow
![ParseTimestamp](~/workflows/filter-timestamped.bonsai)
:::

- In this mode, the `Parse` operator will not parse the `Payload` data portion of the message. This is useful when the user is only interested in the `Timestamp` portion of the message.

If you are interested in simultaneously parse the data and timestamp information of a message, for each `<Register>`, an alternative value can be selected in the form of a `Timestamped<Register>`. This pattern is available for both `Bonsai.Harp` core and `Harp.Device`-specific operators.

:::workflow
![ParseTimestampData](~/workflows/parse-timestamp-data.bonsai)
:::

## Timestamping generic data

The timestamp provided by each `HarpMessage` is often a result of a device operation and will thus be assigned in hardware. However, it is often useful to also assign a timestamp to events that occur in software, in the host side. For example, when a user presses a mouse button, it is useful to know when the button was pressed, ideally with a somewhat meaningful temporal reference to the acquired Harp data. Unfortunately, the host PC does not run the same clock synchronization protocol as the Harp Devices, and thus cannot use this clock to timestamp events. However, we can still assign a timestamp to an event by using the timestamp from the latest available message to the board. Since the round-trip delay between host and device is typically small and with low jitter (<5ms) we can use this strategy to timestamp software events. Finally, the result of `WithLatestFrom` can be readily converted into a `Harp.Timestamped<T>` type using the [`CreateTimestamped`](xref:Bonsai.Harp.CreateTimestamped) operator, as shown below.

Critically, users must keep in mind that this strategy is not ideal for high-precision timing applications, and comes with a few caveats that must be kept in mind:

- The Harp Device runs a real-time operating system (RTOS) where event timestamping takes a high priority. The host PC, on the other hand, runs a non-RTOS operating system where event timestamping is not a priority. This might result in a larger than expected jitter, and users are encouraged to benchmark it before using it.

- This strategy rests on the assumption that the host has access to a steady stream of messages from the device. However, while some devices provide high-frequency events (e.g. 1kHz Analog read events from a Behavior board), other boards are typically silent. In these cases, the temporal stream will be non-homogenous and with poor resolution, and users should use an alternative strategy.

:::workflow
![WithLatestTimestampFiltered](~/workflows/withlatest-timestamp-filtered.bonsai)
:::

- An alternative strategy is to, on each software event to be timestamped, request a `Read` operation from any register from the board. Since each `Read` message is also timestamped, this can be assigned to the software event using a sort of asynchronous "request-timestamp" strategy.

:::workflow
![AsyncRequestTimestamp](~/workflows/timestamp-async.bonsai)
:::

### Creating Timestamped<T> types

Similarly to the [`Timestamped<T>`](xref:System.Reactive.Timestamped) types present part of Bonsai Core, `Bonsai.Harp` also provides its own [`Timestamped<T>`](xref:Bonsai.Harp.Timestamped) type. This type can be created using the [`CreateTimestamped`](xref:Bonsai.Harp.CreateTimestamped) operator, which takes as input a `Timestamp` and a `Value` and outputs a [`Timestamped<T>`](xref:Bonsai.Harp.Timestamped) type. This type is the basis for several timestamped operations in `Bonsai.Harp`, including the ability to create `HarpMessages` with a timestamped `Payload` field.

:::workflow
![CreateTimestamped](~/workflows/create-timestamped.bonsai)
:::

Alternatively, [`Timestamped<T>`](xref:System.Reactive.Timestamped) can also be created by replacing the time source by an `HarpMessage`. In this case, the temporal information will be extracted from the message of the second input. This is useful when the user wants to create a timestamped value from a message that already contains a timestamp, for instance, from an Harp Device:

:::workflow
![CreateTimestamped](~/workflows/create-timestamped-from-message.bonsai)
:::

## Maintaining temporal metadata in processing pipeline

When using timestamped messages arriving from an `Harp Device`, we often want to compute some transformation on the incoming data (say a value from the ADC that we might want to convert) while maintaining the timestamp of the data that gave rise to it. While one could use core reactive operators such as [`WithLatestFrom`](xref:Bonsai.Reactive.WithLatestFrom) to achieve such result, `Bonsai.Harp` provides the nested operator, [`ConvertTimestamped`](xref:Bonsai.Harp.ConvertTimestamped),  that makes this process easier. This operator takes as input a [`Timestamped<T>`](xref:Bonsai.Harp.Timestamped), for instance the result of a [`Parse`](xref:Bonsai.Harp.Parse) operation and allows the user to define any necessary logic inside the operator.

All operations inside the operator should be synchronous in nature as to not induce a mis-pairing between the timestamp and the data. In other words, the nested operations should behave as a `Transform` operator.

For example, manipulating the value of a register, and reassigning the original timestamp, can be done as follows:

:::workflow
![FormatTimestamped](~/workflows/convert-timestamped.bonsai)
:::

## Creating `HarpMessages` with a timestamped `Payload`

### Using `CreateMessage`

So far, we have only covered cases where the timestamp is extracted from an existing `HarpMessage`. However, in certain cases it might also be useful to create a `HarpMessage` with a `Timestamp` in the `Payload` field. Paralleling its use to generate `HarpMessages`, [`CreateMessage`](xref:Bonsai.Harp.CreateMessage) can also be used to *inject* a timestamped. We achieve this by:

1. Setting the `PayloadType` (or `Payload`) property to a `Timestamped` type (e.g. `TimestampedU8`);
2. Passing a [`Timestamped<T>`](xref:Bonsai.Harp.Timestamped) type to the operator.

:::workflow
![CreateMessageTimestamped](~/workflows/create-message-timestamped.bonsai)
:::

### Using `Format`

The same way we previously used [`Format`](xref:Bonsai.Harp.Format) to create a `HarpMessage` from a compatible value, we can also, inject a `Timestamp` in the `Payload` field at the same time. We use the same pattern as [`CreateMessage`](xref:Bonsai.Harp.CreateMessage), but must make sure that the `T` type is compatible with the `Payload` selected in the `Format` operator.

:::workflow
![FormatTimestamped](~/workflows/format-timestamped.bonsai)
:::

