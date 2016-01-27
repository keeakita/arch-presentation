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
