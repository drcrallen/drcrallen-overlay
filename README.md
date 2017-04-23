# mesos-gentoo-overlay
This overlay contains a WORK IN PROGRESS for some items I've been missing in the gentoo portage upstream.

## Installation - CoreOS
Follow the instructions on [Modifying CoreOS](https://coreos.com/os/docs/latest/sdk-modifying-coreos.html) to create your basic `chroot` evironment. Once you have your basic build system functioning to where you could build an image, you now need to use this overlay to install packages. 

In all examples below, `${THIS_OVERLAY_DIR}` refers to the directory **INSIDE THE CORK ENVIRONMENT** where you have checked out this repository.
### Syncing upstream ebuilds
If the build fails due to [GLSA 201610-05](https://security.gentoo.org/glsa/201610-05) you will need to sync with the portage upstream ebuilds to get a suitable version of `dev-vcs/subversion`. To do this type

```
~/trunk/src/scripts $ ./update_ebuilds dev-vcs/subversion
```

### Installing into existing packaged environment
Mesos can be installed using the `emerge` command specific for the board you are building for. Below is an example of using one for an `amd64-usr` board.

```
PORTDIR_OVERLAY="${PORTDIR_OVERLAY} ${THIS_OVERLAY_DIR}" emerge-amd64-usr --ask --autounmask-write -D =sys-cluster/mesos-1.2.0
PORTDIR_OVERLAY="${PORTDIR_OVERLAY} ${THIS_OVERLAY_DIR}" emerge-amd64-usr --ask -D =sys-cluster/mesos-1.2.0
```
### Generating New Manifest Entries
To generate new manifest entries from within a `cork` use the following command

```
ebuild-amd64-usr ${THIS_OVERLAY_DIR}/sys-cluster/mesos/mesos-${MESOS_VERSION}.ebuild manifest
```

# Packages
## `sys-cluster/mesos`
Mesos is a fantastic cluster resource 2-stage scheduler. It operates on resource offers rather than from a centralized scheduling mechanism. See https://github.com/apache/mesos/blob/master/3rdparty/cmake/Versions.cmake on the relevant release tag for library dependency information.

# NOTE
There are a lot of patches under https://github.com/apache/mesos/tree/master/3rdparty which this overlay does **NOT** take into account. At the time of this writing most of the patches for 3rd party libraries in Mesos are for better WIN32 support. But caveat-emptor because this is still very much a work in progress.
