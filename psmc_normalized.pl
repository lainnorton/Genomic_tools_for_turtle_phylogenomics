#USAGE:perl 2.new.pl spe_info_file.txt ./data/ > all_species_normalization.out

my $file1 = $ARGV[0];
open IN,$file1 or die $!;
my $tt = 0;
my $hash = {};
my $family_hash = {};
while(<IN>){
	chomp;
	my $name = (split(/\s+/,$_))[-2];
	my $family = (split(/\s+/,$_))[-1];
	$hash->{$tt} = $name;
	$family_hash->{$name} = $family;
	$tt++;
}
my $dir = $ARGV[1];
my @sample = glob("$dir*txt");
my $hash_result = {};my $lage_hash = {};
foreach my $sample(@sample){
	my $id = (split(/\//,$sample))[-1];
	$id =~ /(\d+)/;
	my $num = $1;
	my $name = $hash->{$num};
	open IN2,$sample or die $!;my $yami_hash = {};
	my $kk = 4;
	<IN2>;<IN2>;
	my $num = 1;
	$yami_hash->{0}->{year} = 0;
	$yami_hash->{0}->{Ne} = 0;
	while(<IN2>){
		my @array = split(/\t/,$_);
		next if $array[1] > 50;
		$yami_hash->{$num}->{year}= $array[0];
		$yami_hash->{$num}->{Ne} = $array[1];
		#print $array[1];
		$num++;
	}
	my $lage = 0;
	for(my $i = 10000;$i<=3200000;$i+=10000){
		my $op;my $ed;
		foreach (my $j = 0;$j<$num;$j++){
			if ($yami_hash->{$j}->{year} <= $i && $yami_hash->{$j+1}->{year} >= $i){
				$op = $yami_hash->{$j}->{Ne};$ed = $yami_hash->{$j+1}->{Ne};
				last;
			}
		}
		my $level = ($op+$ed)/2;
		$lage = $level if $level > $lage;
		$hash_result->{$name}->{$i} += $level;
	}
	$lage_hash->{$name} = $lage;
}
foreach my $key(keys %{$hash_result}){
	my $family = $family_hash->{$key};
	for(my $i = 10000;$i<=3200000;$i+=10000){
		my $Ne = 0;
		if (exists ($hash_result->{$key}->{$i})){
			$Ne = $hash_result->{$key}->{$i}/$lage_hash->{$key};
		}
		print "$key\t$i\t$Ne\t$family\n";
	}
}






=p
		my @array = split(/\s+/,$_);
		if ($kk > 0){
			push(L@ss,$array[1]);$kk--;
			push(@time,$array[0]);
		}
		else{
			shift(@ss);shift(@time);
			push (@ss,$array[1]);push (@time,$array[0]);
		}
		if ($kk == 0){
			if ($ss[4] == $ss[3] && $ss[3] > $ss[0] && $ss[3] > $ss[1] && $ss[3] > $ss[2] && $ss[3] > $ss[5] && ($ss[3]-$ss[0])/$ss[0] > 0.01){
				my $kk = ($time[3]+$time[4])/2;
				print $name."\t".$ss[1]."\t".$kk."\t1"."\n";
				#print $name."\t".$ss[1]."\t".$time[1]."\n";
				#print $name."\t".$ss[2]."\t".$time[2]."\n";
			}
		}
	}
}
			

	
