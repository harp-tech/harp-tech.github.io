# Acquisition and Control

The exercises below will help you become familiar with acquiring and recording data from the `Harp Hobgoblin` device, as well as issuing commands to connected peripheral devices using Bonsai. In addition, you will learn how to visualize and manipulate the recorded data in Python.

## Acquisition

### Exercise 1: Acquiring Analog Data

Connect a sensor such as a photodiode to one of the analog input channels on the `Harp Hobgoblin`.

(TODO: wiring diagram)

:::workflow
![Analog Acquisition](../workflows/hobgoblin-helloworld.bonsai)
:::

Within Bonsai: 

- Insert a [`Device`] operator. This operator is the first node you will add to your workflow when using any Harp device, and initializes a connection to the device. 

> [!NOTE]
> Notice how the [`Device`] operator automatically changes its name to `Hobgoblin` when added to the workflow. This is an example of a **polymorphic operator**, which changes its function and properties depending on what is being selected. To avoid confusion, in this tutorial, we will be referring to the original name of the operator that can be found in the Bonsai `Toolbox`, which might be different from how it appears in your workflow or in the workflow images shown.

- Insert a [`Parse`] operator, which allows you to specify which messages or events to listen to from the device. 
- Within the [`Parse`] operator, select the [`AnalogData`] from the `Register` property dropdown menu. 
- Right click on the [`Parse`] operator, select the [`Harp.Hobgoblin.AnalogDataPayload`] > `AnalogInput0` (or the `AnalogInput` that the photodiode is connected to) from the context menu.

> [!TIP]
> `Registers` are simply message or event types (for instance, [`AnalogData`] or [`DigitalInputState`]). Within each `Register`, there could be different `Payloads`, which you can think of as different bundles of data with the same event type. In this context, the `Register` [`AnalogData`] is a collection of data coming from the analog inputs, with each [`Harp.Hobgoblin.AnalogDataPayload`] being a single analog input channel.

- Run the workflow, open the visualizer for `AnalogInput0`, and shine the flashlight from your phone on the photodiode. **What do you see?**

### Exercise 2: Acquiring Timestamped Data

One of the main advantages of devices in the Harp ecosystem is that all messages and events are hardware-timestamped, rather than relying on software timestamping by the operating system, which can be imprecise and subject to jitter. To access hardware timestamped data, make the follow modications to the previous workflow.

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
- Change the `IncludeHeader` property of the [`CsvWriter`] to `True`. This creates column headings for the `.csv` file with the new name assigned by [`ExpressionTransform`].
- Run the workflow, shine the line on the photodiode, and then open the resulting `.csv` file. **How is the data organized?**

### Exercise 4: Visualizing Recorded Data

We will take a brief detour from Bonsai to look at how to visualize the data we have recorded. This section assumes you already have an interactive notebook installed (e.g. [JuypterLab](https://jupyter.org/)) and a virtual environment with [`pandas`](https://pandas.pydata.org/) and [`matplotlib`](https://matplotlib.org/)(not included by default with `pandas`). If you have installed the `harp-python` library, [`pandas`](https://pandas.pydata.org/) is already included as a dependency.

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

- **Optional** Normalize the `Timestamp` column by subtracting the initial value from all the values in the column.

```python 
df["Timestamp"] = df["Timestamp"] - df["Timestamp"].iloc[0]
```

- Plot the data again.

```python 
df.plot(x = "Timestamp", y = "AnalogInput0")
```

> [!WARNING]
> This normalization step should be used with caution, as it only reflects the start time for that particular data stream and not the start time for a workflow with multiple data streams.


<!--Reference Style Links -->
[`AnalogData`]: xref:Harp.Hobgoblin.AnalogData
[`CsvWriter`]: xref:Bonsai.IO.CsvWriter
[`Device`]: xref:Harp.Hobgoblin.Device
[`DigitalInputState`]: xref:Harp.Hobgoblin.DigitalInputState
[`ExpressionTransform`]: xref:Bonsai.Scripting.Expressions.ExpressionTransform
[`Harp.Hobgoblin.AnalogDataPayload`]: xref:Harp.Hobgoblin.AnalogDataPayload
[`Parse`]: xref:Harp.Hobgoblin.Parse
[`TimestampedAnalogData`]: xref:Harp.Hobgoblin.TimestampedAnalogData
[`Zip`]: xref:Bonsai.Reactive.Zip