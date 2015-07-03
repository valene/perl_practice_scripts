#! /usr/bin/perl -W 

use strict;

sub usage() {
  print "perl $0 list_of_files \n" ;
  print "use it with other scripts";
  exit 0;
}

my %filesdata ;
my @files_list = @ARGV ;
map{ $filesdata{$_} = [ (stat($_))[8],(stat($_))[9] ] } @files_list;
#stored....last access and last modified dates 
<<'TESTCODE';
map{ print "@{$filesdata{$_}} \t" } (keys %filesdata);
print "\n";
sleep (10) ;
map{`echo -e "\n" > $_ 2>/dev/null`} (keys %filesdata);
map{ print (((stat($_))[8]) ,"\t", ((stat($_))[9]), "\t") } (keys %filesdata);
print "\n";
sleep(5);
TESTCODE
#Do some stuff.........with the files in list.
#basically, replacement codes, .
#exchange the access and modify to original time. 
map{utime ${$filesdata{$_}}[0], ${$filesdata{$_}}[1], $_} @files_list;
#map{ print "@{$filesdata{$_}} \t" } (keys %filesdata);
