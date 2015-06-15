#! /usr/bin/perl -w
#Another simple perl script to keep track of installed and latest release
#default location is /tmp but can be changed or passed as argv
#Archive::tar|Archive::extract && system('./configure); though
#personally i prefer to do it in bash manually, after reading elease notes.
use strict;
use LWP::UserAgent;
use File::Fetch ;

sub usage() {
    print "perl $0 downloads_page command_name \n" ;
    exit 0;
  }

my $url = shift @ARGV; 
$url or usage ;
$url and $url eq '-h' and usage ;
my $pname = shift @ARGV ;
my $b=LWP::UserAgent->new(); 
my $c=$b->post("$url")->content();
my @F=split("\n",$c);
my @rel = grep{/(L|l)atest\s(R|r)elease/ and ~m/\"(.*?)\"/i and $_ = $1} @F;
my $floc = "$url$rel[0]" ;
my $f=File::Fetch->new(uri=>"$floc") ;
$rel[0] =~ m/-(\d+.*?\d+)/i and my $relver = $1 ;
my $v_in = `$pname --version | head -n 1` ;
$v_in =~ m/(\d+.*?\d+)/i and my $insver = $1;
$relver > $insver and my $where = $f->fetch(to=>'/tmp') ;
