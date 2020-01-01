# dubfinder
an old janky bash wrapper for [subfinder](https://github.com/projectdiscovery/subfinder) to detect dangling CNAME's and other DNS tomfoolery (SERVFAIL).

## features
* built in support for ed's [poor man's recon setup](https://edoverflow.com/2018/the-poor-mans-monitoring-setup/)
* enmurate subdomains with subfinder and scan then for hanging CNAME records in one script

## installation
just make sure to have [subfinder](https://github.com/projectdiscovery/subfinder)  properly installed and a private git respository setup with proper notification settings (see ed's post)

## TODO
* optimize
* better domain validation so output isn't so darned messy

#### whats with the name
youre gonna be taking mad dubs with this script
