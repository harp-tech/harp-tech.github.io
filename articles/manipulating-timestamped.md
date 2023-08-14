# Manipulating Timestamped HarpMessages

While the `Timestamped` portion of an Harp Message is optional, it is often useful to have access to it. Afteral, it provides temporal information on `Events` and `Commands`, and can be used to perform time-based operations on the data. The `Bonsai.Harp` library provides a set of operators that can be used to manipulate the `Timestamped` portion of a [`HarpMessage`](xref:Bonsai.Harp.HarpMessage).

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

## Timestamp generic data

The timestamp provided by each `HarpMessage` is often a result of a device operation and will thus be assigned in hardware. However, it is often useful to also assign a timestamp to events that occur in software, in the host side. For example, when a user presses a mouse button, it is useful to know when the button was pressed, ideally with a somewhat meaningful temporal reference to the acquired Harp data. Unfortunately, the host PC does not run the same clock synchronization protocol as the Harp Devices, and thus cannot use this clock to timestamp events. However, we can still assign a timestamp to an event by using the timestamp from the latest available message to the board. Since the round-trip delay between host and device is typically small and with low jitter (<5ms) we can use this strategy to timestamp software events. Finally, the result of `WithLatestFrom` can be readily converted into a `Harp.Timestamped<T>` type using the [`CreateTimestamped`](xref:Bonsai.Harp.CreateTimestamped) operator:

:::workflow
![WithLatestTimestamp](~/workflows/withlatest-timestamp.bonsai)
:::

Critically, users must keep in mind that this strategy is not ideal for high-precision timing applications, and comes with a few caveats that must be kept in mind:

- The Harp Device runs a real-time operating system (RTOS) where event timestamping takes a high priority. The host PC, on the other hand, runs a non-RTOS operating system where event timestamping is not a priority. This might result in a larger than expected jitter, and users are encouraged to benchmark it before using it.

- This strategy rests on the assumption that the host has access to a steady stream of messages from the device. However, while some devices provide high-frequency events (e.g. Behavior board via ADC reads), other boards are typically silent. In these cases, the temporal stream will be non-homogenous and with poor resolution, and users should use an alternative strategy.

:::workflow
![WithLatestTimestampFiltered](~/workflows/withlatest-timestamp-filtered.bonsai)
:::

- An alternative strategy is to, on each software event to be timestamped, request a `Read` operation from any register from the board. Since each `Read` message is also timestamped, this can be assigned to the software event using a sort of asynchronous "request-timestamp" strategy.

:::workflow
![AsyncRequestTimestamp](~/workflows/timestamp-async.bonsai)
:::