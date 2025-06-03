# Reaction Time Task

In this tutorial, you will learn how to use the [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin) to implement a simple reaction time task, which will serve as our model systems neuroscience experiment. In this task, the subject needs to press a button as fast as possible following a stimulus, as described in the following diagram:

:::diagram
![State Machine Diagram](../images/reactiontime.svg)
:::

The task begins with an inter-trial interval (`ITI`), followed by stimulus presentation (`ON`). After stimulus onset, advancement to the next state can happen only when the subject presses the button (`success`) or a timeout elapses (`miss`). Depending on which event is triggered first, the task advances either to the `Reward` state, or `Fail` state. At the end, the task goes back to the beginning of the ITI state for the next trial.

### Exercise 1: Generating a fixed-interval stimulus

In this first exercise, you will assemble the basic hardware and software components required to implement the reaction time task. Connect the LED to digital output channel `0` (`GP15`) on the `Hobgoblin`. 

(TODO: wiring diagram)

>[!TIP]
> You can wire the LED into any digital input pin, but make sure to change the appropriate properties.

Next, we will set up our `Hobgoblin`. While we can connect operators carrying `HarpMessage` streams to and from the [`Device`] operator directly like we did in the [Acquisition and Control](./hobgoblin-acquisition.md) tutorial, as a workflow grows this becomes cumbersome to manage. To address this issue, we introduce a new [device pattern](../articles/operators.md#device-pattern):

:::workflow
![Hobgoblin Device Pattern](../workflows/hobgoblin-reactiontime-devicepattern.bonsai)
:::

- Insert a [`Device`] operator and set the `PortName` property.
- Insert a [`PublishSubject`] operator and name it `Hobgoblin Events`. This will allow us to receive the stream of `HarpMessage` objects from the `Hobgoblin` at multiple places in our workflow.
- Right-click the [`Device`] operator, select `Create Source (Bonsai.Harp.HarpMessage)` > [`BehaviorSubject`]. Name the generated ``BehaviourSubject`1`` operator `Hobgoblin Commands`. Connect it as input to the [`Device`] operator.

>[!NOTE]
> This [source subject](https://bonsai-rx.org/docs/articles/subjects.html#source-subjects) is an operator that is set up to receive commands from multiple places in the workflow and pass them on to the `Hobgoblin`. When creating a `source subject` we choose [`BehaviorSubject`] instead of [`PublishSubject`] to ensure that the connection remains open until the workflow is stopped.

Lastly, we will set up a fixed-interval blinking LED as our stimulus.

:::workflow
![Hobgoblin Device Pattern](../workflows/hobgoblin-reactiontime-stimulus.bonsai)
:::

- Insert a [`Timer`] source and set its `DueTime` property to 1 second.
- Insert a [`CreateMessage`] operator, configure the `Payload` property to [`DigitalOutputSetPayload`], and set the [`DigitalOutputSet`] property to the `GP15` pin.
- Insert a [`MulticastSubject`] operator and configure the `Name` property to `Hobgoblin Commands`. This operator forwards `HarpMessages` it receives to `Hobgoblin Commands`.
- Insert a [`Delay`] operator and set its `DueTime` property to 200 milliseconds.
- Insert a [`CreateMessage`] operator, configure the `Payload` property to [`DigitalOutputClearPayload`], and set the [`DigitalOutputClear`] property to the `GP15` pin.
- Insert a [`MulticastSubject`] operator and configure the `Name` property to `Hobgoblin Commands`.
- Insert a [`Repeat`] operator.


<!--Reference Style Links -->
<!-- [`AnalogData`]: xref:Harp.Hobgoblin.AnalogData -->
<!-- [`AnalogDataPayload`]: xref:Harp.Hobgoblin.AnalogDataPayload -->
<!-- [`BehaviorSubject`]: xref:Bonsai.Reactive.BehaviorSubject -->
<!-- [`Boolean`]: xref:Bonsai.Expressions.BooleanProperty -->
[`CreateMessage`]: xref:Harp.Hobgoblin.CreateMessage
<!-- [`CsvWriter`]: xref:Bonsai.IO.CsvWriter -->
[`Delay`]: xref:Bonsai.Reactive.Delay
[`Device`]: xref:Harp.Hobgoblin.Device
<!-- [`DeviceDataWriter`]: xref:Harp.Hobgoblin.DeviceDataWriter -->
[`DigitalOutputSet`]: xref:Harp.Hobgoblin.DigitalOutputSet
[`DigitalOutputClear`]: xref:Harp.Hobgoblin.DigitalOutputClear
[`DigitalOutputClearPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputSetPayload
[`DigitalOutputSetPayload`]: xref:Harp.Hobgoblin.CreateDigitalOutputClearPayload
<!-- [`ExpressionTransform`]: xref:Bonsai.Scripting.Expressions.ExpressionTransform -->
<!-- [`FilterRegister`]: xref:Harp.Hobgoblin.FilterRegister -->
<!-- [`KeyDown`]: xref:Bonsai.Windows.Input.KeyDown -->
<!-- [`Merge`]: xref:Bonsai.Reactive.Merge -->
<!-- [`Parse`]: xref:Harp.Hobgoblin.Parse -->
[`MulticastSubject`]: xref:Bonsai.Expressions.MulticastSubject
[`PublishSubject`]: xref:Bonsai.Reactive.PublishSubject
[`Repeat`]: xref:Bonsai.Reactive.Repeat
[`Timer`]: xref:Bonsai.Reactive.Timer
<!-- [`TimestampedAnalogData`]: xref:Harp.Hobgoblin.TimestampedAnalogData -->
<!-- [`TimestampedDigitalOutputSet`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputSet -->
<!-- [`TimestampedDigitalOutputClear`]: xref:Harp.Hobgoblin.TimestampedDigitalOutputClear -->
<!-- [`Zip`]: xref:Bonsai.Reactive.Zip -->