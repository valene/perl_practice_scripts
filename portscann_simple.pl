#! /usr/bin/perl -W
#A simple port scanner.
#perl -le -M::IO::Socket 'my $tgt='127.0.0.1' ; map { my $sock=IO::socket::INET->new(PeerAddr=>"$tgt:$_",Proto=>'tcp',Timeout=>1) ? print "%d\n", $_ : () } (1..1200) ' 

use IO::Socket;

sub usage() {
  print "perl scriptname.pl [host.IP] [start_port] [stop_port] [logfile] \n" ;
  print "Default is set to localhost , 1, 1024, scanlog.txt \n" ;
  exit 0;
}

sub checksock() {
  my ($target, $prt, $prto, $tmt) = @_;
  my $sock = IO::Socket::INET->new(PeerAddr=>"$target:$prt",Proto=>"$prto",Timeout=>$tmt) ;
  $sock ? return $sock : return 0 ;
}

$| = 1;

my $t = 3;
my ($ip, $protocol, $port0, $port1, $log);
($ip, $port0, $port1, $log) = @ARGV ;

$ip && $ip eq "-h" && &usage() ; 

$ip = "localhost" unless $ip ;
$port0 = 1 unless $port0 ;
$port1 = 1024 unless $port1 ;
$log = "scanlog.txt" unless $log ;
$protocol = 'tcp' ;

open(LOG_FILE, ">>$log") or die "Can't open file" ;
map {printf LOG_FILE "%d <-Open \n", $_ ; } grep { &checksock($ip,$_,$protocol,$t); } ($port0..$port1) ;

close LOG_FILE || die "Unable to close" ;

