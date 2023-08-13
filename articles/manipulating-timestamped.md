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