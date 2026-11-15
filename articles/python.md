---
uid: python
---

# Harp Python

Harp Python is the Python implementation of the Harp protocol. It connects to Harp devices over a serial port and reads recorded data into pandas data frames.

The implementation is split into four packages, so a project can install only the part it needs:

- `harp-protocol` implements the Harp binary protocol, with registers, messages and payload parsing.
- `harp-device` implements the device interface independently of the transport, together with the core register set.
- `harp-serial` connects to a device over a serial port.
- `harp-data` reads logged register files into pandas data frames.

The `harp` package installs all four:

```sh
pip install harp
```

The [Harp Python documentation](https://harp-tech.org/python/) covers installation options, examples and the API reference for each package.

> [!Note]
> Harp Python replaces the `harp-python` package, which only read recorded data. The [migration guide](https://harp-tech.org/python/articles/harp-python-migration/) shows how each `harp-python` workflow maps to `harp-data`.
