#!/usr/bin/perl -w 
use strict;
use GDBM_File;

=begin
	$ARGV[0] is 38Get6.txt fiel.
=end
=cut
my $uniWeight = 0.4 ; my $biWeight = 0.6;
my $t1 = time;
my $max=100;
dbmopen(my %biModelProb , "probFile\.gdbm" , 0644) or die "can't open DBM file!";
dbmopen(my %uniModelScore , "uniModel\.gdbm" , 0644) or die "can't open DBM file!";
dbmopen(my %predictResult , "predictResult\.gdbm" , 0644) or die "can't touch result file";
open(Get5 , $ARGV[0] ) or die "can't open 38Get5 file!";
my $unk = $biModelProb{"unk"};
my $top1=-9999999999999999999999;
my $process=0 ;my $totalProcess=1987690320; my $percent=0;
while(<Get5>)
{
	chomp $_;
	chop $_;
	my @list = split /\t/ ,$_;
	my $first=''; my $second='';  my $third=''; my $fourth=''; my $fifth=''; my $sixth='';
	my $biGramCombine='';
	my @scoreComponentBiModel=() , my @scoreComponentUniModel=();
	my $firstNumber=1 , my $secondNumber=2 , my $thirdNumber=3 , my $fourthNumber=4 , my $fifthNumber=5 , my $sixthNumber=6;
	my $startFirst=1 , my $firstSecond=2 , my $secondThird=3 , my $thirdFourth=4 , my $fourthFifth=5 , my $fifthSixth=6;

	for(my $i=0 ; $i<=$#list ;$i++)
	{
		$first = &checkNumber($list[$i]);
		$scoreComponentUniModel[$firstNumber] = $uniModelScore{$first};
		$scoreComponentBiModel[$startFirst] = &biModelScore($first);

		for(my $j=0 ; $j<=$#list ; $j++)
		{
			$second = &checkNumber($list[$j]);
			if($second == $first){next;}
			$biGramCombine = $first . $second;
			$scoreComponentUniModel[$secondNumber] = $uniModelScore{$second};
			$scoreComponentBiModel[$firstSecond] = &biModelScore($biGramCombine);
	
			for(my $k=0 ; $k<=$#list ; $k++)
			{
				$third = &checkNumber($list[$k]);
				if(($third == $first)or($third == $second)){next;}
				$biGramCombine =$second . $third;
				$scoreComponentUniModel[$thirdNumber] = $uniModelScore{$third};	
				$scoreComponentBiModel[$secondThird] = &biModelScore($biGramCombine);
				
				for(my $m=0 ; $m<=$#list ; $m++)
                         	{
                                	$fourth=&checkNumber($list[$m]);
                                	if(($fourth == $first)or($fourth == $second)or($fourth == $third)){next;}
					$biGramCombine = $third . $fourth;
					$scoreComponentUniModel[$fourthNumber] = $uniModelScore{$fourth};
					$scoreComponentBiModel[$thirdFourth] = &biModelScore($biGramCombine);

					for(my $n=0 ; $n<=$#list ; $n++)
					{
						$fifth = &checkNumber($list[$n]);
						if(($fifth ==$first)or($fifth ==$second)or($fifth ==$third)or
						($fifth ==$fourth)){next;}
						$biGramCombine = $fourth . $fifth;
						$scoreComponentUniModel[$fifthNumber] = $uniModelScore{$fifth};
						$scoreComponentBiModel[$fourthFifth] = &biModelScore($biGramCombine);
							my $combineScore=0;
							my $resultList = $first.$second.$third.$fourth.$fifth;
								
							for(my $t=$firstNumber ; $t<=$fifthNumber ; $t++)
							{
								$combineScore +=$uniWeight * $scoreComponentUniModel[$t]+ $biWeight * $scoreComponentBiModel[$t];
							}

							if($combineScore==$top1)
							{
								$predictResult{$resultList}= $combineScore;
							}
							if($combineScore>$top1)
							{
								undef %predictResult;
								$predictResult{$resultList}= $combineScore;
								$top1 = $predictResult{$resultList};
							}
							$process+=1;
							if($process%19876903==0)
							{
							$percent++;	
							printf "%s%s\n" , $percent, '%';
							}
					}
				}
			}
		}
	}
}
dbmclose(%biModelProb);
dbmclose(%predictResult);
close(Get5);
printf	"%s:%s\n" , "use", time-$t1 ;
sub checkNumber
{
	my $number = $_[0];
	my @add = split '',$number;
        if($#add==0){$number = '0'.$_[0];}
        else{$number = $_[0]};
}
sub biModelScore
{
	my $number = $_[0];
	if(!defined $biModelProb{$number}){$unk;}
	else{$biModelProb{$number};}
}
