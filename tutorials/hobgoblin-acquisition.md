# Acquisition and Control

The exercises below will help you become familiar with acquiring and recording data from the `Hobgoblin` device, as well as issuing commands to connected peripheral devices using Bonsai. In addition, you will learn how to visualize and manipulate the recorded data in Python.

## Acquisition

### Exercise 1: Acquiring Analog Input

In the acquisition section of this tutorial we will record data from a photodiode sensor. Connect the photodiode to analog input channel `0` (`GP26`) on the `Hobgoblin`. 

(TODO: wiring diagram)

> [!TIP]
> You can use another sensor (such as a potentiometer, pushbutton, etc) and one of the other analog input channels by changing the appropriate properties.

Within Bonsai: 

:::workflow
![Hobgoblin Device Operator](../workflows/hobgoblin-device-operator.bonsai)
:::

- Insert a [`Device`] operator. This operator is the first node you will normally add to your workflow when using any Harp device, and initializes a connection to the device.

> [!NOTE]
> Notice how the [`Device`] operator automatically changes its name to `Hobgoblin` when added to the workflow. This is an example of a **polymorphic operator**, which changes its function and properties depending on what is being selected. In this tutorial, we will be referring to the original name of the operator in the Bonsai `Toolbox`, which will be different from how it appears in your workflow or in the workflow images shown.

- Set the `PortName` property of the [`Device`] operator to the communications port of the `Hobgoblin` (e.g. `COM7`).

> [!TIP]
> In Windows, you can find the device's port number in `Device Manager` under `Ports (COM & LPT)` by locating the `USB Serial Device`.

:::workflow
![Analog Input](../workflows/hobgoblin-helloworld.bonsai)
:::

- Insert a [`Parse`] operator to extract and process a specific `HarpMessage` to listen to from the device. 
- Within the [`Parse`] operator, select [`AnalogData`] from the `Register` property dropdown menu. 
- Right click on the [`Parse`] operator, select `Harp.Hobgoblin.AnalogDataPayload` > `AnalogInput0` from the context menu.

> [!NOTE]
> All `Harp` data and commands are transmitted as `HarpMessages`. For simplicity, a `HarpMessage` can be distilled into two essential components:
> - `Registers`: Specify the type of data or command being sent.
> - `Payloads`: Contain the actual content being sent.
>
> In this context, the `Register` [`AnalogData`] represents a collection of data from the device’s analog inputs. Each [`AnalogDataPayload`] contains the measurement from a single analog input channel.

- Run the workflow, open the visualizer for `AnalogInput0`, and shine the flashlight from your phone on the photodiode. **What do you see?**

### Exercise 2: Acquiring Timestamped Data

One of the main advantages of devices in the Harp ecosystem is that all messages and events are hardware-timestamped, rather than relying on software timestamping by the operating system, which are imprecise and subject to jitter. To access hardware timestamped data, make the follow modications to the previous workflow.

:::workflow
![Acquiring Timestamped Data](../workflows/hobgoblin-timestamp-data.bonsai)
:::

- Delete the `AnalogInput0` node.
- Change the `Register` property in the [`Parse`] operator from [`AnalogData`] to [`TimestampedAnalogData`].
- Right click on the [`Parse`] operator, select `Bonsai.Harp.Timestamped<Harp.Hobgoblin.AnalogDataPayload>` > `Seconds` from the context menu.
- Right click on the [`Parse`] operator again, but this time select `Value (Harp.Hobgoblin.AnalogDataPayload)` > `AnalogInput0` from the context menu.
- Add a [`Zip`] operator and connect the `Seconds` and `AnalogInput0` nodes to it.
- Run the workflow and open the visualizers for the `Seconds`, `AnalogInput0` and [`Zip`] nodes. **What is each visualizer representing?**

### Exercise 3: Recording Timestamped Data

For simple use cases, data can be saved to a text file using [`CsvWriter`]. In a later exercise, we will go through why this approach does not scale well for more complicated recordings. 

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
- Configure the `FileName` property of the [`CsvWriter`] with a file name ending in `.csv`, for instance `analog_input.csv`.
- Set the `IncludeHeader` property of the [`CsvWriter`] to `True`. This creates column headings for the text file with the new name assigned by [`ExpressionTransform`].
- Run the workflow, shine the line on the photodiode, and then open the resulting text file. **How is the data organized?**

