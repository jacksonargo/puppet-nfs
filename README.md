# nfs

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with nfs](#setup)
    * [What nfs affects](#what-nfs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nfs](#beginning-with-nfs)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Overview

This is a puppet module for controlling your nfs mounts and exports. Configure your
mounts and exports with hiera. Tested on rhel, centOS, and ubuntu.

## Module Description

This modules installs the nfs packages and ensures the service is runnng. It uses augeas 
and templates to manage the exports file and the puppet mount resource to manage your mounts.

## Setup

### What nfs affects

* Affects /etc/fstab and /etc/exports.
* Creates all mount points.
* Installs nfs package.
* Configures nfs service.

### Setup Requirements

Requires hiera and merge_deep for mount and export lookups.
Requires augeas for managing exports.

### Beginning with nfs

The simplest use is to install and start the nfs service.

In manfiests/site.pp:

    include nfs

In hieradata/common.yaml:

    nfs::package: nfs
    nfs::service: nfsd

## Usage

This module has one class:

    class { 'nfs' :
        package => # The NFS package to install. Can be an array, e.g. 'nfs'
        service => # The NFS service to run. Can be an array, e.g. 'nfsd'
    }

This module has 1 defined type:

    nfs::export { 'resource title' :
        share   => # The full path of the directory you want to share, e.g. /srv/nfs. Defaults to title.
        clients => # An array of computers to share with, e.g. ['192.168.1.0/24', 'mylaptop']
        options => # An array of options for the share, e.g. ['rw', 'async', 'no_subtree_check']
    }

The nfs class also includes the following optional hiera hashes:

    nfs::exports:          # A hash containing all the nfs::export resources.
    nfs::export_defaults:  # A hash of defaults for the nfs::export resource.
    nfs::mounts:           # A hash containing all the mount resources for you nfs mounts.
    nfs::mount_defaults:   # A hash of defaults for the mount resource.

Example lookups for common.yaml:

    nfs::export_defaults:
        clients:
            - 192.168.1.0/24
        options:
            - ro
            - all_squash
    nfs::exports:
        /srv/myshare:
            clients:
                - mylaptop
            options:
                - async
                - no_subtree_check
    nfs::mount_defaults:
        ensure: present
        fstype: nfs
        dump:   0
        pass:   0
        options: defaults
    nfs::mounts:
        /shared/myserver:
            device: myserver:/srv/nfs

## Reference

The nfs class will create a file resource for each mountpoint to ensure the directories exist.
The nfs::export only touches the /etc/exports file with augueas. It won't replace the file.

## Limitations

Tested with rhel, centOS, and ubuntu. Should work fine as long as you have augeas and merge_deep.

