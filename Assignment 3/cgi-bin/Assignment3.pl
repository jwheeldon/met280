#!/usr/bin/perl

# Import CGI and DBI
use CGI;
use CGI::Carp qw{fatalsToBrowser};
$q = new CGI;
use DBI;  

# Output the HTTP header
print $q->header;

# HTML page output
print "<html><head><title>OUTPUT: Assignment 3 - James Wheeldon</title></head><body>\n";
print "</body></html>\n";

# Get the user's magic database
$word= $q->param('database');

#Do some 'magic' (correlation analysis)
if ($word eq "")
{ print "You didn't give a database.\n";
}
else
{ print "<h1>The correlation output for database '$word' is:</h1>\n";
}

# Connection details & user input for database
$server = "localhost";
$database = "$word";
$user = "bioinfo";
$password = "bioinfo";

#Ask user if running perl in terminal
if ($word eq "")
  {
  $database = ask_user ("Database:", "Correlation");
  }

# Establish a connection to the database
$dbh= DBI->connect("DBI:mysql:host=$server;port=3306;database=$database", 
                    $user, $password, {}) 
  or die "Couldn't connect to database: " . DBI->errstr;
  
# Pre-define analysis variables
    $n=0;
    $sumx=0;
    $sumsqx=0;
    $sumy=0;
    $sumsqy=0;
    $sumprodxy=0;
    
## SQL loop (x and y)
$stmt = $dbh->prepare("select height, weight from DataComplete;");

$stmt->execute
  or die "Something went really wrong: " . DBI->errstr; 

# Fetch data from SQL statement and split into height (x) and weight (y)
while (($x,$y) = $stmt->fetchrow_array)
{ 
    $n ++;
    $sumx += $x;
    $sumsqx  += $x*$x;
    $sumy += $y;
    $sumsqy += $y*$y;
    $sumprodxy += $x*$y;
}
## Close the statement and connection
$stmt->finish;
$dbh->disconnect;

# Error check for data pair quantities
if ($n<2)
  {
  print "Not enough data detected.";
  exit
  }

## Equations to produce the correlation coefficient
$varx  = ($sumsqx  - $sumx*$sumx/$n) / ($n - 1);
$vary  = ($sumsqy  - $sumy*$sumy/$n) / ($n - 1);
$covxy = ($sumprodxy - $sumx*$sumy/$n) / ($n - 1);
$r = $covxy / sqrt($varx * $vary);

# Error check for illegal divisions
if ($varx=0 or $vary=0)
  {
  print "Illegal division by 0: Check variance.";
  exit;
  }

# Print the results
print "\n\n",
      "<h5>The sum of heights (x) = $sumx\n</h5>", 
      "<h5>The sum of weights (y) = $sumy\n</h5>",
      "<h5>Variance of x = $varx\n</h5>",
      "<h5>Variance of y = $vary\n</h5>",
      "<h5>Covariance of x and y = $covxy\n</h5>",
      "<h5>Correlation coefficient (r) = $r \n\n</h5>";

# Ask user subroutine
sub ask_user
{ print "$_[0] [$_[1]]: ";
  my $rc = <>;
  chomp $rc;
  if($rc eq "") { $rc = $_[1]; }
  return $rc;
}

# End of Assignment3.pl