---
title: 'Arch Linux: An Overview'
author: William Osler
date:   January 28, 2016
theme:  m
logo:   logo.pdf
defcolor:
  -
    name: ArchBlue
    rgb: 23,147,209
  -
    name: ArchGray
    rgb: 77,77,77
  -
    name: DarkerGray
    rgb: 44,44,44
setcolor:
  -
    type: normal text
    fg: white
    bg: ArchGray
  -
    type: alerted text
    fg: ArchBlue
    bg: white
  -
    type: frametitle
    fg: ArchBlue
    bg: DarkerGray
links-as-notes: true
---

## Disclaimer

The views expressed in this presentation are my own, and are not endorsed by or
affiliated with Arch Linux.

. . .

(I have to put this in here to use the logo, and it's a really cool logo.)

## Disclaimer

This presentation is purely informational. No guarantees are made that the
content within is complete or free from error. Any instructions given in this
presentation are followed at your own risk. The presenter is not liable for any
loss of data, damage to hardware, injury of persons, injury of mood, depression,
hair loss, war breaking out, your cat dying or anything else.

. . .

(I have to put this in here to not be sued, and not being sued is really cool.)

# Overview

## What is Arch Linux?

*Arch Linux* is "a lightweight and flexible Linux® distribution that tries to
Keep It Simple."

## Guiding Principles
- *simple* - Packages made available to Arch have few modifications from
  upstream
- *modern* - Packages stay up to date and aim for the most recent stable version
- *pragmatic* - Arch aims to favor practical arguments and developer consensus
  over ideological concerns
    - Arch Linux repositories contain nonfree software, for an alternative see
      [Parabola GNU/Linux-libre](https://www.parabola.nu/)

## Guiding Principles
- *user centric* - Arch is largely driven by its own userbase rather than
  attempting to appeal to as many people as possible
- *versatile* - Arch lets you make choices about how to build your system from
  the ground up

## Why Arch?
- Packages are updated frequently, you get new features soon after they come out
- Arch lets you build a system tailored to your needs
- Access to a large number of third party packages from the Arch User Repository
    - Arch makes it easy to package software with `mkpkg` and `pacman`
- A great learning experience for seeing what makes a Linux distro tick
- The [Arch Wiki](https://wiki.archlinux.org/) has pretty good documentation

## Why Not Arch?
- Frequent updates mean things break sometimes
- Frequent updates mean lots of downloading
- It takes some work
- You aren't comfortable with the command line or text editing
- You hate systemd

## A Note About Gentoo
Lots of people draw comparisons between Arch Linux and Gentoo Linux. While they
both have a very similar built-from-the-ground-up approach, Gentoo focuses far
more on user choice and control (choice of init system, USE flags) and is source
based. Arch is binary based and chooses systemd.

# Installing Arch

## Installation Overview

Arch has no installer, just some helpful scripts and a guide. You will run the
commands yourself to set everything up. It's scary the first time, but you'll
get the hang of things pretty quickly.

The steps are:
1. Prepare the install image
2. Boot into the installer
3. Set up the network
4. Set up the disks
5. Install packages
6. Configure the system

## Following Along

If you plan on installing yourself, I highly recommend reading the [Arch Wiki's
Beginner guide](https://wiki.archlinux.org/index.php/Beginners'_guide). Most of
the content from the following slides comes from this page.

## Dual Booting

If you plan to dual boot with another operating system (like Windows), there are
some things you need to be careful about. This talk will not cover these in
detail.

If using Windows, make sure:
- You set up your bootloader to properly detect Windows
    - This means using a UEFI bootloader for Windows 8 and 10
- You have enough free space on the disk (shrink the partition from Windows, pay
  very close attention when partitioning during the install
- Disable fastboot on Windows if you plan to access your Windows disk on Linux

## UEFI and BIOS

The traditional way of booting a system, sometimes referred to as BIOS booting,
is where the system reads code from the start of the disk and starts running it.

A newer method found on modern machines called *UEFI* uses a FAT partition on
the system to load executables. It has a few more features that make it nice but
can be more difficult to set up. Most UEFI capable systems are also capable of
the traditional style booting.

## Ways to Install

There are plenty of different ways to install Arch, including
- Via a disk
- Via a flash drive
- Over the network
- From an existing Linux Distribution

This talk will mostly be covering the first two, but there's a lot of overlap in
steps. Check the Arch Wiki.

## Downloading the install image

Arch Linux is *rolling-release*.
- It has no official version number and releases packages as they updates are
  available
- Compare this to Ubuntu, which releases a new version every 6 months

You can download a snapshot of the Arch install image (generated monthly) from
https://archlinux.org/download/.

## Preparing the image

Use your favorite disk burning program to burn to disk, or with a USB stick:

    sudo dd if=archlinux-2016.01.01-dual.iso \
      of=/dev/your-flashdrive
    sync

*NOTE:* Be **VERY CAREFUL** when making sure you're writing to the flash drive
and not some other disk.

## Booting into the installer

If you have a UEFI computer (Windows 8 or 10), you will need to disable
SecureBoot. This has probably already been done by you if you've installed Linux
on the machine before. Instructions vary by machine.

Insert the disk or flash drive and boot into it. This also varies by machine for
no good reason.

## Connect to the internet

Arch downloads a fresh set of packages from the internet, so you'll need to be
connected.

Ethernet: You should be automatically connected  
Wireless: Use the `wifi-menu` to select a network

## Special Case: OSUWireless

1. Use `ip addr` to find the name of your wireless device (looks like 'wlp2s0')
2. Put the following in /etc/netctl/osuwireless:

## Special Case: OSUWireless

\vspace{-0.75cm}
```
Description='OSU Wireless'
Interface=your-wireless-device
Connection=wireless
Security=wpa-configsection
ESSID=osuwireless
IP=dhcp
WPAConfigSection=(
        'ssid="osuwireless"'
        'proto=RSN'
        'key_mgmt=WPA-EAP'
        'eap=PEAP'
        'phase2="auth=MSCHAPV2"'
        'identity="name.#"'
        'password="YOUR PASSWORD HERE"'
)
```

## Special Case: OSUWireless
1. Use `ip addr` to find the name of your wireless device (looks like 'wlp2s0')
2. Put the following in /etc/netctl/osuwireless
3. `sudo netctl start osuwireless`
4. Before you reboot, copy this file to the installed system's `/etc/netctl`

## Update Your Clock
Updating the system time makes sure that you don't have issues with TLS certs
expiring and that file modification times on the install are correct.

    timedatectl set-ntp true

## Prepare Storage Devices

*WARNING WARNING WARNING*  
If you have any data on the disk you want to keep, BE VERY CAREFUL! The
following examples will *wipe the entire disk*.

For a dual boot setup, I recommend you use a graphical tool like gparted or the
Windows Disk Manager to first make free space.

## Partitioning

The system disk will need to be *partitioned* so that Arch has a place to store
all its files.

Partitioning takes a disk and breaks it up into fixed sections. Each section
stores data that is isolated from the other sections (partitions).

For our purposes, we'll partition our disk in the following way:
- (If using UEFI) - 1GB EFI System Partition
- 1GB boot partition (stores startup files)
- 8GB swap partition (stores hibernation and temporary memory files)
- The rest goes to the root partition (stores everything else)

## Partitioning - GPT vs MSDOS

There are two ways to partition a disk on modern systems, MSDOS and GPT.

*MSDOS* is the original way Windows does things. You can only have a maximum of
4 partitions (but Linux can use **virtual partitions** to get around this).

*GPT* is newer and lets you use more partitions. It is required if you are using
UEFI to boot.

If you are dual booting with Windows, you must use MSDOS if you don't boot
Windows in UEFI mode. You must use GPT if you boot Windows in UEFI mode.

For this presentation, I'll show a MSDOS traditional boot.

## Partitioning with fdisk

1. Find your disk: `lsblk`
    - This will show you a description of the current state of your disks
    - Find the one that has the correct size, will probably be /dev/sd[letter]
2. Partition the disk: `fdisk /dev/sd[letter]`

`fdisk` is an interactive tool for setting the disk up.

## Partitioning with fdisk

If you want to start fresh (*WARNING*: This will wipe ALL DATA on the disk!),
use the command `o` for a new DOS partition table, or `g` for a GPT partition
table. Use `p` to show the current state of the disk.

. . .

Create a new partition with `n`. Enter a partition number (or hit enter to
select the next available number). Hit enter again to let fdisk automatically
select the first sector. Specify the size. Since we're starting with the boot
partition, we want 1GB, so enter `+1G`.

. . .

Do this again, but with `+1G` for the EFI system partition (if UEFI), `+8G` for
the swap, and for the final disk hit enter at the size prompt to fill the whole
remaining space.

## Partitioning with fdisk

Every partition has a *partition type*. When using fdisk, it automatically
assigns the type "Linux filesystem" to each partition created. We need to change
this for the swap partition and, if using UEFI, the EFI system partition.

Note: types codes are different between GPT and MSDOS!

. . .

Use `t` to change the type of the partition. In this case, if using UEFI you
want to change partition 1 to type "EFI System". Use `L` to list all types and
their codes. In this case, type `1` to set the type to EFI System.

Do this again with partition 2 (3 if UEFI) and set the type to Linux Swap (`19`
GPT or `82` MSDOS)

## Partitioning with fdisk

If booting traditionally, you need to mark your boot partition as bootable so
that the BIOS can find it. Use the `a` command and mark partition 1 as bootable.

## Partitioning with fdisk

Use `p` once more to check that everything looks correct. Use `w` to make the
changes final.

*WARNING*: `w` writes the changes to disk and will destroy the old partitions
and all their data! Be very careful!

Run `lsblk` again to see all your new partitions.

## Making the filesystems

*Filesystems* describe the format that files are stored on the disk. There are
several types with different strengths and weaknesses, but starting out:

1. The EFI partition **must** be FAT
2. The /boot partition should be either EXT2 or EXT4
3. The root partition (/) should be EXT4
4. The swap partition must be formatted as swap

Use the `mkfs` series of tools to create these filesystems.

## Making the filesystems

(Replace /dev/sda with your device)

UEFI:

    mkfs.vfat -F32 /dev/sda1
    mkfs.ext4 /dev/sda2
    mkswap /dev/sda3
    mkfs.ext4 /dev/sda4

Traditional:

    mkfs.ext4 /dev/sda1
    mkswap /dev/sda2
    mkfs.ext4 /dev/sda3

## Mounting the filesystems

*Mounting* is the process of making a device accessible in the Linux directory
tree so that you can work with the files stored within. We want to set up the
following mounts (MSDOS):

Partition   Mountpoint  Purpose
---------   ----------  -------
/dev/sda3   /mnt/       Root filesystem
/dev/sda2   swap        Hibernation and temporary memory
/dev/sda1   /mnt/boot   Boot files

## Mounting the filesystems

*Mounting* is the process of making a device accessible in the Linux directory
tree so that you can work with the files stored within. We want to set up the
following mounts (UEFI GPT):

Partition   Mountpoint      Purpose
---------   -------------   -------
/dev/sda4   /mnt/           Root filesystem
/dev/sda3   swap            Hibernation and temporary memory
/dev/sda2   /mnt/boot       Boot files
/dev/sda1   /mnt/boot/efi   EFI system partition

. . .

Problem: /mnt/boot and /mnt/boot/efi don't exist yet

## Mounting the filesystems

MSDOS:

    swapon /dev/sda2
    mount /dev/sda3 /mnt/
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot

GPT:

    swapon /dev/sda3
    mount /dev/sda4 /mnt/
    mkdir /mnt/boot
    mount /dev/sda2 /mnt/boot
    mkdir /mnt/boot/efi
    mount /dev/sda1 /mnt/boot/efi

## Installing the base system

Now we grab all the packages that make up the core of Arch Linux and install
them to the disk.

    pacstrap -i /mnt base

You can place other packages at the end of the command to install them as well:

    pacstrap -i /mnt base vim git zsh openssh tmux

## Configuration - fstab

*fstab* is a file that tells Linux where all the filesystems should be mounted
to. The Arch install scripts make it easy to generate an fstab:

    genfstab -U /mnt > /mnt/etc/fstab

I recommend double checking this file to make sure it looks sane.

## Configuration - chroot

*chroot* is a Linux tool that redefines the root (/) of the system. For example,
if we set up a chroot with `/mnt/` and ran `/bin/zsh` in the chroot, we would
actually be running `/mnt/bin/zsh`.

Effectively, this lets us do things in the OS without having to boot into it.

    arch-chroot /mnt /bin/bash

## Configuration - Locale
The *locale* defines things like the system language, date formats, currency
etc.

With your favorite text editor (vi if you know it, nano otherwise) edit
`/etc/locale.gen`. Find the line with `en_US.UTF-8 UTF-8` and uncomment it. Then
to generate the locale and set it as the default:

    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf

## Configuration - Timezone
Use tzselect to find your timezone (Columbus = America/New_York). Create a
symlink to teach systemd this timezone:

    ln -s /usr/share/zoneinfo/America/New_York \
      /etc/localtime

Update the hardware clock: `hwclock --systohc --utc`

If dual booting with Windows, your time in Windows will appear wrong. See the
[Time](https://wiki.archlinux.org/index.php/Time) article in the Arch Wiki.

## Configuration - Initramfs

The `initramfs` is a special file that helps the Linux kernel boot. Details are
out of scope for this presentation, but you need this:

    mkinitcpio -p linux

## Boot Loader
. . .

~~Welcome to my special hell~~

## Boot Loader

There are a lot of choices of boot loaders with various ups and downs. I
recommend:

MSDOS: *GRUB*, the GRand Unified Bootloader  
UEFI: *rEFInd*, a graphical UEFI boot manager

