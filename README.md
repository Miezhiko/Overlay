[![CI](https://github.com/Miezhiko/Overlay/actions/workflows/repoman.yml/badge.svg)](https://github.com/Miezhiko/Overlay/actions/workflows/repoman.yml)
[![Discord](https://img.shields.io/discord/249111029668249601?label=Gentoo&color=pink)](https://discord.gg/gentoolinux)
[![Twitter Follow](https://img.shields.io/twitter/follow/Miezhiko.svg?style=social)](https://twitter.com/Miezhiko)

<img align="right" src="http://files.gamebanana.com/img/ico/sprays/50decef29d1ed.gif">

<h3>Overlay specifics</h3>

 - EAPIS older than 7 banned
 - no thin manifest
 - pull requests are very welcome
 - many patches taken from Arch Linux
 - currently I use it with [bentoo](https://github.com/obentoo/bentoo) overlay

<h3>Install</h3>

[Custom ebuild repository](https://wiki.gentoo.org/wiki/Custom_ebuild_repository)

It's heavily suggested to run this overlay on top of the
[bentoo](https://github.com/obentoo/bentoo) overlay: this overlay forks and
patches a number of packages that originate there, and depends on bentoo
for everything it doesn't itself override. Add both via
`/etc/portage/repos.conf/`, with this overlay listed **after** bentoo and
given a **higher `priority`** than bentoo, so that whenever both overlays
carry the same package, Portage prefers this overlay's version over
bentoo's:

```
# /etc/portage/repos.conf/bentoo.conf
[bentoo]
location = /var/db/repos/bentoo
sync-type = git
sync-uri = https://github.com/obentoo/bentoo.git
priority = 10
auto-sync = yes
```

```
# /etc/portage/repos.conf/miezhiko.conf
[Miezhiko]
location = /var/db/repos/miezhiko
sync-type = git
sync-uri = https://github.com/Miezhiko/Overlay.git
priority = 20
auto-sync = yes
```

Then sync both repositories:

```
emerge --sync
```

or, for just these two repos:

```
emaint sync --repo bentoo
emaint sync --repo Miezhiko
```

Verify both are registered and in the expected priority order:

```
eselect repository list
```
