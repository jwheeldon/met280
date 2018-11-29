

James Wheeldon, PhD student - Cardiff University

Assignment 2 Readme File

October 2015



Submitted as part of MSc Bioinformatics for the MET280 Computing for Bioinformatics module.



========
CONTENTS
========


1.1 About this program

1.2 How to use this program


1.3 How to modify this program



========



1.1 About this program

This perl program is designed to retrieve a count of total species and subspecies from the LegumeWeb_10_01 database on the Biodiversity server using the Perl Database Interface (DBI) driver package.


1.2 How to use this program



Begin by making an SSH connection to the Biodiversity server (biodiversity.cs.cf.ac.uk) via an SSH client such as 'PuTTY'. Run the perl program within the server, which will prompt the user to input database connection details (note that default values are already given). The program will print a list of tables within the database and will ask the user to specify a country, of which the program will return the number of species and subspecies of plant of the Leguminosae family found in the database.


1.3 How to modify this program





Should the user want to change default values, the ask_user subroutine function may be altered. The format is 'ask_user ("Input text","Default value");'.

========
