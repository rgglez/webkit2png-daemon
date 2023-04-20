#!//bin/sh

rm -f /var/run/webkit.pid

/usr/bin/perl /usr/local/athenea/WebKit2PNGDaemon.pl --host 10.0.1.36 --port 22222 --pid_file=/var/run/webkit.pid --user webkit --group webkit --log_level 4 --log_file /var/log/webkit/daemon.log --background

