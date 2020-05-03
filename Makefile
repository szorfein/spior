build:
	rm -f spior*.gem
	gem build spior.gemspec
	gem install spior-0.0.4.gem -P MediumSecurity