### Exercise 4: Visualizing Recorded Data

We will take a brief detour from Bonsai to look at how to visualize the data we have recorded. This section assumes you already have an interactive notebook installed (e.g. [JuypterLab](https://jupyter.org/)) and a virtual environment with [`pandas`](https://pandas.pydata.org/) and [`matplotlib`](https://matplotlib.org/). If you have installed the `harp-python` library, `pandas` is already included as a dependency. `matplotlib` is not included with `pandas` by default but is needed for the `pandas` plotting backend.

- Open a new interactive notebook and import `pandas`.

```python 
import pandas as pd
```

- Load the `.csv` into a dataframe variable.

```python 
df_analog_input = pd.read_csv("analog_input.csv")
```
- Inspect the dataframe by looking at the first 5 rows.

```python 
df_analog_input.head()
```

- Plot the data by passing the right columns into the `x` and `y` arguments. **What did you notice?**

```python 
df_analog_input.plot(x = "Timestamp", y = "AnalogInput0", xlabel= "Timestamp (seconds)", ylabel = "Analog Input (value)", legend = False)
```

- **Optional:** Normalize the `Timestamp` column by subtracting the initial value from all the values in the column.

```python 
df_analog_input["Timestamp"] = df_analog_input["Timestamp"] - df_analog_input["Timestamp"].iloc[0]
```

- Plot the data again.

```python 
df_analog_input.plot(x = "Timestamp", y = "AnalogInput0", xlabel= "Timestamp (seconds)", ylabel = "Analog Input (value)", legend = False)
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
- Configure the [`DigitalOutputClear`] property to the same digital output pin (`GP15`).

> [!NOTE]
> At this point we are ready to send these `HarpMessage` commands into the `Hobgoblin`. However, the [`Device`] operator only accepts one input node transmitting all the `HarpMessage` commands.

- Insert a [`Merge`] operator to combine these two commands into one `HarpMessage` sequence.
- Insert a [`Device`] operator to send the `HarpMessage` sequence into the `Hobgoblin`.
- Run the workflow and press either the `A` or `S` key. **What do you observe?**

### Exercise 6: Recording Timestamped Commands

To know when the digital output of the `Hobgoblin` was turned on or off, we can use the same format we learned in the acquisition section to receive `HarpMessages` that are transmitted when the command was executed by device.

:::workflow
![Timestamp Digital Output](../workflows/hobgoblin-timestamp-digitaloutput.bonsai)
:::

- Insert a [`Parse`] operator and select [`TimestampedDigitalOutputSet`] from the `Register` property dropdown menu.
- Insert another [`Parse`] operator and select [`TimestampedDigitalOutputClear`] from the `Register` property dropdown menu.
- Run the workflow, open the visualizers for both of these nodes, and toggle the LED on and off. **What do you notice?**

> [!NOTE]
> For both operators, the `HarpMessage` contains the pin number for the digital output that was either turned on or off, as well as the timestamps for those commands. They can be used to report the digital output commands for all pins available on the `Hobgoblin`. However, as the `Payload` for these `HarpMessages` have an identical structure, we now have to process and combine them into a format that we can save as data.

:::workflow
![Saving Digital Output](../workflows/hobgoblin-saving-digitaloutput.bonsai)
:::

- Right click on both operators and select `Bonsai.Harp.Timestamped<Harp.Hobgoblin.DigitalOutputs>` > `Seconds` from the context menu.
- Insert a [`Merge`] operator to merge the `Seconds` nodes.
- Right click on both operators and select `Bonsai.Harp.Timestamped<Harp.Hobgoblin.DigitalOutputs>` > `Value` from the context menu.
- Insert a [`Boolean`] operator after the `Value` node coming from [`TimestampedDigitalOutputSet`]. Set the [`Boolean`] `value` property to `True`. 
- Insert a [`Boolean`] operator after the `Value` node coming from [`TimestampedDigitalOutputClear`]. Set the [`Boolean`] `value` property to `False`. 
- Insert a [`Merge`] operator to merge the [`Boolean`] nodes.
- Insert a [`Zip`] operator to package the output of the two [`Merge`] nodes together.
- Run the workflow, open the visualizer for the [`Zip`] operator, and toggle the LED on and off. **What do you see?**

> [!TIP]
> Explore the visualizers for the other nodes as well while the workflow is running to see what information each node is transmitting and how it is being transformed. 

- Add a [`ExpressionTransform`] operator. 
- Double click the [`ExpressionTransform`] operator and add the follow code in the editor.

```csharp
new(Item1 as Timestamp, Item2 as DigitalOutput0)
```

- Add a [`CsvWriter`] operator.
- Configure the `FileName` property of the [`CsvWriter`] with a file name ending in `.csv`, like `digital_output.csv`.
- Set the `IncludeHeader` property of the [`CsvWriter`] to `True`. 
- Run the workflow, toggle the LED on and off, and then open the resulting `.csv` file. **How is the data organized? How is it different from the analog input data?**

## Integration

### Exercise 7: Combining Acquisition and Control

You now have all the pieces to integrate for a full workflow that has both acquisition of data and control of peripheral devices. Combine the two workflows together and it should look something like this:

:::workflow
![Integrate Acquisition and Control](../workflows/hobgoblin-integrate-acquisition-control.bonsai)
:::

- Run the workflow and verify that you can record photosensitive signals on the analog input channel as well as toggle the LED with the keypresses.
- Inspect the recorded analog input data and digital output command text files and verify that they are in the correct format and reflect what you are seeing and controlling.

### Exercise 8: Visualizing Synchronized Recordings

Another main advantage of devices in the Harp ecosystem is that all recorded information streams are timestamped to the same hardware clock. Thus, there is no need for post-hoc alignment during visualization and analysis. We will now take a look at our recorded text files and look at how to visualize them together. 

- Open a new interactive notebook and import `pandas` and `matplotlib`.

```python 
import pandas as pd
import matplotlib.pyplot as plt
```

- Load and plot the recorded analog input data.

```python 
df_analog_input = pd.read_csv("analog_input.csv")
df_analog_input.plot(x = "Timestamp", y = "AnalogInput0")
```

- Load and inspect the recorded digital output commands.

```python 
df_digital_output = pd.read_csv("digital_output.csv")
df_digital_output.head()
```

> [!NOTE]
> Since the digital output is a Boolean value that simply indicates whether the LED is on or off, it is not meaningful to plot it on its own.

- Overlay the digital output as shaded regions on the plot of the analog input.

```python 
# Create a plot with the analog input data.
ax = df_analog_input.plot(x='Timestamp', y='AnalogInput0')

# Loop through digital events in pairs (`True` followed by `False`) 
# Pass the timestamps as `on_time` and `off_time` to the matplotlib vertical shading function `axvspan`. 
# Ignore duplicate commands
on_time = None
off_time = None
for _, row in df_digital_output.iterrows():
    if row['DigitalOutput0'] == True and on_time is None:
        on_time = row['Timestamp'] 
    elif row['DigitalOutput0'] == False and on_time is not None:
        off_time = row['Timestamp']
        ax.axvspan(on_time, off_time, color='lightblue', alpha=0.3)
        # Reset variables
        on_time = None  
        off_time = None

# Set plot properties
ax.set_xlabel("Timestamp (second)")
ax.set_ylabel("Analog Input (value)")
ax.get_legend().remove()

# Show plot
plt.show()
```
> [!TIP]
> **Optional** - You can repeat the normalization step from [Exercise 4](#exercise-4-visualizing-recorded-data). Keep in mind when handling multiple data streams, all dataframes should be normalized to the earliest timestamp.

## Streamlining

### Exercise 9: Streamlining Recording

You might have noticed that the workflow in [Exercise 7](#exercise-7-combining-acquisition-and-control) is quite large due to all the additional nodes needed to process and record the data and commands. While this approach may be feasible for simple use cases, it does not scale well as more devices are added. The `Harp.Hobgoblin` package provides a [`DeviceDataWriter`] that can be used to record all the data and commands received by the device. 

:::workflow
![Hobgoblin DeviceDataWriter](../workflows/hobgoblin-devicedatawriter.bonsai)
:::

- Copy the workflow from [Exercise 7](#exercise-7-combining-acquisition-and-control).
- Delete all nodes that come after the [`Device`] operator.
- Add a [`DeviceDataWriter`] operator.
- Type a folder name in the `Path` property of [`DeviceDataWriter`]. This folder will be used to save all the data coming from the device.
- Run the workflow, then open the folder you specified in the previous step. **What do you observe?**

> [!NOTE]
> The [`DeviceDataWriter`] generates a `device.yml` file that contains device metadata that will be used later for loading data with `harp-python`. In addition, all the data from each `Register` is saved as a separate raw binary file. This includes not just data registers, but other common registers for device configuration or identification. In the next section, we will learn how to filter the `Registers` that are relevant for us. 

:::workflow
![Hobgoblin Filter DeviceDataWriter](../workflows/hobgoblin-filter-devicedatawriter.bonsai)
:::

- Disconnect the [`Device`] and [`DeviceDataWriter`] operators.
- Add a [`FilterRegister`] operator after the [`Device`] operator. Change the `Registry` property to [`AnalogData`].
- Add a second [`FilterRegister`] operator. Change the `Registry` property to [`DigitalOutputSet`].
- Add a third [`FilterRegister`] operator. Change the `Registry` property to [`DigitalOutputClear`].
- Add a [`Merge`] operator to combine the `HarpMessages` from those three registers.
- Connect the [`Merge`] operator to the [`DeviceDataWriter`] operator.
- Run the workflow again, then open the folder you specified in the previous step. **What do you observe?**

> [!NOTE]
> The [`FilterRegister`] operator can be used to either include or exclude registers to be recorded. The [`Parse`] operator cannot be used in this instance as it only outputs the `Payload` in the `HarpMessage` as a processed value. Thus it is useful for visualization, but not for recording with the [`DeviceDataWriter`].

### Exercise 10: Streamlining Data Analysis

The `harp-python` package also simplifies data visualization and analysis by providing a convenient interface to load and read the raw binary files that [`DeviceDataWriter`] records. This exercise assumes that you have setup the dependencies from previous exercises, as well as `harp-python`.

- Import `harp-python`.

```python 
import harp
```
- Create a `device` reader object to load `Hobgoblin` data by specifying the location of the `device.yml` generated by [`DeviceDataWriter`].

```python 
device = harp.create_reader("./data/device.yml")
```

- Load different sets of data by specifying the `Register` as a property for the `device` reader, and calling the `read()` method.

```python
analog_data = device.AnalogData.read()
```

- Find the type of the loaded data using the Python `type()` function. **What do you observe?**

```python
type(analog_data)
```

> [!NOTE]
> The output of `device.Register.read()` is a `pandas` dataframe with access to all of its methods. 

- Inspect the data by looking at the first 5 rows.

```python
analog_data.head()
```

- Plot the data.

```python
analog_data.plot(xlabel= "Timestamp (seconds)", ylabel = "Analog Input (value)")
```

> [!NOTE]
> **Optional** Now that you understand the data loaded by `harp-python`, can you reproduce [Exercise 8](#exercise-8-visualizing-synchronized-recordings)?

<!--Reference Style Links -->
[`AnalogData`]: xref:Harp.Hobgoblin.AnalogData
[`AnalogDataPayload`]: xref:Harp.Hobgoblin.AnalogDataPayload
[`Boolean`]: xref:Bonsai.Expressions.BooleanProperty
[`CreateMessage`]: xref:Harp.Hobgoblin.CreateMessage
[`CsvWriter`]: xref:Bonsai.IO.CsvWriter
[`Device`]: xref:Harp.Hobgoblin.Device
[`DeviceDataWriter`]: xref:Harp.Hobgoblin.DeviceDataWriter
[`DigitalOutputSet`]: xref:Harp.Hobgoblin.DigitalOutputSet
[`DigitalOutputClear`]: xref:Harp.Hobgoblin.DigitalOutputClear
[`DigitalOutputClearPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputSetPayload
[`DigitalOutputSetPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputClearPayload
[`ExpressionTransform`]: xref:Bonsai.Scripting.Expressions.ExpressionTransform
[`FilterRegister`]: xref:Harp.Hobgoblin.FilterRegister
[`KeyDown`]: xref:Bonsai.Windows.Input.KeyDown
[`Merge`]: xref:Bonsai.Reactive.Merge
[`Parse`]: xref:Harp.Hobgoblin.Parse
[`TimestampedAnalogData`]: xref:Harp.Hobgoblin.TimestampedAnalogData
[`TimestampedDigitalOutputSet`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputSet
[`TimestampedDigitalOutputClear`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputClear
[`Zip`]: xref:Bonsai.Reactive.Zip