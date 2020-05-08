build:
	rm -f spior*.gem
	gem build spior.gemspec
	gem install spior-0.1.0.gem -P MediumSecurity
