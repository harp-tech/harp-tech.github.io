# Getting Started

The [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin) is a simple multi-purpose device designed to help users learn the fundamentals of the Harp standard. The principles demonstrated in this tutorial series can also be applied to other Harp-compatible devices.

## Installation

- Install [Bonsai](https://bonsai-rx.org/docs/articles/installation.html)
- Install the `Harp.Hobgoblin` package by searching for it in the [Bonsai package manager](https://bonsai-rx.org/docs/articles/packages.html), using `nuget.org` as the package source.

## Flashing the Firmware

- Download the latest version of the [firmware](https://github.com/harp-tech/device.hobgoblin/releases/) that matches your Pico board.
- Press-and-hold the Pico `BOOTSEL` button while you connect the device to your computer's USB port.
- Drag-and-drop the `.uf2` file into the new storage device that appears on your PC.

## Testing the Device

:::workflow
![Hobgoblin Hello World](~/workflows/hobgoblin-helloworld.bonsai)
:::

- Connect a simple switch to `AnalogInput0`. 
- Hover over the workflow above, click the copy button in the top right corner, and paste it into Bonsai. 
- Run the workflow and observe the output of `AnalogInput0`. The value should change when the switch is pressed.

(TODO: Insert wiring diagram)

## Installing Harp-Python

The [harp-python](../articles/python.md) library provides an low-level interface to read and manipulate data from Harp devices. We recommend installing `harp-python` using [`uv`](https://docs.astral.sh/uv/), an extremely fast and modern Python package and project manager.

- Install [`uv`](https://docs.astral.sh/uv/).
- Create a folder for the project (e.g., `hobgoblin_data`)
- Navigate to the folder and initialize a new project:
```powershell
uv init
```
- Install `harp-python` as a dependency:
```powershell
uv add harp-python 
```