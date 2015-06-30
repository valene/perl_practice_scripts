#! /usr/bin/perl -W
#or one-liner below:
#perl -le 'map{map{ $_ =~ m/\.(zip|rar)/i and print "$_\n"} ($_ =~ m/href=\"(.*?)\"/g) }grep{ /Download:/ } split("\n",get($_))' "url_to_extract"
#use with above with | wget && $RANDOM for bash oneline extraction. 
#adjust grep condition if specific pattern || remove alltogether. 

use strict;
use LWP::Simple;

sub usage {
  print "perl $0 url_to_extract \n" and exit 0;
}

my $url = shift @ARGV ;
$url or usage ;
$url and $url eq "-h" && usage ; 

my @content = split("\n",get($url)) ;
map{map{ $_ =~ m/\.(zip|rar)/i and print "$_\n"} ($_ =~ m/href=\"(.*?)\"/g) }grep{ /Download:/ } @content ;
