---
title: 'Arch Linux: An Overview'
author: William Osler
date:   January 28, 2016
theme:  metropolis
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
cc-by: true
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

## Boot Loader - GRUB

GRUB is installed to a section of the disk called the MBR, that the BIOS
executes when it first starts up. GRUB then loads config files from the boot
partition and lets you select an operating system to boot.

    pacman -S grub os-prober
    grub-install --recheck /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg

And hope everything Just Works(tm)

## Boot Loader - rEFInd

rEFInd is a *boot manager* that gives you a graphical menu that lets you select
different UEFI executables and boot loaders. rEFInd is capable of autodetecting
many types of already installed operating systems.

- Technically, rEFInd is not a boot loader. The Linux kernel itself is a valid
  UEFI executable and capable of booting itself, rEFInd just manages this
  process

```
pacman -S refind-efi
refind-install
```

And hope everything Just Works(tm)

## Special Case: Things didn't Just Work(tm)!

See the Arch Wiki for common issues.

## Configuration - Network

Set the hostname. Do something creative!

    # Not creative
    echo 'green' >> /etc/hostname

Ethernet:
- Enable DHCP by default: `sudo systemctl enable dhcpcd@interface.service`,
  where interface is the name of the interface (check `ip addr`)

Wireless:
- Install the tools for wifi-menu: `pacman -S iw wpa_supplicant dialog`
- Install any wireless drivers (Check the Wiki)

## Configuration - Root Password
Set the root password:

    passwd

## Configuration - Create an (admin) User
You probably don't want to do everything as root. Create a user for yourself:

    useradd william
    mkdir /home/william
    chown william:william /home/william
    passwd william
    gpasswd -a william wheel
    EDITOR=nano visudo

And uncomment the line:

    %wheel ALL=(ALL) ALL

## Configuration - Exit Chroot

Type `exit` to leave the chroot. If you're on OSU Wireless, copy your
`/etc/netctl/osuwireless` config to `/mnt/etc/netctl/osuwireless`.

## Unmount the target

`sudo umount -R /mnt`

## Reboot

`reboot`

. . .

And pray

## Reboot

![OH MY GOD DO I PRAY](./ohmygoddoipray.png){width=3.5in}

## Congratulations

You are now an Arch Linux user.

. . .

~~Proceed to reddit to brag about how much a 1337 hax0r you are~~

# Graphical Environments

## Setting up a Graphical Environment

After rebooting, you may notice that you're still in a text environment. Arch
lets you choose which desktop applications you want.

. . .

You'll need to install a few things or order to get started with graphical
applications

## Display Drivers

You need graphics drivers specific to your hardware. In the case of AMD and
NVIDIA, you have a choice between proprietary and open source graphics.

Install the corresponding package(s):

Hardware    Proprietary         Open Source
----------- ------------------- ------------------
AMD         catalyst (AUR)      xf86-video-ati
NVIDIA      nvidia nvidia-libgl xf86-video-nouveau
Intel       N/A                 xf86-video-intel

If you have a touchpad, install `xf86-input-synaptics`

## Desktop Environments

You can install large sets of related programs, called *desktop environments*,
or mix and match applications to make your own setup.

## Desktop Environments - GNOME
`pacman -S gdm gnome gnome-extra`

![GNOME](./gnome-screenshot.png){width=4in}

## Desktop Environments - KDE
`pacman -S sddm plasma-meta`

![KDE](./kde-desktop.png){width=3.75in}

## Desktop Environments - LXDE
`pacman -S lxdm lxde`

![LXDE](./lxde-screenshot.png){width=3.125in}

## Desktop Environments - Cinnamon
`pacman -S gdm cinnamon`

![Cinnamon](./cinnamon-desktop.png){width=4in}

## Desktop Environments - XFCE
`pacman -S lxdm xfce4 xfce4-goodies`

![XFCE](./xfce-desktop.jpg){width=4in}

## Desktop Environments - And More!

There are tons of others. Officially:
- Deepin
- GNOME Flashback
- LXQt
- MATE

In the AUR:
- Pantheon
- Unity
- Common Desktop Environment
- Soooo many more

Check the Arch Wiki.

## Desktop Environments - Display Manager

You can enable your chosen display manager to run at startup:

    sudo systemctl enable *dm.service

Then to start using it now:

    sudo systemctl start *dm.service

# Managing an Arch System

## Managing Packages

Arch Linux uses *pacman* as its package manager. It's used to install and
install software.

Compared to other package managers, pacman:
- Can update the whole system in a single command
- Lets you query installed packages
- Can package your own software really simply

## pacman Examples

Install a package: `pacman -S packagename`  
Remove a package: `pacman -Rsc packagename`  
Update all packages: `pacman -Suy`  
List the files in a package: `pacman -Ql packagename`  

## Faster pacman downloads

By default pacman chooses a mirror that might not be optimal. You can speed it
up using `rankmirrors` to find a hot local mirror near you.

1. Edit `/etc/pacman.d/mirrorlist` and uncomment mirrors in your country
2. Run `rankmirrors mirrorlist > mirrorlist.new`
3. `cp mirrolist.new mirrorlist`

## mkpkg

Arch's package system is super simple (compared to some others). The package
format is just compressed tar files with a `PKGBUILD` describing how to build
and a `.install` that runs when installed.

## AUR

When you make your own package, you can push it out to other Arch users to use
themselves. The *Arch User Repository* is a collection of software packaged by
the Arch community.

*WARNING*: These packages can be created by ANYONE and have no guarantees of
stability of safety. Use at your own risk!

## Installing an AUR Package

1. `git clone` from the AUR repository for that package
2. Install dependencies
3. `mkpkg`
4. If it worked, `sudo pacman -U package-file.tar.xz`

## AUR scripts

An AUR script makes it easy to install AUR packages in an automated fashion. If
you're on x86_64, check out `aura-bin` from the AUR. If you're on i686 or ARM,
check out `yaourt` from the AUR.

## systemd

Systemd is the init system for Arch. At a high level, you'll probably be using
it to manage system services.

Start a service: `systemctl start sshd`  
Stop a service: `systemctl stop sshd`  
Autostart a service: `systemctl enable sshd`  
Remove an autostart: `systemctl distable sshd`

## netctl

Arch Linux by default uses `netctl` to manage the network. Profiles are
described by text files in `/etc/netctl`. You can find samples in
`/etc/netctl/examples`.

Standard wifi profiles can be generated with `wifi-menu`.

Starting a profile: `netctl start osuwireless`  
Stopping a profile: `netctl stop osuwireless`  
Stopping all networks: `netctl stop-all`  
Autostart a network: `netctl enable osuwireless`  
Disable an autostart: `netctl disable osuwireless`

