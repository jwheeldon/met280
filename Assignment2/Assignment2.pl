#---------------------------------------#
#     James Wheeldon - Assignment 2	#
#---------------------------------------#

#! user/local/bin/perl

## Import the Perl driver package 
use DBI;  

## Prompt the user for database connection information
print "\n\nPlease enter database connection details:\n";

$server =   ask_user ("  server", "localhost");
$database = ask_user ("database", "LegumeWeb_10_01");
$user =     ask_user ("    user", "bioinfo");
$password = ask_user ("password", "bioinfo");

## Establish a connection to the database
$dbh= DBI->connect("DBI:mysql:host=$server;port=3306;database=$database", 
                    $user, $password, {}) 
  or die "Couldn't connect to database: " . DBI->errstr;

## Create an SQL statement
$stmt = $dbh->prepare("show tables;");

## Execute the statement
$stmt->execute
  or die "Invalid SQL statement: " . DBI->errstr; 
   
print "\nListing all tables within $database:\n", "--------------------------\n";
   
## Loop to print every record returned
while (@result = $stmt->fetchrow_array)
{ # Print the fields of one record
  $i = 0;
  while ($field = $result[$i++])
  { print "| $field \t";
  }
  print "|\n";
}
print "--------------------------\n";
$stmt->finish;


## Prompt user input for country name
$country = ask_user ("Select country", "Great Britain");

## Check for country code (id) within Gazetteer table
$stmt = $dbh->prepare("select id from Gazetteer where name = '$country' and rank = 'country';");
$stmt->execute
 or die "Something went wrong: " . DBI->errstr; 

$id = "undef";
while (@result = $stmt->fetchrow_array)
{
	$i = 0;
	$id = $result[$i++];
}
$stmt->finish;

if ($id eq "undef")
{
  print "$country could not be found!\n";
  exit;
}

print "\n";

## Count all TaxonIds from $id (country code)
$stmt = $dbh->prepare("select count(distinct TaxonId) from Geography where gazetteerId = $id;");

$stmt->execute
  or die "Something went really wrong: " . DBI->errstr; 

while (@result = $stmt->fetchrow_array) #Fetch data from database
{
  $i = 0;
  print "Total number of species:\t\t";
  while ($field = $result[$i++])
  {
	print "$field\n";
  }
}
$stmt->finish;


## Count subspecies from taxonId using Taxon.rank
$stmt = $dbh->prepare("select count(distinct Geography.taxonId) from Geography, Taxon where Geography.gazetteerId = $id and Taxon.rank='subsp.' and Geography.taxonId = Taxon.id;");

$stmt->execute
  or die "Something went really really wrong: " . DBI->errstr; 

while (@result = $stmt->fetchrow_array)
{
  $i = 0;
  print "Of which, the number of subspecies is:\t";
  while ($field = $result[$i++])
  {
	print "$field\n";
  }
}
$stmt->finish;
print "\n";

        
## Close the statement and connection
$dbh->disconnect;

## Subroutine to prompt user for variable value, with default
sub ask_user
{ print "$_[0] [$_[1]]: ";
  my $rc = <>;
  chomp $rc;
  if($rc eq "") { $rc = $_[1]; }
  return $rc;
}

## End of Assignment2.pl