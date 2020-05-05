# spior
(Spider|Tor) A tool to make TOR your default gateway and randomize your hardware (MAC).

## Install
Spior is cryptographically signed, so add my public key (if you haven’t already) as a trusted certificate.

    $ gem cert --add <(curl -Ls https://raw.githubusercontent.com/szorfein/spior/master/certs/szorfein.pem)

And install the gem

    $ gem install spior -P MediumSecurity

## Dependencies
You can install all the dependencies with:

    $ spior --install

Please, post an issue if your distro linux fail.

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