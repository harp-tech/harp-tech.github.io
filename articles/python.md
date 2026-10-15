---
uid: python
---

## Python

The Harp Python package provides an interface to Harp devices and their recorded data, implementing the [Harp binary protocol](https://harp-tech.org/protocol/BinaryProtocol-8bit.html). It can be used for both controlling Harp devices as well as loading data.

This project includes four main packages:

 - **harp-protocol**: Implements the Harp binary protocol in Python, with registers, messages, and payload parsing.

 - **harp-device**: Implements the transport-agnostic `Device` interface and the core register set.

 - **harp-serial**: Connects to a `Device` over a serial COM or tty port.

 - **harp-data**: Reads logged register files into pandas DataFrames.

For more information, check out the official package [documentation](https://harp-tech.org/python/).