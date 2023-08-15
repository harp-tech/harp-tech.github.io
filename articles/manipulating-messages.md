# Manipulating `HarpMessage`

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