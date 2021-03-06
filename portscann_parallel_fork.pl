#! /usr/bin/perl -W
#perl -le -M::IO::Socket 'my $tgt='127.0.0.1 ; map { my $sock=IO::socket::INET->new(PeerAddr=>"$tgt:$_",Proto=>'tcp',Timeout=>1) ? print "%d\n", $_ : () } (1..1200) ' 
#better to avoid map for fork, code gets unreadable due to lot of function declaration
#using parallel::Forkmanager

use IO::Socket;
use strict; 
use Parallel::ForkManager;

sub usage{
  print "perl scriptname.pl [host.IP] [start_port] [stop_port] [logfile] \n" ;
  print "Default is set to localhost , 1, 1024, scanlog.txt \n" ;
  exit 0;
}

sub checksock{
  my ($target,$prt, $prto,$tmt) = @_;
  my $sock = IO::Socket::INET->new(PeerAddr=>"$target:$prt",Proto=>"$prto",Timeout=>"$tmt") ;
  $sock ? return $sock : return 0 ;
}

my $np = 32 ;
my $fork = Parallel::ForkManager->new($np);

$| = 1;

my $t = 3;
my ($ip, $protocol, $port0, $port1, $log);
($ip, $port0, $port1, $log) = @ARGV ;

$ip && $ip eq "-h" && usage() ; 

$ip = "localhost" unless $ip ;
$port0 = 1 unless $port0 ;
$port1 = 1024 unless $port1 ;
$log = "scanlog.txt" unless $log ;
$protocol = 'tcp' ;

open(LOG_FILE, ">>$log") or die "Can't open file" ;
#map {!($fork->start()) and printf LOG_FILE "%d <-Open  \n", $_ if &checksock($ip,$_,$protocol,$t) ; $fork->finish() ; } ($port0..$port1) ;

foreach ($port0..$port1){
  $fork->start() and  next ;  
  printf LOG_FILE "%d <-Open \n", $_ if checksock($ip,$_,$protocol,$t) ;
  $fork->finish();
}

$fork->wait_all_children();

close LOG_FILE || die "Unable to close" ;

