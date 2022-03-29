# meta-quectel-community

This README file contains information on the contents of the
quectel-community layer.

Please see the sections below for details.

## Dependencies

This layer depends on:

 URI: git://git.openembedded.org/bitbake
 branch: master

 URI: git://git.openembedded.org/openembedded-core
 layers: meta
 branch: master

## Patches

Please submit any patches against the quectel-community layer to the
meta-quectel-community project repositoy on GitHub.

Repository: https://github.com/Quectel-Community/meta-quectel-community

## Table of Contents

1. Adding the quectel-community layer to your build
2. About This Layer
3. Using the PPPd scripts

# 1. Adding the quectel-community layer to your build

In order to use this layer, you need to make the build system aware of
it.

Assuming the quectel-community layer exists at the top-level of your
yocto build tree, you can add it to the build system by adding the
location of the quectel-community layer to bblayers.conf, along with any
other layers needed. e.g.:

```
BBLAYERS ?= " \
  /path/to/yocto/meta \
  /path/to/yocto/meta-poky \
  /path/to/yocto/meta-yocto-bsp \
  /path/to/yocto/meta-quectel-community \
  "
```

# 2. About This Layer

This layer adds kernel modifications to support the following Quectel 
hardware: 

* EC25 LTE Module

Once the Linux Kernel adds support for a module it can be removed from 
this layer.

This layer also adds a set of three Point-to-Point Protocol daemon 
scripts which allow the use of a `pppd call questel-ppp` command.  Both 
these scripts and the kernel modifications are based on instructions 
provided by the Quectel WCDMA&LTE Linux USB Driver User Guide.

This layer is not produced or supported by Quectel.  It is developed by
users of Quectel hardware who wish to add support to Yocto systems.
Initally the development focuses on supporting the hardware under a 
Raspberry Pi 3.

# 3. Using the PPPd scripts

Once your Quectel hardware is connected and the appropreate USB driver 
is associated with it you can initiate a call with: 

```
pppd -E call quectel-ppp
```

Before using the script you will need to set the appropriate Access
Point Name (APN), Username and Password for your LTE network
connection.  To do this set `LTE_APN`, `LTE_USERNAME` and
`LTE_PASSWORD` environment variables before calling the pppd script
with the `-E` option.
