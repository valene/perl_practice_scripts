#! /ust/bin/perl -w

use strict;
use Nmap::Scanner;

sub begin_scan {
  my ($self, $host) = @_ ;
  my $hostname = $host->hostname();
  my $address = join(',',map {$_->addr()} $host->addresses());
  my $status = $host->status();
  print "$hostname ($address) is $status \n" ;
}

sub find_port {
  my ($self, $host, $port) = @_ ;
  my $hostname = $host->hostname();
  my $address = join(',',map {$_->addr()} $host->addresses());
  print "$hostname ($address) , found ", $port->state(),"port",join('/',$port->protocol(),$port->portid()), "\n"
}

my $scanner = new Nmap::Scanner;
$scanner->register_scan_complete_event(\&begin_scan);
$scanner->register_port_found_event(\&find_port);
$scanner->max_rtt_timeout(20);
$scanner->add_target('192.168.0.2');
$scanner->add_scan_port('1-6400');
$scanner->guess_os();

$scanner->scan();
#$scanner->scan('-sS -p 1-3200 -O -max-rtt-timeout 20 192.168.0.1-9');

