build:
	rm -f spior*.gem
	gem build spior.gemspec
	gem install spior-0.0.5.gem -P MediumSecurity
