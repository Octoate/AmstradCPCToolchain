AmstradCPCToolchain
===================

The "Amstrad CPC Toolchain" is a linux development environment for the Amstrad
CPC homecomputer based on various tools which are available on the internet. It
aims to be simple to install and also simple to use.
Another aim is that you do not need an installation of the tools.

Installation
============

Just type "make" in the main directory and it will download the latest versions
of the tools and compile them. To clean-up the whole toolchain, just type "make
distclean". This will remove all compiled binaries and the downloaded files.
A "make clean" will just delete the compiled files within the "bin" directory.

Directory structure
===================

```
*
|_bin 		- contains binary executeables of the needed tools
|_downloads 	- contains the downloaded versions of the different tools
|_src 		- put the sourcecode of your program here
|_tools 	- extracted files of the (downloaded) tools (the tools will be
		  compiled here)
```

Help
====

You want to help this small project: Great! Fork this repository, add your tool to the "Makefile" and send a pull request. Or just send in your suggestions.

TODO
====
- add the AFT2 tool to transfer DSKs / files via the CPC Booster
- add the dsktools to directly write DSK images to a floppy disk
- write examples to show the usage of the tools
- find a good and easy to use emulator for Linux


2012 Octoate / Tim Riemann
http://www.octoate.de
