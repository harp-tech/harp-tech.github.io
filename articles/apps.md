# Apps

The Harp ecosystem includes desktop applications with graphical user interfaces for working with devices directly.

![Harp Behavior GUI](~/images/behavior-gui.png)

## Installing apps

[Harp Regulator](https://github.com/harp-tech/regulator) is a cross-platform launcher for Harp device configuration tools. Each Harp device repository publishes its graphical configuration tool as a .NET tool package on NuGet. Regulator lists the serial ports on your computer, identifies the Harp device connected to each one by reading its `WhoAmI` register, installs the matching tool on demand, and launches it. One launcher covers every device, so you do not need to track down the right tool for each board yourself.

Installers for Windows, Linux, and macOS are available from the [releases page](https://github.com/harp-tech/regulator/releases). Harp Regulator is open source under the MIT license.
