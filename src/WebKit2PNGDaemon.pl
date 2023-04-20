#!/usr/bin/perl

# BSD 3-Clause License
# 
# Copyright (c) 2023, Rodolfo González González
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package MyPackage;

use vars qw(@ISA);
use Net::Server::PreFork; 
use GD::Simple;
use File::Temp qw/ tempfile tempdir /;
use MIME::Base64;
use Sys::Syslog;
use Digest::SHA qw(sha512_hex);
use Data::Validate::URI qw(is_uri);

@ISA = qw(Net::Server::PreFork);

MyPackage->run();
exit;

################################################################################

sub errorImg
{
   my ($string) = shift;

   my $img = GD::Simple->new(1,1);
   $img->bgcolor('white');
   $img->fgcolor('white');
   #$img->rectangle(0, 0, 250, 200);
   #$img->moveTo(10, 10);
   #$img->string($string);
   my $strImg = $img->png;
   print "LENGTH: " . length($strImg) . "\n\r";
   print $strImg;
}

sub doLog
{
   my ($message) = shift;

   openlog("WEBKIT2PNGDAEMON", "ndelay,pid", "local0");
   syslog('warning', $message . ' %m');
   closelog();
}

sub process_request
{
   my $self = shift;

   my $PYTHON = '/usr/bin/python';
   my $XVFB = '/usr/bin/xvfb-run';
   my $WEBKIT2PNG = 'webkit2png.py';
   my $CAT = '/bin/cat';

   eval {
      local $SIG{ALRM} = sub { &errorImg('Timed out.'); };
      my $timeout = 120;

      my $previous_alarm = alarm($timeout);
      while (<STDIN>) {
         s/\r?\n$//;
         my $url = $_;
         if (is_uri($url)) {
            my $file = new File::Temp(UNLINK => 1, DIR => '/tmp');
            $ENV{'DISPLAY'} = 'localhost:0';
            my $cmd  = "$XVFB --server-args='-screen 0, 1024x768x24' -a $PYTHON $WEBKIT2PNG -o $file --debug --log=/var/log/webkit2png/webkit2png.log -W -F javascript -F plugins --scale=250 200 --aspect-ratio=crop $url";
            system($cmd);
            if (-f $file) {
               my $filesize = -s $file;
               my $buffer = 0;
               print "LENGTH: $filesize\n\r";
               print `$CAT $file`;
               &doLog('WEBKIT2PNG: ' . $url);
            }
            else {
               &doLog('Error: Invalid PNG File');
               &errorImg('Error: Invalid PNG File');
            }
         }
         alarm($timeout);
      }
      alarm($previous_alarm);
   };

   if ($@=~/timed out/i) {
      &doLog('Timed out.');
      &errorImg('Timed out.');
      return;
   }
}

1;
