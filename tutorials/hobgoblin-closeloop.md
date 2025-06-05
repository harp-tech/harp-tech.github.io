# Close-Loop Systems

The exercises below will help you become familiar with using the [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin) device for close-loop experiments. You will also learn how to use the `Hobgoblin` to interface with external cameras. Before you begin, it is recommended that you review the Bonsai [Acquisition and Tracking](https://bonsai-rx.org/docs/tutorials/acquisition.html) tutorial, which covers key video concepts.

## Prerequisites

- Install the `Bonsai.Dsp` package from the [Bonsai package manager](https://bonsai-rx.org/docs/articles/packages.html).

## Close-loop latency
In a closed-loop experiment, we want the behaviour data to generate feedback in real-time into the external world, establishing a relationship where the output of the system depends on detected sensory input. Many behavioural experiments in neuroscience require some kind of closed-loop interaction between the subject and the experimental setup. 

One of the most important benchmarks to evaluate the performance of a closed-loop system is the latency, or the time it takes for a change in the output to be generated in response to a change in the input. The easiest way to measure the latency of a closed-loop system is to use a digital feedback test. 

Before beginning, set up the `Hobgoblin` with the following `device pattern` that we learned about in the previous tutorial.

:::workflow
![Hobgoblin Device Pattern](../workflows/hobgoblin-closeloop-devicepattern.bonsai)
:::

- Set the `DumpRegisters` property in the `Hobgoblin` [`Device`] operator to `False`. This is to avoid triggering the command loop in the next exercise.

![Hobgoblin LED](../images/hobgoblin-acquisition-led.svg){width=400px}

- Connect one of the LED modules to digital output channel `GP15` on the `Hobgoblin`.

### Exercise 1: Measuring serial port communication latency

We will take advantage of the device's ability to echo back a timestamped message upon command execution to create a simple loop where each echo re-triggers the same command (toggling the digital output channel `HIGH` and `LOW`). The time interval between the echoes will give us the total closed-loop latency of the system, also known as the round-trip time. 

:::workflow
![Hobgoblin Closed-Loop Latency](../workflows/hobgoblin-closeloop-latency.bonsai)
:::

- Insert a [`SubscribeSubject`] operator and configure the `Name` property to `Hobgoblin Events`. 
- Insert a [`Parse`] operator and select [`TimestampedDigitalOutputTogglePayload`] from the `Register` property dropdown menu.
- Insert a [`CreateMessage`] operator, select [`DigitalOutputTogglePayload`] for the `Payload`, and `GP15` for the [`DigitalOutputToggle`] property.
- Insert a [`MulticastSubject`] operator and configure the `Name` property to `Hobgoblin Commands`. 

In order to measure the difference between the timestamps:

- Right-click on the [`Parse`] operator, select the `Output (Bonsai.Harp.Timestamped<Harp.Hobgoblin.DigitalOutputs>)` > `Seconds`.
- Disconnect the `Seconds` node from the [`CreateMessage`] operator.
- Reconnect the [`Parse`] and [`CreateMessage`] operator.
- After the `Seconds` node, insert a [`Difference`] operator from the `Bonsai.Dsp` package.

Lastly, we will use this sequence to initialize the command loop:

- Insert a [`KeyDown`] operator and set the `Filter` property to the key `A`.
- Insert a [`Parse`] operator and select [`DigitalOutputTogglePayload`] from the `Register` property dropdown menu. Set the `DigitalOutputToggle` property to `GP15`
- Insert a [`MulticastSubject`] operator and configure the `Name` property to `Hobgoblin Commands`. 
- Run the workflow, and open the visualizer for the [`Difference`] operator.  
**What do you observe?**

<!--Reference Style Links -->
[`CreateMessage`]: xref:Harp.Hobgoblin.CreateMessage
[`Device`]: xref:Harp.Hobgoblin.Device
[`Difference`]: xref:Bonsai.Dsp.Difference
[`DigitalOutputToggle`]: xref:Harp.Hobgoblin.DigitalOutputToggle
[`DigitalOutputTogglePayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputTogglePayload
<!-- [`DeviceDataWriter`]: xref:Harp.Hobgoblin.DeviceDataWriter -->
<!-- [`DigitalOutputSet`]: xref:Harp.Hobgoblin.DigitalOutputSet -->
<!-- [`DigitalOutputClear`]: xref:Harp.Hobgoblin.DigitalOutputClear -->
<!-- [`DigitalOutputClearPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputSetPayload -->
<!-- [`DigitalOutputSetPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputClearPayload -->
<!-- [`HarpMessage`]: xref:Bonsai.Harp.HarpMessage -->
[`KeyDown`]: xref:Bonsai.Windows.Input.KeyDown
<!-- [`Merge`]: xref:Bonsai.Reactive.Merge -->
[`MulticastSubject`]: xref:Bonsai.Expressions.MulticastSubject
[`Parse`]: xref:Harp.Hobgoblin.Parse
<!-- [`PublishSubject`]: xref:Bonsai.Reactive.PublishSubject -->
<!-- [`RollingGraph`]: xref:Bonsai.Gui.ZedGraph.RollingGraphBuilder -->
[`SubscribeSubject`]: xref:Bonsai.Expressions.SubscribeSubject
<!-- [`TimestampedAnalogData`]: xref:Harp.Hobgoblin.TimestampedAnalogData -->
[`TimestampedDigitalOutputTogglePayload`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputToggle
<!-- [`TimestampedDigitalOutputSet`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputSet -->
<!-- [`TimestampedDigitalOutputClear`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputClear -->
<!-- [`Zip`]: xref:Bonsai.Reactive.Zip -->