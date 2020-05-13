build:
	rm -f spior*.gem
	gem build spior.gemspec
	gem install spior-0.1.2.gem -P MediumSecurity
