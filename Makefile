build:
	rm -f spior*.gem
	gem build spior.gemspec
	gem install spior-0.1.1.gem -P MediumSecurity
