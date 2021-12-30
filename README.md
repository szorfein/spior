# spior
(Spider|Tor) A tool to make TOR your default gateway.

## Install
Spior is cryptographically signed, so add my public key (if you haven’t already) as a trusted certificate.

    $ gem cert --add <(curl -Ls https://raw.githubusercontent.com/szorfein/spior/master/certs/szorfein.pem)

And install the gem:

    $ gem install spior -P MediumSecurity

Or only user wide (Spior will use `sudo`)

    $ gem install --user-install spior

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

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/spior/issues/new).

### links
+ https://rubyreferences.github.io/rubyref
+ https://rubystyle.guide/