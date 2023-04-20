# webkit2png-daemon

[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
![GitHub issues](https://img.shields.io/github/issues/rgglez/webkit2png-daemon) 
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/rgglez/webkit2png-daemon)

A server daemon written in Perl which listens in an specified TCP port for a string containing the URL to be screenshoted. It uses the [WebKit2PNG](https://pypi.org/project/webkit2png/) script to make the screenshot.

You can configure the listening port, host and other parameters for the daemon using the [Net::Server configuration](https://metacpan.org/pod/Net::Server). 
See the *run.sh* script for an example on how to run the daemon.

## Usage

Adjust the paths of the programs here:

```perl
my $PYTHON = '/usr/bin/python';
my $XVFB = '/usr/bin/xvfb-run';
my $WEBKIT2PNG = 'webkit2png.py';
my $CAT = '/bin/cat';
``` 

Create the directory for the logs and set the correct permissions/ownerships:

```bash
mkdir /var/log/webkit2png/
chown $USER:$GROUP /var/log/webkit2png/
```

Start the server executing:

```bash
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

* [Net::Server::PreFork](https://metacpan.org/pod/Net::Server::PreFork)
* [GD::Simple](https://metacpan.org/pod/GD::Simple)
* [File::Temp](https://perldoc.perl.org/File::Temp)
* [MIME::Base64](https://metacpan.org/pod/MIME::Base64)
* [Sys::Syslog](https://perldoc.perl.org/Sys::Syslog)
* [Digest::SHA](https://metacpan.org/pod/Digest::SHA)
* [Data::Validate::URI](https://metacpan.org/pod/Data::Validate::URI)

### Programs

* [WebKit2PNG](https://pypi.org/project/webkit2png/)
* [Python](https://www.python.org/)
* [xvfb-run](https://github.com/revnode/xvfb-run/blob/master/xvfb-run)
* [cat](https://man7.org/linux/man-pages/man1/cat.1.html)

## Notes

* You must download the [webkit2png](https://pypi.org/project/webkit2png/) Python script.
* If you are into cloud FaaS, look [here](https://github.com/rgglez/fc-webpage-screenshot).

## License

Copyright (c) 2023, Rodolfo González González.

Read the LICENSE file.
