#!usr/bin/perl -w

open FA,"final_all_species.fasta";
my $cut_length=3000;
my $gap=50000;
my $total_len;

$/=">";
<FA>;
my %hash;
while (<FA>) {
	chomp;
	my @info = split "\n";
	my $name = shift @info;
	my $seq = join "", @info;
	$hash{$name}=$seq;
	$total_len=length($seq);
}

my @random=(162,378,574,848,268);

`mkdir -p each_seq`;
open LI,">each_seq/list";
my $i=1;
foreach my $random(@random){
	for(my $pos=0;$pos<$total_len-$cut_length-$gap;){
		open O,">each_seq/seq.$i";
		foreach my $key(sort keys %hash){
			my $seq=substr($hash{$key},$pos+$random,$cut_length);
			print O ">$key\n$seq\n";
		}
		close O;
		`perl Fasta2Phylip.pl each_seq/seq.$i each_seq/seq.$i.phy`;
		print LI "seq.$i\n";
		$i++;
		$pos=$pos+$cut_length+$gap;
	}
}
