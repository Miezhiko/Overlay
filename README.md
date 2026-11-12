[![CI](https://github.com/Miezhiko/Overlay/actions/workflows/repoman.yml/badge.svg)](https://github.com/Miezhiko/Overlay/actions/workflows/repoman.yml)
[![Discord](https://img.shields.io/discord/249111029668249601?label=Gentoo&color=pink)](https://discord.gg/gentoolinux)
[![Twitter Follow](https://img.shields.io/twitter/follow/Miezhiko.svg?style=social)](https://twitter.com/Miezhiko)

<img align="right" src="http://files.gamebanana.com/img/ico/sprays/50decef29d1ed.gif">

<h3>Overlay specifics</h3>

 - EAPIs older than 7 are banned
 - full Manifests are used
 - pull requests are very welcome
 - many patches taken from Arch Linux

<h3>Install</h3>

[Custom ebuild repository](https://wiki.gentoo.org/wiki/Custom_ebuild_repository)

Add the overlay to `/etc/portage/repos.conf/miezhiko.conf`:

```
# /etc/portage/repos.conf/miezhiko.conf
[Miezhiko]
location = /var/db/repos/miezhiko
sync-type = git
sync-uri = https://github.com/Miezhiko/Overlay.git
priority = 20
auto-sync = yes
```

Then sync the repository:

```
emaint sync --repo Miezhiko
```

To sync all configured repositories instead:

```
emerge --sync
```

Verify that the overlay is registered:

```
eselect repository list
```
