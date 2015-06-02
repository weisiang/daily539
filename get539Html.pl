#!/usr/bin/perl -w
use strict;
use LWP::Simple;

open( tempFile , ">tempNumberOut") or die "can't touch the file !";
open( File , ">numberOut") or die "can't touch the file !";
my $File = 'numberOut';
for(my $i=2015 ; $i>=2007 ; $i--)
{
	my $Y = get "http://lotto.auzonet.com/daily539/list_$i\_all.html";
	
	foreach($Y)
	{
		s/<[^>]*>//g;
		print tempFile;
	}

}
close(tempFile);
open( tempFile , "<tempNumberOut") or die "can't touch the file !";
my $count=0;
while(<tempFile>)
{
	if(/[0-9]{9,11}/)
	{
		$count++;
		chomp;
		chop;
		s/^\s*//g;
		s/ *$//g;
		print File "$_\t";
	}
	if(/[0-9]{4}-[0-9]{2}-[0-9]{2}/)
	{
		$count++;
		chomp;
		chop;
		s/^\s*//g;
		s/ *$//g;
		print File "$_\t";
	}
	if(/\b[0-9]{2} [0-9]{2}/)
	{
		$count++;
		chomp;
		chop;
		s/^\s*//g;
		s/ *$//g;
		if(($count%4)==0){print File "$_\n";}
		else{print File "$_\t";}
	}
}
system "rm tempNumberOut";
close(tempFile);
