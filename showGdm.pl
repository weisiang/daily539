#!/usr/bin/perl -w
use strict;
use GDBM_File;

dbmopen(my %hash , $ARGV[0] , 0444) or die "can't open $ARGV[0] !!";

while((my $key , my $value)=each %hash)
{
	printf "%s\t%s\n" , $key , $value;
}
