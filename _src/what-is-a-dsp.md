---
title:  What is a DSP
layout: post
categories: MBED, embedded systems
---

A digital signal processor (DSP) is a specialized computer processor. OK, but
what it means this? Well, we must remember what a general-purpose processor is.
A general-purpose processor transforms data, which is encoded as natural
numbers. As mentioned in [*The Scientist and Engineer's Guide to Digital Signal
Processing*](http://www.dspguide.com/ch28/1.htm), this kind of processor
specializes in moving data around, and testing that data.

On the other hand, a DSP is mainly applied in transforming discrete signal. The
main tool to perform this kind of transformations is the discrete convolution: 

$$y[n]=\sum_{k=0}^{N+1} h[k] x[n−k]$$

where the discrete signal $y$ is called output, the discretes signals $h$ and
$x$ are called inputs, and the natural number $N$ is the order of the
convolution. Some times $h$ is the impulse response of the system. 

The DSP's are designed to perform this operation really fast. In order to
acomplish this, as expressed in [*Embedded C for Digital Signal
Processing*](https://www.doi.org/10.1007/978-1-4614-6859-2_38), a DSP should
have the next features:

- Should perform [fixed-point arithmethic](https://en.wikipedia.org/wiki/Fixed-point_arithmetic),
- Should include a [multiplier-accumulator](https://en.wikipedia.org/wiki/Multiply%E2%80%93accumulate_operation),
- Should perform [zero-overhead loops](https://microchipdeveloper.com/dsp0201:zero-overhead-loops), and
- Should have [separate memories for instructions and data](https://en.wikipedia.org/wiki/Harvard_architecture).

These characteristics allow discrete signals to be represented in the processor,
or easily implement the [discrete convolution](http://www.dspguide.com/ch6.htm), the
[fast Fourier transform](http://www.dspguide.com/ch12.htm) (FFT) and the [axpy
operation](https://www.smcm.iqfr.csic.es/docs/intel/mkl/mkl_manual/bla/functn_axpy.htm)
easily. We will return to them in another time.

# Comparing a DSP with a general-purpose processor

In the following table, we compare the general-purpose processor with the
digital signal processor, and, to complement it, with a microcontroller. 

|                                   | General-Purpose Processor | Microcontroller                       | Digital Signal Processor  |
|-----------------------------------|---------------------------|---------------------------------------|---------------------------|
| Main application                  | Searching and ordering    | Controlling Peripherals               | Convolution and axpy      |
| Typical data type                 | Natural numbers (subset)  | Bits                                  | Rational numbers (subset) |
| Fundamental operations            | $A\to B$, $A=B$           | $b\leftarrow 0b0$, $b\leftarrow 0b1$  | $a\leftarrow a\times x+b$ |
| Specialized hardware for loops    | No                        | No                                    | Yes                       |
| Typical memory architecture       | Von Neumann               | Harvard                               | Harvard                   |

Table: Comparison between three different classes of processors: a general-purpose processor, a microcontroller and a digital signal processor.

It is also important to note that there are processors that combine features
from all three classes. For example, the [ATmega328p
microcontroller](http://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf)
also have characteristics of a DSP. Another example is the [Arm Cortex-A53
processor](https://developer.arm.com/ip-products/processors/cortex-a/cortex-a53),
which have features of a general-purpose processor and a DSP.