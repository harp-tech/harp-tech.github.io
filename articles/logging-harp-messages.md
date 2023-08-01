# Logging

As any other device that is used to record and control an experiment, data streams from `Harp Devices` can also be easily logged in real time.
In the case of `Harp Devices`, the decision as to what to log is somewhat easy. Since all the communication between the peripheral and the host is made via `Harp Messages`, these are the only piece of information one would need to reconstruct the state of the experiment (as seen by the `Harp device` at least) at any given point in time.
Moreover, since `Harp Messages` follow a simple binary protocol, they can be efficiently (both in time and space) logged into disk using a simple flat binary file. The next sections will cover how one can achieve this, and what the current best practices are for logging data streams from `Harp Devices`.


---


## Logging the full stream of `Harp Messages` from a `Harp Device`

Since the `Harp` is a binary protocol, any `Harp Message` can be logged by simply saving its raw binary representation. The binary representation (as a `byte[]`) can be accessed via the `MessageBytes` member. Finally, to log the raw binary stream, use a [`MatrixWriter`](xref:Bonsai.Dsp.MatrixWriter) node. Alternatively, the `Bonsai.Harp` package also provides a [`MessageWriter`](xref:Bonsai.Harp.MessageWriter) operator that replicates the previous pattern:

:::workflow
![LogAllMessages](~/workflows/log-all-messages.bonsai)
:::

Since the logging takes place on top of any `Harp Message` stream, the writers can also be used to: log multiple devices in parallel, log filtered streams (e.g. after applying [`FilterRegister`](xref:Bonsai.Harp.FilterRegister)) or even save host-generated commands (e.g. after a [`CreateMessage`](xref:Bonsai.Harp.CreateMessage)).

---

## Logging using a `Demux` pattern

While logging all `Harp Messages` to a single binary is certainly possible, it is not always the most convenient way to log data. For instance, if one is interested in logging only a subset of the `Harp Messages` (e.g. only the `ADC` messages), then the previous approach would require a post-processing step to filter out the messages of interest. Moreoever, each address has potentially different data formats (e.g. `U8` vs `U16`) or length. As a result, while parsing a binary file, the user will have to read and parse a single message at a time. Alternatively, one can use a `Demux` pattern to log the `Harp Messages`, from different addresses, into separate files. This way, one can ensure that all messages on a single file have the same format and length and can thus be read and parsed in one pass.

A possible implementation of this pattern is shown below:

:::workflow
![LogDemux](~/workflows/log-demux.bonsai)
:::

The single-register log files can then be loaded using the following Python routine:

```Python

import numpy as np
import pandas as pd

_SECONDS_PER_TICK = 32e-6
_payloadtypes = {
                1 : np.dtype(np.uint8),
                2 : np.dtype(np.uint16),
                4 : np.dtype(np.uint32),
                8 : np.dtype(np.uint64),
                129 : np.dtype(np.int8),
                130 : np.dtype(np.int16),
                132 : np.dtype(np.int32),
                136 : np.dtype(np.int64),
                68 : np.dtype(np.float32)
                }

def read_harp_bin(file):

    data = np.fromfile(file, dtype=np.uint8)

    if len(data) == 0:
        return None

    stride = data[1] + 2
    length = len(data) // stride
    payloadsize = stride - 12
    payloadtype = _payloadtypes[data[4] & ~0x10]
    elementsize = payloadtype.itemsize
    payloadshape = (length, payloadsize // elementsize)
    seconds = np.ndarray(length, dtype=np.uint32, buffer=data, offset=5, strides=stride)
    ticks = np.ndarray(length, dtype=np.uint16, buffer=data, offset=9, strides=stride)
    seconds = ticks * _SECONDS_PER_TICK + seconds
    payload = np.ndarray(
        payloadshape,
        dtype=payloadtype,
        buffer=data, offset=11,
        strides=(stride, elementsize))

    if payload.shape[1] ==  1:
        ret_pd = pd.DataFrame(payload, index=seconds, columns= ["Value"])
        ret_pd.index.names = ['Seconds']

    else:
        ret_pd =  pd.DataFrame(payload, index=seconds)
        ret_pd.index.names = ['Seconds']

    return ret_pd

```