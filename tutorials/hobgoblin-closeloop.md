# Close-Loop Systems

The exercises below will help you become familiar with using the [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin) device for close-loop experiments. You will also learn how to use the [Harp Hobgoblin](https://github.com/harp-tech/device.hobgoblin) to interface with external cameras. Before you begin, it is recommended that you review the Bonsai [Acquisition and Tracking](https://bonsai-rx.org/docs/tutorials/acquisition.html) tutorial, which covers key video concepts.

## Close-loop latency
In a closed-loop experiment, we want the behaviour data to generate feedback in real-time into the external world, establishing a relationship where the output of the system depends on detected sensory input. Many behavioural experiments in neuroscience require some kind of closed-loop interaction between the subject and the experimental setup. 

One of the most important benchmarks to evaluate the performance of a closed-loop system is the latency, or the time it takes for a change in the output to be generated in response to a change in the input. The easiest way to measure the latency of a closed-loop system is to use a digital feedback test. 

In this test, we measure a binary output from the closed-loop system and feed it directly into the input sensor. We then record a series of measurements where we change the output to `HIGH` if the sensor detects `LOW`, and change it to `LOW` if the sensor detects `HIGH`. The time interval between `HIGH` and `LOW` signals will give us the total closed-loop latency of the system, also known as the round-trip time. 

Before begining, set up the `Hobgoblin` with the following `device pattern` that we learned about in the previous tutorial.

:::workflow
![Hobgoblin Device Pattern](../workflows/hobgoblin-closeloop-devicepattern.bonsai)
:::