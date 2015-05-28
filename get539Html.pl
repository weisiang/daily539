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
while(<tempFile>)
{
	if(/[0-9]{9,11}/)
	{
		s/^ *//g;
		print File;
	}
	if(/\b[0-9]{2} /)
	{
		s/^ *//g;
		print File;
	}
}
system "rm tempNumberOut";
system "/home/nlp/tool/dataMining/outTrainingData.sh $File"
