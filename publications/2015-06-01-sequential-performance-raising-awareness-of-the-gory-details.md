---
title: Sequential Performance":" Raising Awareness of the Gory Details
authors: Erven Rohou and David Guyon
abstract: The advent of multicore and manycore processors, including GPUs, in the customer market encouraged developers to focus on extraction of parallelism. While it is certainly true that parallelism can deliver performance boosts, parallelization is also a very complex and error-prone task, and any applications are still dominated by sequential sections. Micro-architectures have become extremely complex, and they usually do a very good job at executing fast a given sequence of instructions. When they occasionally fail, however, the penalty is severe. Pathological behaviors often have their roots in very low-level details of the micro-architecture, hardly available to the programmer. We argue that the impact of these low-level features on performance has been overlooked, often relegated to experts. We show that a few metrics can be easily defined to help assess the overall performance of an application, and quickly diagnose a problem. Finally, we illustrate our claim with a simple prototype, along with use cases.
link: https://hal.inria.fr/hal-01162336
description: Paper on how to detect bad use/behavior of a CPU thanks to an extension of the hwlock software
conference: International Conference on Computational Science, Reykjavik, Iceland
---
