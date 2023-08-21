# Getting started

The process to set up your system to be able to use the Bonsai.Harp package is simple, and documented in the next few steps:

1 - Install Bonsai (if not already installed) by following the instructions available [here](https://bonsai-rx.org/docs/articles/installation.html).

2 - Install the FTDI drivers necessary for the USB communication between Harp device and the host PC. For Windows, these can be found [here](https://www.ftdichip.com/old2020/Drivers/CDM/CDM%20v2.12.26%20WHQL%20Certified.zip).

3 - Download the latest release of Bonsai.Harp package through the Bonsai Package Manager. [Detailed instructions can be found here](https://bonsai-rx.org/docs/articles/packages.html)

4 - Install the device specific package for the Harp device you are using. To achieve this, change `package source` to `nuget.org`. In the search bar, look for your device by typing: `harp.<device>`. For instance, for the Harp Behavior board, you would get:

![HarpDevicePackage](~/images/../../../images/behaviorpackage.png)

5 - The device nodes should now be available in the Bonsai Toolbox. You can now start using them in your workflows.