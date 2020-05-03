build:
	rm -f spior*.gem
	gem build spior.gemspec
	gem install spior-0.0.3.gem -P MediumSecurity
