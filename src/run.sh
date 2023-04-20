#!//bin/sh

# You must create an unprivileged user and a group to run the server with.
# You must create directory for the logs, with the corresponding permissions
# and ownerships.

rm -f /var/run/webkit.pid

/usr/bin/perl /usr/local/bin/WebKit2PNGDaemon.pl --host 127.0.0.1 --port 22222 --pid_file=/var/run/webkit.pid --user webkit --group webkit --log_level 4 --log_file /var/log/webkit/daemon.log --background

