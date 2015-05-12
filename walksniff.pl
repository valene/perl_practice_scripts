#! /usr/bin/perl -w
#todo : 1.coderef for IO 
#       2.pass options to filter .db, sqlite3 and reject encrypted db
# filewalk and dir walk emulates `find ./ -name "*.db"
# bash one-liner : find $HOME -name "*.db" | xargs -n 1 -I {} sqlite3 {} "SELECT tbl_name FROM sqlite_master WHERE type=='table' ;"


use strict;
use DBI;

sub filewalk {
  ( $_[0] =~ m/\.db$/ ) ? return $_[0] : return ;
}

sub walkdir {
  my ($idir,@flist) = @_ ; #remember abs path
  opendir(DIR,$idir) or return 0 ;
  my @elem = readdir(DIR);
  closedir(DIR);
  foreach (@elem) {
    next if $_ eq '.' || $_ eq '..' ;
    ( -d "$idir/$_" ) and @flist = walkdir("$idir/$_",@flist) ;
    ( -f "$idir/$_" ) and push(@flist,filewalk("$idir/$_")) ;
  }
  return @flist;
}
   
sub enterdb {
  my $dname = shift @_ ;
  my $userid = " " ;
  my $password = " " ;
  my $dbh = DBI->connect("dbi:SQLite:dbname=$dname",$userid,$password, { raiseError => 1 })
      or return $DBI::errstr ;
  my $sql = "SELECT tbl_name FROM sqlite_master WHERE type==\'table\' ;" ;
  my $sth = $dbh->prepare($sql) or return ;
  $sth->execute();
  printf "Entering database: %s \n", $dname ;
  while (my @row = $sth->fetchrow_array()){
    print @row ;
    printf "\n" ;
  }
  printf "Exiting database : %s \n \n ", $dname ;
  $dbh->disconnect() ;
  return ;
}


my $dir = "/home/$ENV{USER}" ; #shift @ARGV ;
my @files ;
opendir(DIR,$dir) or die $!;
closedir(DIR) ;
@files = walkdir($dir,@files) ;
#print $_, "\n"  for @files ;
map { enterdb($_) } @files ;


#####################################
#my $dname = shift @ARGV ;
#my $userid = " " ;
#my $password = " " ;

#my $dbh = DBI->connect("dbi:SQLite:dbname=$dname",$userid,$password, { raiseError => 1 }) 
#  or die $DBI::errstr ;
#my $sql = "SELECT tbl_name FROM sqlite_master WHERE type==\'table\' ;" ;
#my $sth = $dbh->prepare($sql) ;
#$sth->execute();
#printf "Enter database: %s \n", $dname ;
#while (my @row = $sth->fetchrow_array()) {
#  print @row ;
#  printf "\n" ;
#}
#printf "Exiting database: %s \n \n", $dname ;
#$dbh->disconnect() ;

