# Acquisition and Control

The exercises below will help you become familiar with acquiring and recording data from the `Hobgoblin` device, as well as issuing commands to connected peripheral devices using Bonsai. In addition, you will learn how to visualize and manipulate the recorded data in Python.

## Acquisition

### Exercise 1: Acquiring Analog Input

In the acquisition section of this tutorial we will record data from a photodiode sensor. Connect the photodiode to analog input channel `0` (`GP26`) on the `Hobgoblin`. 

(TODO: wiring diagram)

> [!TIP]
> You can use another sensor (such as a potentiometer, pushbutton, etc) and one of the other analog input channels by changing the appropriate properties.

:::workflow
![Analog Input](../workflows/hobgoblin-helloworld.bonsai)
:::

Within Bonsai: 

- Insert a [`Device`] operator. This operator is the first node you will normally add to your workflow when using any Harp device, and initializes a connection to the device. 

> [!NOTE]
> Notice how the [`Device`] operator automatically changes its name to `Hobgoblin` when added to the workflow. This is an example of a **polymorphic operator**, which changes its function and properties depending on what is being selected. To avoid confusion, in this tutorial, we will be referring to the original name of the operator in the Bonsai `Toolbox`, which will be different from how it appears in your workflow or in the workflow images shown.

- Insert a [`Parse`] operator, which allows you to specify which `HarpMessage` to listen to from the device. 
- Within the [`Parse`] operator, select the [`AnalogData`] from the `Register` property dropdown menu. 
- Right click on the [`Parse`] operator, select the [`Harp.Hobgoblin.AnalogDataPayload`] > `AnalogInput0` from the context menu.

> [!NOTE]
> All `Harp` data and commands are received and sent in the form of `HarpMessages`. For simplicity sake, a `HarpMessage` can be distilled down to two critical values:
> - `Registers` are different data or command types.
> - `Payloads` are the actual content that is being sent.
>
> In this context, the `Register` [`AnalogData`] is a collection of data coming from the analog inputs, with each [`Harp.Hobgoblin.AnalogDataPayload`] carrying the values from a single analog input channel.

- Run the workflow, open the visualizer for `AnalogInput0`, and shine the flashlight from your phone on the photodiode. **What do you see?**

### Exercise 2: Acquiring Timestamped Data

One of the main advantages of devices in the Harp ecosystem is that all messages and events are hardware-timestamped, rather than relying on software timestamping by the operating system, which are imprecise and subject to jitter. To access hardware timestamped data, make the follow modications to the previous workflow.

:::workflow
![Acquiring Timestamped Data](../workflows/hobgoblin-timestamp-data.bonsai)
:::

- Delete the `AnalogInput0` node.
- Change the `Register` property in the [`Parse`] operator from [`AnalogData`] to [`TimestampedAnalogData`].
- Right click on the [`Parse`] operator, select `Bonsai.Harp.Timestamp<Harp.Hobgoblin.AnalogDataPayload>` > `Seconds` from the context menu.
- Right click on the [`Parse`] operator again, but this time select `Value (Harp.Hobgoblin.AnalogDataPayload)` > `AnalogInput0` from the context menu.
- Add a [`Zip`] operator and connect the `Seconds` and `AnalogInput0` nodes to it.
- Run the workflow and open the visualizers for the `Seconds`, `AnalogInput0` and [`Zip`] nodes. **What is each visualizer representing?**

### Exercise 3: Saving Data

For simple use cases (e.g. recording from a single channel from a single device), data can be saved to a text file using [`CsvWriter`]. In a later exercise, we will go through why this approach does not scale well for more complicated recordings. 

:::workflow
![Saving Data CSV](../workflows/hobgoblin-saving-csv.bonsai)
:::

- Add a [`ExpressionTransform`] operator. 
- Double click the [`ExpressionTransform`] operator and add the follow code in the editor.

```csharp
new(Item1 as Timestamp, Item2 as AnalogInput0)
```

> [!TIP]
> The [`Zip`] operator packages input items into a `tuple`, but loses the original item name. In this instance, the [`ExpressionTransform`] operator is useful for assigning a new name to those items.

- Add a [`CsvWriter`] operator.
- Configure the `FileName` property of the [`CsvWriter`] with a file name ending in `.csv`.
- Set the `IncludeHeader` property of the [`CsvWriter`] to `True`. This creates column headings for the `.csv` file with the new name assigned by [`ExpressionTransform`].
- Run the workflow, shine the line on the photodiode, and then open the resulting `.csv` file. **How is the data organized?**

### Exercise 4: Visualizing Recorded Data

