# Harp Hobgoblin

The [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin) is a simple multi-purpose device for learning the basics of the Harp standard. It runs on an off-the-shelf Raspberry Pi Pico, so there is no custom board to order, and it is designed to be adapted and modified for a variety of purposes. The tutorials in this section use it to walk through acquiring data, controlling outputs, and running a small closed-loop task.

![Harp Hobgoblin Pico2](../images/device-hobgoblin-pico2.png){width=300}  
*<small>Pico 2 board mounted on the Gravity: Expansion Board</small>*

## Assembling the device

The Hobgoblin firmware runs directly on a [Raspberry Pi Pico](https://www.raspberrypi.com/products/raspberry-pi-pico/) or [Pico 2](https://www.raspberrypi.com/products/raspberry-pi-pico-2/). To make it easy to connect inputs and outputs, we recommend mounting the Pico on the [Gravity: Expansion Board](https://www.dfrobot.com/product-2393.html), which breaks out the Pico pins into labelled plug-in ports for Gravity sensor and actuator modules.

You will need:

- A Raspberry Pi Pico or Pico 2 with headers soldered on.
- A Gravity: Expansion Board for Raspberry Pi Pico / Pico 2.
- One or more Gravity modules to connect, for example a push button, an LED, or a photodiode. The [9-piece](https://www.dfrobot.com/product-110.html) and [27-piece](https://www.dfrobot.com/product-725.html) Gravity sensor sets are a convenient starting point.
- A micro USB cable to connect the Pico to your computer.

To assemble it:

1. Plug the Pico into the headers on the expansion board, with the USB connector facing the edge of the board as marked.
2. Plug each Gravity module into the port for the pin you want to use. The tutorials name the pin for each module, for example analog input `0` on `GP26`.
3. Connect the Pico to your computer over USB.

> [!NOTE]
> The links above are provided as a reference only. The Harp project is not affiliated with the suppliers listed.

With the hardware assembled, continue to [Getting Started](hobgoblin-setup.md) to install the software and flash the firmware.
