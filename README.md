# Spior

<div align="center">
<br/>

[![Gem Version](https://badge.fury.io/rb/spior.svg)](https://badge.fury.io/rb/spior)
![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/szorfein/spior/Rubocop/devel)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
![GitHub](https://img.shields.io/github/license/szorfein/spior)

</div>

(Spider|Tor) A tool to redirect all your local traffic to the [Tor](https://www.torproject.org/) network.

## Install
Spior is cryptographically signed, so add my public key (if you haven’t already) as a trusted certificate.

    $ gem cert --add <(curl -Ls https://raw.githubusercontent.com/szorfein/spior/master/certs/szorfein.pem)

And install the gem:

    $ gem install spior -P MediumSecurity

Or user wide (Spior will use `sudo`, `doas` will be supported in next release)

    $ gem install --user-install spior

## Requirements
Spior use `iptables` and `tor`, which can be installed with (if your distro is supported):

    $ spior --install

## Configuration
Spior look the /etc/tor/torrc for any of:

```conf
DNSPort 9061
TransPort 9040
VirtualAddrNetworkIpv4 10.192.0.0/10
```

You can customize any of theses variables.

When using `spior -c | --clearnet`, if you want Spior load custom iptables rules, place
them at `/etc/iptables/simple_firewall.rules`.

## Usage

    $ spior -h

### Examples
Redirect traffic through TOR:

    $ spior --tor

Change your ip address by reloading the TOR circuit:

    $ spior --reload

Look informations about your current ip address:

    $ spior --status

Return to clearnet navigation

    $ spior --clearnet

## Left Over

### [Check for Leak](https://github.com/brainfucksec/kalitorify#checking-for-leaks)
### Troubleshoooting
When you enable the `--persist` mode, Spior try to block ipv6 with sysctl. It can fail on some system, so you may need to manually disable ipv6 via kernel argument.  
An exemple with GRUB, edit `/etc/default/grub.cfg` and change the line bellow:

```
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 quiet"
```

Reload grub after that `grub-mkconfig -o /boot/grub/grub.cfg`

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/spior/issues/new).

### links
+ https://gitlab.torproject.org/legacy/trac/-/wikis/doc/TransparentProxy
+ https://github.com/epidemics-scepticism/writing/blob/master/misconception.md
+ [in perl - Nipe](https://github.com/htrgouvea/nipe)
+ [in bash - Kalitorify](https://github.com/brainfucksec/kalitorify)
