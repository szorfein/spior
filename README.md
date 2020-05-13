# spior
(Spider|Tor) A tool to make TOR your default gateway and randomize your hardware (MAC).

## Install
Spior is cryptographically signed, so add my public key (if you haven’t already) as a trusted certificate.

    $ gem cert --add <(curl -Ls https://raw.githubusercontent.com/szorfein/spior/master/certs/szorfein.pem)

And install the gem

    $ gem install spior -P MediumSecurity

To be able to use the `persist mode` (with systemd for now), the gem should be installed system-wide:  
+ For gentoo, a package is available on my repo [ninjatools](https://github.com/szorfein/ninjatools/tree/master/dev-ruby/spior).  
+ Arch seem to use [Quarry](https://wiki.archlinux.org/index.php/Ruby#Quarry).  
+ On distro based on debian, gem are installed system-wide.  

If you can, i recommend that you create a package for your distribution.  

## Usage

    $ spior -h

### Examples
To change the MAC address for eth0

    $ spior -n eth0 -m

Redirect traffic through TOR

    $ spior -t
    $ spior -t -n eth0

Look informations about your current ip address

    $ spior -s

## Left Over

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/spior/issues/new).

### links
+ https://rubyreferences.github.io/rubyref
+ https://rubystyle.guide/