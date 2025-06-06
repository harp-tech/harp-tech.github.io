# Close-Loop Systems

The exercises below will help you become familiar with using the [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin) device for close-loop experiments. You will also learn how to interface with external cameras. Before you begin, it is recommended that you review the Bonsai [Acquisition and Tracking](https://bonsai-rx.org/docs/tutorials/acquisition.html) tutorial, which covers key video concepts.

## Prerequisites

- Install the `Bonsai.Dsp`, `Bonsai.Video` and `Bonsai.Vision` packages from the [Bonsai package manager](https://bonsai-rx.org/docs/articles/packages.html).

## Close-loop latency
In a closed-loop experiment, we want the behaviour data to generate feedback in real-time into the external world, establishing a relationship where the output of the system depends on detected sensory input. Many behavioural experiments in neuroscience require some kind of closed-loop interaction between the subject and the experimental setup. 

One of the most important benchmarks to evaluate the performance of a closed-loop system is the latency, or the time it takes for a change in the output to be generated in response to a change in the input. The easiest way to measure the latency of a closed-loop system is to use a digital feedback test. 

Before beginning, set up the `Hobgoblin` with the following `device pattern` that we learned about in the previous tutorial.

:::workflow
![Hobgoblin Device Pattern](../workflows/hobgoblin-closeloop-devicepattern.bonsai)
:::

- Set the `DumpRegisters` property in the `Hobgoblin` [`Device`] operator to `False`. This is to avoid triggering the command loop in the next exercise.

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
- After the `Seconds` node, insert a [`Difference`] operator.

Lastly, we will use this sequence to toggle the digital output and initialize the command loop:

- Insert a [`KeyDown`] operator and set the `Filter` property to the key `A`.
- Insert a [`Parse`] operator and select [`DigitalOutputTogglePayload`] from the `Register` property dropdown menu. Set the `DigitalOutputToggle` property to `GP15`
- Insert a [`MulticastSubject`] operator and configure the `Name` property to `Hobgoblin Commands`. 
- Run the workflow, and open the visualizer for the [`Difference`] operator.  
**What do you observe?**

### Exercise 2: Measuring video acquisition latency

![Hobgoblin LED](../images/hobgoblin-acquisition-led.svg){width=400px}
- Connect a red LED module to digital output channel `GP15` on the `Hobgoblin`.

:::workflow
![Hobgoblin Closed-Loop Latency Video](../workflows/hobgoblin-closeloop-latency-video.bonsai)
:::

- Insert a [`VideoCaptureDevice`] operator.
- Insert a [`Crop`] transform.
- Run the workflow and set the `RegionOfInterest` property to a small area around the LED.

> [!Tip]
> You can use the visual editor for an easier calibration. While the workflow is running, right-click on the [`Crop`] transform and select `Show Default Editor` from the context menu or click in the small button with ellipsis that appears when you select the `RegionOfInterest` property.

- Insert a [`Sum`] transform and select the `Val2` field from the output.

> [!Note]
> The [`Sum`] operator adds the value of all the pixels in the image together, across all the color channels. Assuming the default BGR format, the result of summing all the pixels in the `Red` channel of the image will be stored in `Val2`. `Val0` and `Val1` would store the `Blue` and `Green` values, respectively. If you are using an LED with a color other than red, please select the output field accordingly.

- Insert a [`GreaterThan`] transform.
- Insert a [`BitwiseNot`] transform.
- Insert a [`CreateMessage`] operator, select [`DigitalOutputTogglePayload`] for the `Payload`, and `GP15` for the [`DigitalOutputToggle`] property.
- Insert a [`MulticastSubject`] operator and configure the `Name` property to `Hobgoblin Commands`. 
- Run the workflow and use the visualizer of the [`Sum`] operator to choose an appropriate threshold for [`GreaterThan`]. You can use the [`KeyDown`] toggle snippet from the previous exercise to manually toggle the LED.
- Insert a [`DistinctUntilChanged`] operator after the [`BitwiseNot`] transform.

> [!Note]
> The [`DistinctUntilChanged`] operator filters consecutive duplicate items from an observable sequence. In this case, we want to change the value of the LED only when the threshold output changes from `LOW` to `HIGH`, or vice-versa. This will let us measure correctly the latency between detecting a change in the input and measuring the response to that change.

In order to measure the round-trip time between the LED toggle:

:::workflow
![Hobgoblin Closed-Loop Latency Video Measurement](../workflows/hobgoblin-closeloop-latency-video-measurement.bonsai)
:::

- Insert a [`SubscribeSubject`] operator and configure the `Name` property to `Hobgoblin Events`. 
- Insert a [`Parse`] operator and select [`TimestampedDigitalOutputTogglePayload`] from the `Register` property dropdown menu.
- Right-click on the [`Parse`] operator, select `Output (Bonsai.Harp.Timestamped<Harp.Hobgoblin.DigitalOutputs>)` > `Seconds` from the context menu.
- Insert a [`Difference`] operator.
- Run the workflow and open the visualizer for the [`Difference`] operator.

_Given the measurements obtained in Exercise 2, what would you estimate is the **input** latency for video acquisition?_

## Closed-Loop Control

### Exercise 3: Introduction to pulse trains

In neuroscience, pulse trains are commonly used to deliver precisely timed sequences of electrical states (`LOW` and `HIGH`) to control external devices, such as cameras for synchronization or lasers for optogenetic stimulation. However, due to operating system limitations, generating pulse trains by setting [`DigitalOutputSet`] and [`DigitalOutputClear`] in software like Bonsai can be prone to timing jitter (though this approach is sufficient for the stimuli we have been working with). Fortunately the `Hogoblin` provides dedicated `Registers` that can be used to start or stop hardware-programmed pulse trains. We will use such pulse trains as our close-loop stimuli for the next few exercises.

- Connect a red LED module to digital output channel `GP15` on the `Hobgoblin`. 
- Insert a [`KeyDown`] operator and set the `Filter` property to the key `A`.
- Insert a [`Parse`] operator and select [`StartPulseTrainPayload`] from the `Register` property dropdown menu. Set the `DigitalOutput` property to `GP15`.
- Set the `PulseCount` property to `0`, `PulsePeriod` to `50000` and `PulseWidth` to `5000`. These parameters correspond to a continuous 20Hz pulse train with 5 ms pulses.
- Insert a [`MulticastSubject`] operator and configure the `Name` property to `Hobgoblin Commands`. 
- Insert another [`KeyDown`] operator and set the `Filter` property to the key `S`.
- Insert a [`Parse`] operator and select [`StopPulseTrainPayload`] from the `Register` property dropdown menu. Set the `StopPulseTrain` property to `GP15`.
- Run the workflow, use the `A` and `S` keys to start and stop the pulse train.
**What do you observe?**

To better understand what each parameter controls, try the following modifications. Reset the values to the parameters above after each step.

- Increase the `PulsePeriod` to `200000`. What is the frequency of this stimulation? How would you increase the frequency of the pulses to 40Hz?
- Increase the `PulseWidth` to `40000`. What do you observe?
- How would you deliver a 2 second pulse train? (Hint: Use `PulseCount`)

>[!NOTE]
> **Optional** Verify the pulse train by connecting the output to a digital input pin. How would you visualize the results using what you've learned?

>[!NOTE]
> **Optional** If you have cameras that support external hardware triggering, use what you have learned in this exercise to trigger frame capture.

<!--Reference Style Links -->
[`BitwiseNot`]: xref:Bonsai.Expressions.BitwiseNotBuilder
[`CreateMessage`]: xref:Harp.Hobgoblin.CreateMessage
[`Crop`]: xref:Bonsai.Vision.Crop
[`Device`]: xref:Harp.Hobgoblin.Device
[`Difference`]: xref:Bonsai.Dsp.Difference
[`DigitalOutputToggle`]: xref:Harp.Hobgoblin.DigitalOutputToggle
[`DigitalOutputTogglePayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputTogglePayload
[`DistinctUntilChanged`]: xref:Bonsai.Reactive.DistinctUntilChanged
<!-- [`DeviceDataWriter`]: xref:Harp.Hobgoblin.DeviceDataWriter -->
[`DigitalOutputSet`]: xref:Harp.Hobgoblin.DigitalOutputSet
[`DigitalOutputClear`]: xref:Harp.Hobgoblin.DigitalOutputClear
<!-- [`DigitalOutputClearPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputSetPayload -->
<!-- [`DigitalOutputSetPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputClearPayload -->
[`GreaterThan`]: xref:Bonsai.Expressions.GreaterThanBuilder
<!-- [`HarpMessage`]: xref:Bonsai.Harp.HarpMessage -->
[`KeyDown`]: xref:Bonsai.Windows.Input.KeyDown
<!-- [`Merge`]: xref:Bonsai.Reactive.Merge -->
[`MulticastSubject`]: xref:Bonsai.Expressions.MulticastSubject
[`Parse`]: xref:Harp.Hobgoblin.Parse
<!-- [`PublishSubject`]: xref:Bonsai.Reactive.PublishSubject -->
<!-- [`RollingGraph`]: xref:Bonsai.Gui.ZedGraph.RollingGraphBuilder -->
[`SubscribeSubject`]: xref:Bonsai.Expressions.SubscribeSubject
[`Sum`]: xref:Bonsai.Dsp.Sum
[`TimestampedDigitalOutputTogglePayload`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputToggle
<!-- [`TimestampedDigitalOutputSet`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputSet -->
<!-- [`TimestampedDigitalOutputClear`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputClear -->
[`VideoCaptureDevice`]: xref:Bonsai.Video.VideoCaptureDevice
<!-- [`Zip`]: xref:Bonsai.Reactive.Zip -->