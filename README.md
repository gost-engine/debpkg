Debian packaging files for gost-engine
======================================

This repository contains supplemental files
and Makefile to build debian package for gost engine.

This is intened for Debian 9 (stretch) and newer, which ships
openssl 1.1.0 and above.

I prefer keep packaging files separately from main source tree.

Running make in this directory should fetch engine sources and build
debian package (both source and binary for current architecture).

You need git,  build-essential and devscripts installed before running.
All other are listed as Build-Depends prerequesites and should they be
absent, they would be reported during installation.

