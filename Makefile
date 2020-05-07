build:
	rm -f spior*.gem
	gem build spior.gemspec
	gem install spior-0.0.9.gem -P MediumSecurity
