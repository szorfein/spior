build:
	rm -f spior*.gem
	gem build spior.gemspec
	gem install spior-0.0.8.gem -P MediumSecurity
