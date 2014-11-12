# Distributed Wavelet Transform for Wireless Sensor Networks: TinyOS Implementation

**Author:** J. Ryan Stinnett (<jryans@rice.edu>)
DSP Group, Rice University

## Overview

This project implements data compression for wireless sensor networks
(WSNs) by using a distributed wavelet transform. This compression system
lowers the number of devices which need to transmit data to a base
station, and thus reduces power consumption and increases the average
lifetime of the network.

## Implementation

Code running on the WSN devices, or "motes", was written in nesC for TinyOS and
tested on Crossbow's MicaZ platform. Before working on the transform itself, I
created several components that provide essential system services. The first of
these was a suite of networking components. As the focus of this project is not
on routing protocols, I opted for simplicity by using basic broadcast and
unicast protocols. The broadcast protocol waits for packets with a sequence
number larger than the last sequence number received, and then repeats those
new packets a set number of times. The unicast protocol uses a static routing
table to determine the next hop for a given packet.

Above these protocols, I built a multi-packet fragmentation and reassembly
service. It allows for bidirectional communication of any data size. TinyOS 1.x
uses a fixed data length of 29 bytes, so expanding beyond this limit in a
reusable manner simplifies code significantly. By using small descriptor
records, this system can even rebuild data structures that use pointers or
variable-length arrays. These techniques were used to send the initial wavelet
transform parameters to the motes and also to request statistical data from
the motes about network traffic.

The distributed wavelet transform<sup>[[1](#ref1)]</sup> is the core application
running on top of these and other standard TinyOS system services. Currently
only a spatial transform across the mote network has been implemented, but a
transform in the time domain will be added soon. To ensure that each mote runs
each scale of the transform at the same time, a finite state machine with
fixed-length delays between each state is used. The scheme assumes clock
synchronization between motes. A clock synchronization protocol specific to WSNs
has already been proposed.<sup>[[2](#ref2)]</sup>

To achieve data compression, each mote compares its value against a list of
target values from the sink, which are arranged in decreasing order. Each mote
compares its results from the current round of the wavelet transform with the
target values. The first target value that is less than the result value
determines the transmission band. Each mote assigned to a specific band
transmits its data back to the sink at roughly the same time. When the sink
determines it has received enough values to reconstruct a good approximation of
the original data, it broadcasts a stop message to prevent further bands from
being transmitted. This message also includes updated target values that will
be used during the next transform round.

For the sink node, I created a variety of support tools in both Java and MATLAB.
It took several revisions to design a good scheme for mote communication in Java
that could support all of the various system tools as well as the wavelet
transform itself. With that in place, these tools simply try to provide a
logical user interface to the various options and functions of the motes.

## Challenges

Though there are many things I learned while working on this project, what stood
out in my mind the entire time was the importance of thoroughly debugging code
and including as many tests and checks to ensure proper operation. When writing
code that runs purely on modern PCs, it is easy to be sloppy about such things
because you can always attach a debugger and resolve the issue. When working
with the motes, you can't debug code directly on the motes themselves. Also,
they are dependent on messages from other devices, so inspecting the code on one
device may not be enough to see the whole issue. Luckily, TinyOS includes
TOSSIM, which can simulate an entire mote network on a PC. This tool has helped
resolve bugs countless times.

When I started working on the multi-packet transmission system, I quickly
discovered that my understanding of pointers in C needed improvement. I found
great tutorials online that helped me grasp the relationship between pointers
and arrays, without which I doubt I could have gotten the system to work at
all. It is this relationship that I exploited to rebuild hierarchical data
structures from a simple data stream.

To verify good network operation, we wanted to capture various metrics about the
messages that pass through each mote. One of these metrics is the median of
the received signal strength. Ordinarily, one would need to store every
measurement to find the median, but that is not a practical on these motes with
such limited memory. I originally tried to use the mote's flash storage to hold
all the values, but that became too complex for such a simple question. Instead,
I used a compact technique for estimating the median from only a few
values<sup>[[3](#ref3)]</sup>, which can remain entirely in memory.

Another issue I encountered was with sensor values that would intermittently be
far larger than was even possible for the sensor itself. After looking more
closely at documentation, I found that on the MicaZ, one of the sensors shares
an interrupt line with the radio. If a packet is received while trying to read
this sensor, its value will be corrupted. This issue itself would have been easy
enough to work around, but it was compounded by conflicting files in the TinyOS
tree I was using, which prevented the correct system files from being used.

Overall, this project has given me extensive, hands-on experience with the
difficulties of embedded development. While the problems are often very
frustrating at times, there is always a solution to be found if you look hard
enough.

## References

1.  <span id="ref1"></span>R. Wagner, R. Baraniuk, S. Du, D.B. Johnson,  
    and A. Cohen. An Architecture for Distributed Wavelet Analysis and
    Processing in Sensor Networks. In *Proceedings of the Fifth
    international Conference on information Processing in Sensor
    Networks* (Nashville, Tennessee, USA, April 19 - 21, 2006). IPSN
    '06. ACM Press, New York, NY, 243-250.
    ([pdf](http://www.ece.rice.edu/%7Erwagner/ipsn06.pdf) |
    [ps](http://www.ece.rice.edu/%7Erwagner/ipsn06.ps))
2.  <span id="ref2"></span>S. PalChaudhuri, A.K. Saha, and D.B. Johnson.
    Adaptive Clock Synchronization in Sensor Networks. In *Proceedings
    of the Third international Symposium on information Processing in
    Sensor Networks* (Berkeley, California, USA, April 26 - 27, 2004).
    IPSN '04. ACM Press, New York, NY, 340-348.
    ([pdf](http://monarch.cs.rice.edu/monarch-papers/ipsn2004.pdf))
3.  <span id="ref3"></span>R. Jain and I. Chlamtac. The P2 algorithm for
    dynamic calculation of quantiles and histograms without storing
    observations. *Commun. ACM* 28, 10 (Oct. 1985), 1076-1085.

## Future Plans

While data compression using the wavelet transform is complete, there
are still many features and improvements that could still be added. A
summary of the most important of these follows:

-   Time domain transforms for further compression
-   Separate wavelet core from system services for reuse
-   Rework networking systems to save resources and improve
    compatibility with other routing protocols
-   Support any number of abstract inputs, instead of two fixed sensors  
-   Make Java objects easier to call from within MATLAB

## Recognition

I never would have been able to complete this project with the advice
and support from [Ray Wagner](http://www.ece.rice.edu/~rwagner/) and
[Dr. Baraniuk](http://www.ece.rice.edu/~richb/), as well as numerous
others. Thanks again for all the help!
