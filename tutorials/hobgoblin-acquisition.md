# Acquisition and Control

The exercises below will help you get comfortable with acquiring and recording data from the `Harp Hobgoblin` device, as well as issuing commands to connected peripheral devices.

### Exercise 1: Acquiring Analog Data

Connect a sensor such as a photodiode to one of the analog input channels on the `Harp Hobgoblin`.

(TODO: wiring diagram)

Within Bonsai: 

- Insert a [`Device`] operator. This operator is the first node you will add to your workflow when using any Harp device, and initializes a connection to the device. 

> [!NOTE]
> Notice how the [`Device`] operator automatically changes its name to `Hobgoblin` when added to the workflow. This is an example of a **polymorphic operator**, which changes its function and properties depending on what is being selected. To avoid confusion, in this tutorial, we will be referring to the original name of the operator that can be found in the Bonsai `Toolbox`, which might be different from how it appears in your workflow or in the workflow images shown.

- Insert a [`Parse`] operator, which allows you to specify which messages or events to listen to from the device. 
- Within the [`Parse`] operator, select the [`AnalogData`] from the `Register` property dropdown menu. 
- Right click on the [`Parse`] operator, select the [`Harp.Hobgoblin.AnalogDataPayload`], and choose `AnalogInput0` from the dropdown menu.

> [!TIP]
> `Registers` are simply message or event types (for instance, [`AnalogData`] or [`DigitalInputState`]). Within each `Register`, there could be different `Payloads`, which you can think of as different bundles of data with the same event type. In this context, the `Register` is data coming from the analog inputs, and the `Payload` is a single analog input channel.

<!--Reference Style Links -->
[`Device`]: xref:Harp.Hobgoblin.Device
[`Parse`]: xref:Harp.Hobgoblin.Parse
[`AnalogData`]: xref:Harp.Hobgoblin.AnalogData
[`DigitalInputState`]: xref:Harp.Hobgoblin.DigitalInputState
[`Harp.Hobgoblin.AnalogDataPayload`]: xref:Harp.Hobgoblin.AnalogDataPayload