We will take a brief detour from Bonsai to look at how to visualize the data we have recorded. This section assumes you already have an interactive notebook installed (e.g. [JuypterLab](https://jupyter.org/)) and a virtual environment with [`pandas`](https://pandas.pydata.org/) and [`matplotlib`](https://matplotlib.org/)(not included by default with `pandas`). If you have installed the `harp-python` library, `pandas` is already included as a dependency.

- Open a new interactive notebook and import `pandas`.

```python 
import pandas as pd
```

- Load the `.csv` into a dataframe variable.

```python 
df = pd.read_csv("analog_data.csv")
```
- Inspect the dataframe by looking at the first 5 rows.

```python 
df = pd.head()
```

- Plot the data by passing the right columns into the `x` and `y` arguments. **What did you notice?**

```python 
df.plot(x = "Timestamp", y = "AnalogInput0")
```

- **Optional:** Normalize the `Timestamp` column by subtracting the initial value from all the values in the column.

```python 
df["Timestamp"] = df["Timestamp"] - df["Timestamp"].iloc[0]
```

- Plot the data again.

```python 
df.plot(x = "Timestamp", y = "AnalogInput0")
```

> [!WARNING]
> This normalization step should be used with caution, as it only reflects the start time for that particular data stream and not the start time for a workflow with multiple data streams.

## Control

### Exercise 5: Controlling Digital Output

In the control section of this tutorial, we will send commands to turn on and off a LED. Connect a LED to digital output channel `0` (`GP15`) on the `Hobgoblin`. 

(TODO: wiring diagram)

> [!TIP]
> You can use another actuator (such as a active buzzer) and one of the other digital output channels by changing the appropriate properties.

Previously we have been acquiring data from the `Hobgoblin` by placing operators after the [`Device`] operator. In order to send commands to the device, we need to place operators that lead into the [`Device`] operator.

:::workflow
![Digital Output](../workflows/hobgoblin-digital-output.bonsai)
:::

- Insert a [`KeyDown`] operator and set its `Key` property to `A`. We will use this key to turn ON the LED.
- Insert a [`CreateMessage`] operator, which will construct a `HarpMessage` command to send to the device.
- Configure the `Payload` property to [`DigitalOutputSetPayload`] which will set the digital output to `High`.
- Configure the [`DigitalOutputSet`] property to select the digital output pin (`GP15`) to send the command to.

Now that we have constructed a `HarpMessage` to turn on the digital output, we will construct a similar `HarpMessage` to turn it off.

- Insert a [`KeyDown`] operator and set its `Key` property to `S`. We will use this key to turn OFF the LED.
- Insert a [`CreateMessage`] operator. 
- Configure the `Payload` property to [`DigitalOutputClearPayload`] which will clear the digital output and set it to `LOW`.
- Configure the [`DigitalOutputSet`] property to the same digital output pin (`GP15`).

> [!NOTE]
> At this point we are ready to send these `HarpMessage` commands into the `Hobgoblin`. However, the [`Device`] operator only accepts one input node, which would carry all the `HarpMessage` commands.

- Insert a [`Merge`] operator to combine these two commands into one `HarpMessage` sequence.
- Insert a [`Device`] operator to send the `HarpMessage` sequence into the `Hobgoblin`.
- Run the workflow and press either the `A` or `S` key. **What do you observe?**

<!--Reference Style Links -->
[`AnalogData`]: xref:Harp.Hobgoblin.AnalogData
[`CreateMessage`]: xref:Harp.Hobgoblin.CreateMessage
[`CsvWriter`]: xref:Bonsai.IO.CsvWriter
[`Device`]: xref:Harp.Hobgoblin.Device
[`DigitalInputState`]: xref:Harp.Hobgoblin.DigitalInputState
[`DigitalOutputSet`]: xref:Harp.Hobgoblin.CreateDigitalOutputSetPayload
[`DigitalOutputClearPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputSetPayload
[`DigitalOutputSetPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputClearPayload
[`ExpressionTransform`]: xref:Bonsai.Scripting.Expressions.ExpressionTransform
[`Harp.Hobgoblin.AnalogDataPayload`]: xref:Harp.Hobgoblin.AnalogDataPayload
[`KeyDown`]: xref:Bonsai.Windows.Input.KeyDown
[`Merge`]: xref:Bonsai.Reactive.Merge
[`Parse`]: xref:Harp.Hobgoblin.Parse
[`TimestampedAnalogData`]: xref:Harp.Hobgoblin.TimestampedAnalogData
[`Zip`]: xref:Bonsai.Reactive.Zip