Sos
===

Simple Operating System for educational purposes

This is a playground which hosts code for a simple operating system.
In this project I aim to learn how operating systems work by building
one for myself.

Originally, the work was started in BeagleBoard rev.c3, which has TI
OMAP3550 processor. However, due to the difficulties in
compiling/linking/flashing/running/debugging cycle in BeagleBoard, the
development mostly occurs in emulated RealviewPB platform.

Building
========
The code is structed into project, target, platform, and arch. You can
build the kernel by invoking ``make <project>`` where ``project`` is one
of the projects in project/ directory. For example, to build for
realview-pb platform, use ``make realview-pb-test``

Using local.mk
--------------
If you are building for the same platform again and again, you can
define the project in ``local.mk`` file by putting;

``PROJECT := realview-pb-test``

The build system reads local.mk and runs accordingly. After putting the
project information, ``make`` can be invoked alone.

Turning compilation output
--------------------------
You can turn the compiler output by putting the following in your
local.mk;

``NOECHO := ``

Supported Versions
==================
Currently, **ARMv7** is supported. I do not have a legacy concern for now so
make sure that you have ARMv7 chip. As this project is for educational
purposes, legacy support for older chips is not a main concern.
[LK][1] has support for older chips but I removed the legacy part for
clean and consistent code. If you are curious about adding a support for
your board or chip, please feel free to send patches.

Apart from the CPU architecture, supported boards are:
* BeagleBoard rev.c3
* Realview-PB

Acknowledgement
===============
The build system was written by Travis Geiselbrecht (geist). It is also
used in [Little Kernel][1]. Sos is highly
inspired by lk for both project structure and startup code. Thanks for
[geist][2], and #osdev for all their help.

[1]: http://github.com/travisg/lk
[2]: http://github.com/travisg
