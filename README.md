# spior
(Spider|Tor). A tool to make TOR your default gateway and randomize your hardware (MAC).  
**Still under development !**

## Install
Spior is cryptographically signed, so add my public key (if you haven’t already) as a trusted certificate.

    $ gem cert --add <(curl -Ls https://raw.githubusercontent.com/szorfein/spior/master/certs/szorfein.pem)

And install the gem

    $ gem install spior -P MediumSecurity

## Dependencies
You can install all the dependencies with:

    $ spior --install

Please, post an issue if your linux distribution fail.

## Usage

    $ spior -h

## Left Over

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/spior/issues/new).

### links
+ https://rubyreferences.github.io/rubyref
+ https://rubystyle.guide/