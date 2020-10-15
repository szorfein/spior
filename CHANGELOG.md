* Enhance output of `--status`

## 0.1.4, release 2020-05-21
* torrc and resolv.conf are generate dynamically
* Remove conf/resolv
* Correct path of conf_dir for the install on gentoo
* Remove self from lib/copy
* Correct little error on lib/copy with undefined method `deps`

## 0.1.3, release 2020-05-14
* Rename conf dir by ext
* Clearing all codes about MAC
* Remove deceitmac
* Mac change and other randomize features will go on another gem amnesie

## 0.1.2, release 2020-05-13
* Add instructions for the persistent mode
* Add dependency iptables-persistant for distro based on debian
* Avoid to use sudo if no need
* Add lib/spior/helpers

## 0.1.1, release 2020-05-09
* The tor class now check for dependencies and service start|restart
* Call Spior without arguments now display the interactive menu
* New option -m|--menu
* Reorder the spior.gemspec

## 0.1.0, release 2020-05-08
* Will manage differents version of torrc, if your distro fail to start TOR, report an issue.
* Ensure than TOR is start before proceed.
* New option -p|--persist, work with systemd for now.
* Remove duplicate code at lib/spior/mac.rb.
* Correct apt-get install.

## 0.0.9, release 2020-05-07
* Add an option to reload TOR -r|--reload
* Cleanup few characters from -s|--status
* Correct path for search config files

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
