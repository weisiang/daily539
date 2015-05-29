#!/usr/bin/perl -w
use strict;
use GDBM_File;
#awk -F"##" '{print $3"\t"$4"\t"$5"\t"$6"\t"$7}' originalTextFile..............pre-command.
my $sum=0;
my $checkUniGram = 0 ;
my $checkBiGram =0   ;
my $checkTriGram =0  ;
my $checkFourGram =0 ;
my $checkFiveGram =0 ;
my $uniCount; my $biCount; my $triCount; my $fourCount; my $fiveCount;
my %uniGram ; my %biGram ; my %triGram ; my %fourGram ; my %fiveGram ; 
my %uniProb ; my %biProb ; my %triProb ; my %fourProb ; my %fiveProb ; 
my $minimum=0;
open( txtFile, $ARGV[0]) or die "don't open 539 txt file";
open (outProbFile , ">probFile.txt");
dbmopen (my %DATA , "probFileHash",0644) or die "can't open dbm!";
dbmopen (my %uniModel , "uniModel",0644) or die "can't  touch  dbm!";

#sort the number of lottery by increase.
while(<txtFile>)
{
	chomp $_;
	my @splitTxt = split /\t/ , $_;
	#my @sortSplit = sort @splitTxt;
	my @sortSplit =  @splitTxt;
	&unigram(@sortSplit);	
	&bigram(@sortSplit);	
	&trigram(@sortSplit);	
	&fourgram(@sortSplit);	
	&fivegram(@sortSplit);	
}
&uniProb;
&biProb;
&triProb;
&uniModel;
$DATA{"unk"}=log(exp($minimum)*0.001);
printf outProbFile "%s\t%s" , "unk",$DATA{"unk"};
close(outProbFile);
dbmclose(%DATA);
dbmclose(%uniModel);
#split N-Gram and N-Gram.Prob
sub unigram 
{
	for(my $i=0 ; $i<=$#_;$i++)
	{
		$uniCount++;
		if(!defined($uniGram{$_[$i]})) {$uniGram{$_[$i]}=1;}	
		else	{$uniGram{$_[$i]}++;}
	}
}
sub uniProb
{
	printf outProbFile "%s\n" , 'unigram...';
	foreach(keys %uniGram)
	{
		$uniProb{$_} = log($uniGram{$_} / $uniCount);
		printf outProbFile "%s\t%s\n" , $_ ,$uniProb{$_};
		$DATA{$_}=$uniProb{$_};
		#$uniModel{$_}=$uniProb{$_};
		$sum+=1-(exp $uniProb{$_});
	}	
}

sub bigram 
{
	for(my $i=0 ; $i<=$#_-1;$i++)
	{
		$biCount++;
		my $biGram = $_[$i] . $_[$i+1] ;
		if(!defined($biGram{$biGram}))	{$biGram{$biGram}=1;}
		else {$biGram{$biGram}++;}
	}
}
sub biProb
{
	printf outProbFile "%s\n" , 'bigram...';
	foreach(keys %biGram)
	{
		my @biGram = split '',$_;
		my $backOffGram = $biGram[0].$biGram[1];
		my $prob = log($biGram{$_}/$uniGram{$backOffGram});
		if($prob <= $minimum){$minimum = $prob;}
		printf outProbFile "%s\t%s\n" , $_ ,$prob ;	
		$DATA{$_}=$prob;
	}
}

sub trigram 
{
	for(my $i=0 ; $i <= $#_-2 ; $i++)
	{
		$triCount++;
		my $triGram = $_[$i] . $_[$i+1] . $_[$i+2];
		if(!defined($triGram{$triGram}))	{$triGram{$triGram}=1;}
		else {$triGram{$triGram}++;}
	}
}
sub triProb
{
	printf outProbFile "%s\n" , 'trigram...';
	foreach(keys %triGram)
	{
		my @triGram = split '',$_;
		my $backOffGram = $triGram[0].$triGram[1].$triGram[2].$triGram[3];
		my $prob = log($triGram{$_}/$biGram{$backOffGram});
		printf outProbFile "%s\t%s\n" , $_ ,$prob ;	
		$DATA{$_}=$prob;
	}
}

sub fourgram 
{
	for(my $i=0 ; $i <= $#_-3 ; $i++)
	{
		$fourCount++;
		my $fourGram = $_[$i] . $_[$i+1] . $_[$i+2] . $_[$i+3];
		if(!defined($fourGram{$fourGram}))	{$fourGram{$fourGram}=1;}
		else {$fourGram{$fourGram}++;}
	}
}

sub fivegram 
{
	for(my $i=0 ; $i <= $#_-4 ; $i++)
	{
		$fiveCount++;
		my $fiveGram = $_[$i] . $_[$i+1] . $_[$i+2] . $_[$i+3] . $_[$i+4];
		if(!defined($fiveGram{$fiveGram}))	{$fiveGram{$fiveGram}=1;}
		else {$fiveGram{$fiveGram}++;}
	}
}

#debug
if($checkUniGram == 1)
{
	foreach(keys %uniGram)
	{
		printf "%s\t%s\n" , $_ ,$uniGram{$_};
	}
}
if($checkBiGram == 1)
{
	foreach(keys %biGram)
	{
		printf "%s\t%s\n" , $_ ,$biGram{$_};
	}
}
if($checkTriGram == 1)
{
	foreach(keys %triGram)
	{
		printf "%s\t%s\n" , $_ ,$triGram{$_};
	}
}
if($checkFourGram == 1)
{
	foreach(keys %fourGram)
	{
		printf "%s\t%s\n" , $_ ,$fourGram{$_};
	}
}
if($checkFiveGram == 1)
{
	foreach(keys %fiveGram)
	{
		printf "%s\t%s\n" , $_ ,$fiveGram{$_};
	}
}
sub uniModel
{
	my $base = 1/$sum;
	foreach (keys %uniProb)
	{
		$uniModel{$_}=log($base*(1-(exp $uniProb{$_})));
	}
}
