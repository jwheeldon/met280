#! user/local/bin/perl

#6 appropriately named variables

#$paircount;		Number of pairs in the data set
#$sum_x;		Sum of x values
#$sum_y;		Sum of y values
#$sum_xsq;		Sum of x**2
#$sum_ysq;		Sum of y**2
#$sum_pro_xy;		Sum of the products of x and y

#Requesting access and checking data file
print "What data file would you like to read?\n";
$file = <STDIN>;
chomp $file;

unless (open(INFO, $file))
{
    print "Could not open file $file!\n\n";
    exit;
}

#Printing the data file
open(INFO, $file);
print "\nThis file contains the following data (x,y):\n\n";
while ($line = <INFO>)
{
	($x,$y)=split(/,/, $line);	#Split function to seperate x and y
	print "Lbs:$x, Inches:$y";	#NEEDS ATTENTION
}
print "\n";
close(INFO);

#Statistical Methods
open(INFO, $file);
while (@data = <INFO>)
{
	print 	"The first data point is $data[0]";
	$paircount = @data; 	#Establishes size of the array
	print	"The last data point is ",$data[$paircount-1];
	print 	"This data set has $paircount entries (n=$paircount)\n\n";
	#WARNINGS: @data[0] better expressed as $data[0] due to scalar
}
close(INFO);

open(INFO, $file);
while ($line = <INFO>)
{
	($x,$y)=split(/,/, $line);
	@data = $y;			

	foreach $y1 (@data)
	{
		$sum_y+=$y;		#Sum of y values
		$ysq = $y**2;		#Square of each y value
		$sum_ysq+= $ysq;	#Cumulatively add each y**2
		$sum_pro_xy+=$y1*$x;	#Cumulatively add each xy value
	}

	foreach $x1 (@data)
	{
		$sum_x+=$x;		#Sum of x values
		$xsq = $x**2;		#Square of each x value
		$sum_xsq+= $xsq;	#Cumulatively add each x**2
	}
}
close(INFO);

#Formulae to calculate the correlation coefficient
$x_var = ($sum_xsq-(($sum_x**2)/$paircount))/($paircount-1);
$y_var = ($sum_ysq-(($sum_y**2)/$paircount))/($paircount-1);
$xy_covar = ($sum_pro_xy-(($sum_x*$sum_y)/$paircount))/($paircount-1);
$r = ($xy_covar)/(sqrt ($x_var*$y_var));

#Checking numbers and print the analysis
print	"The number of pairs (n):		$paircount\n",
	"The sum of x:				$sum_x\n",
	"The sum of y:				$sum_y\n",
	"The sum of x**2:			$sum_xsq\n",
	"The sum of y**2:			$sum_ysq\n",
	"The sum of the products of x and y:	$sum_pro_xy\n\n";

print	"The variance of x is:			$x_var\n",
	"The variance of y is:			$y_var\n",
	"The covariance of x and y is:		$xy_covar\n",
	"The correlation coefficient (r) is:	$r\n\n";
