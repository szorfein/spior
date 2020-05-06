## 0.0.8, release 2020-05-06
* Always make a copy and replace original file, do not ask, the program is dependent of his config file for now.
* Correct install where Dir.chdir don't back to the previous location.
* --install also place the deceitmac.service if your system use systemd.
* Simplify lib/spior/copy check\_hash.
* The use of the option -i|--install is optionnal, deps are checked during the execution.

## 0.0.7, release 2020-05-05
* Execute the option -t|--tor verify if config files are present.
* Correct --copy, does not make more than one backup of the same file.
* Correct --install, do not check for reinstall package if they exist.
* --clear restore config files
* --clear tries to restore the old rules if he finds them.
* New option -c|--clear
* Remove option --copy, it is start with --install
* Change option --card with -n|--net-card
* Add the Gem tty-which as dependencies

## 0.0.6, release 2020-05-04
* README, Add examples
* lib/spior/iptables - rename var input incoming
* Remove unused rules for iptables (INPUT and OUTPUT)
* Search tor-uid by distro (tested for gentoo,arch,debian,ubuntu)
* Add class lib/spior/tor, to check variables and dependencies (later)
* Add the Gem Nomansland as dependencies

## 0.0.5, release 2020-05-03
* Spior can now redirect all the traffic through TOR
* Add OptionParser -t|--tor
* Change class lib/spior/mac by module
* Correct option -c|--card NAME
* Create lib/spior/network
* Create lib/spior/iptables 

## 0.0.4, release 2020-05-02
* Spior can now randomize a mac address with decertmac
* Add field s.metadata to spior.gemspec
* Add lib/spior/mac
* Add deceirtmac to the optionParser (-m|--mac, -c|--card)
* Install deceirtmac with -i|--install
* Add a Makefile for me
* Add the Gem Interfacez as dependencies

## 0.0.3, release 2020-05-01
* Separate install / copy
* Add instruction to install deceirtmac in the README
* Add option -s | --status
* Add the Gem Rainbow as dependencies
