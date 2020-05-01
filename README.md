# spior
(Spider|Tor). A tool to make TOR your default gateway and randomize your hardware (MAC). 
**still under development !**

## Install
Spior is cryptographically signed, so add my public key (if you haven’t already) as a trusted certificate.

    $ gem cert --add <(curl -Ls https://raw.githubusercontent.com/szorfein/spior/master/certs/szorfein.pem)

And install the gem

    $ gem install spior -P MediumSecurity

## Usage

    $ spior -h
    $ spior --install

### links
+ https://rubyreferences.github.io/rubyref
+ https://rubystyle.guide/