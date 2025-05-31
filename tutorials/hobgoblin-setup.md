# Getting Started

The [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin) is a simple multi-purpose device designed to help users learn the fundamentals of the Harp standard. The principles demonstrated in this tutorial series can also be applied to other Harp-compatible devices.

## Installation

1. Install [Bonsai](https://bonsai-rx.org/docs/articles/installation.html)
2. Install `Harp.Hobgoblin` package by searching for it in the [Bonsai package manager](https://bonsai-rx.org/docs/articles/packages.html), using `nuget.org` as the package source.

## Flashing the Firmware

1. Download the latest version of the [firmware](https://github.com/harp-tech/device.hobgoblin/releases/) that matches your Pico board.
2. Press-and-hold the Pico `BOOTSEL` button while you connect the device to your computer's USB port.
2. Drag-and-drop the `.uf2` file into the new storage device that appears on your PC.

## Testing the Device

:::workflow
![Hobgoblin Hello World](~/workflows/hobgoblin-helloworld.bonsai)
:::

1. Connect a simple switch to `AnalogInput0`. 
2. Hover over the workflow above, click the copy button in the top right corner, and paste it into Bonsai. 
3. Run the workflow and observe the output of `AnalogInput0`. The value should change when the switch is pressed.

(TODO: Insert wiring diagram)