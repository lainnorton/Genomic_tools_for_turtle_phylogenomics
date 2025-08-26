use strict;
use warnings;
use Bio::SeqIO;

my @in=<align/*/pep.best.fas>;
my %seq;
my %name;
my $alllen=0;
my $number;

for my $in (sort @in){
    my $fa=Bio::SeqIO->new(-file=>"$in",-format=>"fasta");
    my $len;
    while (my $seq=$fa->next_seq) {
        my $id=$seq->id;
        my $seq=$seq->seq;
        $len=length($seq);
        my @id=split(/\|/,$id);
        $seq{$id[0]} .= $seq;
        $name{$id[0]} .= $id;
    }
    $alllen += $len;
    $number++;
}

open (O,">$0.list");
print O "Length:\t$alllen\tNumber:\t$number\n";
for my $k1 (sort keys %name){
    my $v=$name{$k1};
    my @v=split(/$k1\|/,$v);
    shift @v;
    print O "$k1\t",scalar(@v),"\t",join(",",@v),"\n";
}
close O;
open (O,">$0.connect.pep.fa");
for my $k1 (sort keys %seq){
    print O ">$k1\n$seq{$k1}\n";
}
close O;
