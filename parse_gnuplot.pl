#! /usr/bin/perl -w
#usage $0 

use strict;
open my $GP, '|-' , 'gnuplot' or die "Unable to pipe gnuplot: $!";

say $GP "set terminal png" ;
say $GP "set output 'testplot.png'" ;
say $GP "plot '-' w l title 'fitness' " ;

#print $GP "0 0 \n 1 1\n 2 4\n 3 9\ne\n" ;
map{ print $GP "$_ \t",  ($_*$_) ,"\n" } 0..5 ;
print $GP "e" ;

flush $GP ;
close $GP ;
