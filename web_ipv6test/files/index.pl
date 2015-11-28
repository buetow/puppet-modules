#!/usr/bin/perl

use strict;
use warnings;

print <<END;
Content-type: text/html

<html>
<head>
<title>The Ultimate IPv6 Test Site</title>
</head>
<body>

Congratulations, you have connected to a server that will display your method of connection, either IPv6 (preferred) or IPv4 (old and crusty). Well IPv6 is already older than 20 years but not as old as IPv4 ;)
<br /><br />
Nevertheless, please choose your destiny:
<ul>
  <li><a href="https://ipv6.buetow.org">ipv6.buetow.org</a> for IPv6 & IPv4 Test</li>
  <li><a href="https://test4-ipv6.buetow.org">test4-ipv6.buetow.org</a> for IPv4 Only Test</li>
  <li><a href="https://test6-ipv6.buetow.org">test6-ipv6.buetow.org</a> for IPv6 Only Test</li>
</ul>
If your browser times-out when trying to connect to this server then you do not have an IPv6 or IPv4 path (depends on which test you are running) to the server. If your browser returns an error that the host cannot be found then the DNS servers you are using are unable to resolve the AAAA or A DNS record (depends on which test you are running again) for the server. If your browser is able to connect to the "IPv6 Only Test", yet using the "IPv6 & IPv4 Test" returns a page stating you are using IPv4, then your browser and/or IP stack in your machine are preferring IPv4 over IPv6. It also might be that your operating system supports IPv6 but your web-browser doesn't.
END

if ($ENV{SERVER_NAME} eq 'ipv6.buetow.org') {
  print "<h3>IPv6 & IPv4 Test Results:</h3>\n";

} elsif ($ENV{SERVER_NAME} eq 'test6-ipv6.buetow.org') {
  print "<h3>IPv6 Only Test Results:</h3>\n";

} elsif ($ENV{SERVER_NAME} eq 'test4-ipv6.buetow.org') {
  print "<h3>IPv4 Only Test Results:</h3>\n";
}

# Do this to hide NAT, otherwise use $ENV{SERVER_ADDR};
my ($what, $server_addr) = do {
  if ($ENV{REMOTE_ADDR} =~ /(?:\d+\.){3}\d/) {
    ('IPv4','78.46.80.70')
    } else {
    ('IPv6','2a01:4f8:120:30e8::11')
  }
};

print "<pre>You are using <b>$what</b>\n";

chomp (my $remote = `host $ENV{REMOTE_ADDR}`);
chomp (my $server = `host $server_addr`);
chomp (my $server0 = `host $ENV{SERVER_NAME}`);
chomp (my $digremote = `dig -x $ENV{REMOTE_ADDR}`);
chomp (my $digserver = `dig -x $server_addr`);
chomp (my $digserver0 = `dig -t any $ENV{SERVER_NAME}`);

print <<END;
Client address: $ENV{REMOTE_ADDR}
Server address: $server_addr

<b>Client address reverse DNS lookup:</b>
$remote

<b>Server address reverse DNS lookup:</b>
$server

<b>Server hostname DNS lookup:</b>
$server0

<b>Advanced client address reverse DNS lookup:</b>
$digremote

<b>Advanced server address reverse DNS lookup:</b>
$digserver

<b>Advanced server hostname DNS lookup:</b>
$digserver0
</pre>
<hr />
Thanks for visiting, please recommend this test to your friends and colleagues. Any comments go to <a href="http://contact.buetow.org">Paul Buetow</a>.
</body>
</html>
END
