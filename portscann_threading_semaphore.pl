#! /usr/bin/perl -W
#perl -le -MIO::Socket 'my $tgt='127.0.0.1 ; map { my $sock=IO::socket::INET->new(PeerAddr=>"$tgt:$_",Proto=>'tcp',Timeout=>1) ? print "%d\n", $_ : () } (1..1200) ' 
#trying thread, and semaphore

#use Proc::Queue size=> 32 ;
use IO::Socket;
use strict;
use threads;
use Thread::Queue;
use Thread::Semaphore;
my $semaphore = Thread::Semaphore->new() ;
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

sub perform {
  my ($ival1, $ival2, $ival3, $ival4, $outP ) = @_ ;
  my $retval = checksock($ival1,$ival2,$ival3,$ival4) ;
  $semaphore->down();
  printf $outP "%d <-Open \n" , $ival2 if $retval ;
  $semaphore->up();
  #printf $outP "%d <-Open \n" , $ival2 if checksock($ival1,$ival2,$ival3,$ival4) ;
}

my $np = 32 ;
my @threads_total ;
my @threads_runs ;

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

open(my $LOG_FILE, ">>$log") or die "Can't open file" ;
#map {!($fork->start()) and printf LOG_FILE "%d <-Open  \n", $_ if &checksock($ip,$_,$protocol,$t) ; $fork->finish() ; } ($port0..$port1) ;

#my $semaphore = Thread::Semaphore->new() ; #can be new(5) , but inc by up(5), down(5) 
my $dqueue = Thread::Queue->new(); #Don't directly give values, place it in queue ;
map { $dqueue->enqueue($_) } ($port0..$port1) ;

print "Starting threading process \n" ;

while ((0+@threads_total) < ($port1-$port0+1)) {
  @threads_runs = threads->list(threads::running) ;
  if ((0+@threads_runs < $np) && (my $val = $dqueue->dequeue()) ) {
    my $thr = threads->new(\&perform, $ip, $val, $protocol, $t, $LOG_FILE);
    (defined $thr) && push(@threads_total, $thr) ;
  }
  #print "\n Running " , 0+@threads_runs ; 
  map { $_->join } grep { $_->is_joinable() } @threads_total ;
}


while (0+@threads_runs != 0) {
  map { $_->join } grep { $_->is_joinable() } @threads_runs ;
  @threads_runs = threads->list(threads::running) ;
}
#$_->join for @threads_total ;

close $LOG_FILE || die "Unable to close" ;

