# webkit2png-daemon

[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
![GitHub all releases](https://img.shields.io/github/downloads/rgglez/webkit2png-daemon) 
![GitHub issues](https://img.shields.io/github/issues/rgglez/webkit2png-daemon) 
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/rgglez/webkit2png-daemon)

A daemon written in Perl which listens for URLs to be screenshoted. It uses the [WebKit2PNG](https://pypi.org/project/webkit2png/) script to make the screenshot.

You can configure the listening port, host and other parameters for the daemon using the [Net::Server configuration](https://metacpan.org/pod/Net::Server). 
The configured port in the script is 15000 for instance.

## Usage

Adjust the paths of the programs here:

```perl
my $PYTHON = '/usr/bin/python';
my $XVFB = '/usr/bin/xvfb-run';
my $WEBKIT2PNG = 'webkit2png.py';
my $CAT = '/bin/cat';
``` 

Start the server executing:

```
perl WebKit2PNGDaemon.pl
```

Then send a string (the URL to be screenshoted) to the specified port and host. The server will execute WebKit2PNG and return a first line containing

```
LENGTH: <length of the captured image in bytes>
```

and then the bytes of the captured screen in PNG format, or an error image.

## Dependencies

### Perl modules 

You can install them using *perl -MCPAN -e shell* or your distro's package manager:

* Net::Server::PreFork
* GD::Simple
* File::Temp
* MIME::Base64
* Sys::Syslog
* Digest::SHA
* Data::Validate::URI

### Programs

* [WebKit2PNG](https://pypi.org/project/webkit2png/)
* [Python](https://www.python.org/)
* [xvfb-run](https://github.com/revnode/xvfb-run/blob/master/xvfb-run)
* [cat](https://man7.org/linux/man-pages/man1/cat.1.html)

## Notes

* You must download the [webkit2png](https://pypi.org/project/webkit2png/) Python script.
* A simpler and more modern solution to screenshot webpages is provided [here](https://github.com/rgglez/fc-webpage-screenshot).

## TODO

* Use command line parameters and a configuration file.

## License

Copyright (c) 2023, Rodolfo González González.

Read the LICENSE file.