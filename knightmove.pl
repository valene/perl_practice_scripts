#! /usr/bin/perl
use warnings;
use strict;

my @chessboard;
my @back = qw(R N B Q K B N R);
for (0..7) {
  $chessboard[0]->[$_] = "W".$back[$_] ;
  $chessboard[1]->[$_] = "WP";
  $chessboard[6]->[$_] = "BP";
  $chessboard[7]->[$_] = "B".$back[$_] ;
}

while (1) {
  for my $i (reverse (0..7)) {
    for my $j (0..7) {
      if (defined $chessboard[$i]->[$j]) {
        print $chessboard[$i]->[$j];
      } elsif ( ($i %2) == ($j %2) ) {
        print ".." ;
      } else {
        print "  ";
      }
      print "  ";
    }
  print "\n" ;
 }

 print "\n Enter the location of Knight : ";
 my $pos = <> ;
 next unless ($pos =~ /^\s*([1-8]),([1-8])/);
 my $startx = $1-1; my $starty = $2-1;
 unless ($chessboard[$starty]->[$startx] =~ /\D*N$/) {
   print "Not a Knight \n";
   next ;
  }
 my $fact = substr($chessboard[$starty]->[$startx] , 0, 1);
 print "\n Enter the Location to move : " ;
 $pos = <>;
 next unless ($pos =~ /([1-8]),([1-8])/);
 my $endx = $1-1 ; my $endy = $2-1 ;
 my $dx = abs($startx-$endx) ; my $dy = abs($starty - $endy); 
 unless ( ($dx == 2 &&  $dy == 1) || ($dx == 1 && $dy == 2)) {
   print "Not a valid move for a knight \n" ;
   next ;
  }
 my $sect = "G" ;
 $sect = substr($chessboard[$endy]->[$endx], 0, 1) if (defined $chessboard[$endy]->[$endx]) ; 
 print "$sect is used here";
 if ( $fact eq $sect) {
   print "You can only capture position of opposite side \n" ;
   next ;
  }
 $chessboard[$endy]->[$endx] = $chessboard[$starty]->[$startx] ;
 print "Move successful \n" ;
 undef $chessboard[$starty]->[$startx];
}
