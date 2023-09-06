Getting Started with Bonsai - Harp
==================================

All [Harp Devices](https://harp-tech.org/Devices/device_list.html) implement the [Harp Protocol](https://harp-tech.org/About/How-HARP-works/index.html) to communicate with an host PC. The `Bonsai.Harp` library provides an implementation of the Harp protocol that can be used to interface with any Harp device.

## Pre-requisites

1. [Bonsai](https://bonsai-rx.org)
2. [FTDI D2XX Drivers](https://ftdichip.com/wp-content/uploads/2021/08/CDM212364_Setup.zip)

## How to install

The latest release of the Bonsai.Harp can be downloaded and installed through the Bonsai package manager (see [here](https://bonsai-rx.org/docs/articles/packages.html) for details on how to install Bonsai packages). We also recommend installing the `Bonsai.Harp.Design` package which provides useful additional functionality such as dialogs for updating device firmware and visualizers.

## Device specific packages

A high-level interface will usually be available for the specific Harp device you are using. To install them, first change the package manager **Package source** to `nuget.org`. Then, in the search bar, look for your device by typing: `harp.<device>`. For instance, for the Harp Behavior board, you should find the following package:

![HarpDevicePackage](~/images/behaviorpackage.png)

The device nodes should now be available in the Bonsai Toolbox. You can now start using them in your workflows.