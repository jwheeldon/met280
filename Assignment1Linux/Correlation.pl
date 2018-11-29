#!/usr/bin/perl
# Correlation.pl
# Example program to read data from a file and calculate a correlation coefficient
# This is a simple basic version, without any Perl "tricks"
# Richard J. White,
# 21 October 2015  first "Back to the Future" version

print "\nThis program will calculate a correlation coefficient\n"; 
print "from pairs of data values read from a data file\n\n";

# Prompt the user for the data file name
print "Please enter the name of your data file:\n";
$filename = <STDIN>;
chomp $filename;  # remove the newline character(s) from the end of the file name

# Open the file and keep a "file handle" (DATA), so that the program can read from it later
open(DATA, $filename)
  or die "Cannot open the data file \"$filename\"!\n";

# Set all the six necessary counters to zero before reading the data
$n     = 0;             # number of data pairs
$Sx    = 0; $Sy   = 0;  # sums of x and y
$SSQx  = 0; $SSQy = 0;  # sums of squares of x and y
$SCPxy = 0;             # sum of cross-products of x and y

# Loop to read every line in the data file
$lineNo = 0;            # for counting lines
while ($rowOfData = <DATA>)
{ $lineNo++;            # count the line numbers
  chomp $rowOfData;     # remove the newline character(s) from the end of the line
  # Split the row into separate strings for the first two numbers 
  #   (the pattern "[, \t]+" refers to a sequence of one or more comma, 
  #   blank or tab characters, which can't be part of a number, 
  #   but you'll need to change this if your data uses something else)
  # There are other ways to do the split, but this seems easy and simple
  ($x, $y) = split(/[, \t]+/, $rowOfData);   
  # Print the data values (optional)
  print "Line $lineNo x = $x, y = $y\n";
  # Check whether this data row appears to contain two data values
  #  (the pattern "\d+" matches a string of digit characters)
  if ($x !~ /\d+/ or $y !~ /\d+/)
  { print "*** Skipping line $lineNo\n";
  } 
  else
  { # Process this data pair
    $n ++;            # count the data pairs
    $Sx    += $x;     # sums of x and y
    $Sy    += $y;
    $SSQx  += $x*$x;  # sums of squares of x and y
    $SSQy  += $y*$y;
    $SCPxy += $x*$y;  # sum of cross-products of x and y
  }
}

# Check whether we have enough data, stop if < 2 pairs, warn if < 3
print "$n data pairs were read from $lineNo rows in the data file \"$filename\"\n";
if ($n < 2)
{ die "Not enough data pairs, at least 2 are needed!\n";
}
elsif ($n < 3)
{ print "Only 2 data pairs, the correlation will be meaningless!\n";
}

# Calculate and display the variances and the covariance
$varx  = ($SSQx  - $Sx*$Sx/$n) / ($n - 1);
$vary  = ($SSQy  - $Sy*$Sy/$n) / ($n - 1);
$covxy = ($SCPxy - $Sx*$Sy/$n) / ($n - 1);
print "  Variance of x       = $varx\n";
print "  Variance of y       = $vary\n";
print "Covariance of x and y = $covxy\n";

# Check the variances, because we have to divide by them
if ($varx <= 0 or $vary <= 0)
{ print "One or both of the variances of x and y equal zero!\n"; 
  print "This is because the data does not vary in x or y.\n";
  die "Cannot calculate a correlation coefficient!\n";
}

# Calculate the correlation coefficient
$r = $covxy / sqrt($varx * $vary);
print "Correlation coefficient r = $r\n";

print "\n";  # leave a blank line after the output
# End of Correlation.pl