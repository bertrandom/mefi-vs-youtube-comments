# Metafilter comments vs. Youtube comments

Pulls the most recent Metafilter comments and the most recent Youtube comments from the most popular videos and puts them side-by-side for hilarity.

I recently rewrote this in Ruby, the original which was written in PHP using the Symfony 1.0 framework and Yahoo Pipes can be found [here](https://github.com/bertrandom/mefi-vs-youtube-comments-legacy).

## Installation

Install the [feedzirra](https://github.com/pauldix/feedzirra) gem. 

	gem install feedzirra
	
Run `generate.rb`. If all goes well, `web/index.html` should contain the latest comments. After you've confirmed that worked, add the contents of `crontab` to your web user's crontab, changing the absolute path to wherever you install this to. This will update the page once per day.
	
If you're using Ubuntu 12.10, feedzirra may refuse to install. I had to do this:

	apt-get install libcurl4-gnutls-dev
  	git clone https://github.com/taf2/curb.git
	cd curb
  	apt-get install rake
    rake install
    rake package
    gem install ./curb-0.8.3.gem
    gem install feedzirra --pre

## References

[Original MeFi project](http://projects.metafilter.com/1393/Metafilter-comments-vs-Youtube-comments)

[MetaTalk post](http://metatalk.metafilter.com/16003/Metafilter-comments-vs-Youtube-comments)

[Freakonomics blog post](http://www.freakonomics.com/2008/04/10/can-5-improve-reader-comments/)