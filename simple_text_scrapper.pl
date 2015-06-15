#! /usr/bin/perl -w

#usage perl script.pl <url_to_scrape>

use strict;
use WWW::Mechanize;
#use WWW::Mechanize::TreeBuilder;

my $url = shift @ARGV ;
my %visited ;
my %pgdata ;
my %extracted ;
my %visit2 ;

my $mech = WWW::Mechanize->new( agent => 'Nightlord 1.0' );
$mech->get($url) or die "Unable to fetch page" ;
my @linksfound = $mech->links();
my $texts = $mech->text() or die "Content cannot be displayed as text" ;

foreach (@linksfound) {
  my @urls = split('/', $_->url_abs()); 
  "$urls[2]" eq "$url" and $visited{$_->url_abs()}++ ;
}

while (1) {
 keys(%visited) == 0 and last ;
 my @visitarr = keys %visited ;
 foreach (@visitarr) {
   my @linext ;
   print "\n" x 5 , $_ ;
   $extracted{$_} and delete $visited{$_} and next ;
   $mech = WWW::Mechanize->new( agent => 'Nightlord 1.0' );
   $mech->get($_) or next ;
   0+@linksfound > 0 and @linext = check_links(@linksfound);
   unless (@linext) {
     foreach my $i2 (@linext) {
       $extracted{$i2} or $visited{$i2}++ ;
     }
   }
   $extracted{$_}++ or $pgdata{$_} = $mech->text() and delete $visited{$_} ;
   print "scraping :" x 5 , $_ ;
   sleep(int(rand(24))+6);
 }
 print " === Links Left === " , keys(%visited) ;
 }

open(my $f1, '>', 'sample.txt') or die 'File error' ;
foreach (keys %pgdata) { 
  print $f1 $pgdata{$_} , "\n \n \n" ; 
}

sub check_links{
  my @temp_links ;
  my @num_links = @_ ;
  foreach (@num_links) {
    my @split_links = split('/' , $_->url_abs());
    $split_links[2] eq 'www.lua.org' and push(@temp_links, $_->url_abs());
  }
  0+@temp_links > 0 and return @temp_links or return ;
}
