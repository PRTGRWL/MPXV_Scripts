#!/usr/bin/perl -w
use strict;
use warnings;

# @ Preeti Agarwal
# Cite : Preeti Agarwal, Nityendra Shukla, Ajay Bhatia,Sahil Mahfooz*, Jitendra Narayan* **Comparative Genome Analysis Reveals Insights into Driving Forces behind Monkeypox Virus Evolution and Sheds Light on the Active Role of Trinucleotide Motif ATC** 2023
# Contact : prtgrwl8@gmail.com
#USAGE : perl script_1.pl input_1.txt input_2.fa 404_genomes.fa>final                                                         

#USAGE                                                             #{ ADD list of motif in loop to extend N on both side till 10Ns}
my $num=1;

my @all_result;
my %all_identifier;

for($a=1;$a<=10;$a=$a+1){


        open (FH,$ARGV[0]) or die 'input not proper';
        open (FH2, '>>', $ARGV[1]) or die 'tmp file';
        #print "Working with $a\n";

        while (<FH>){
        chomp;
        my $newN='N' x $a;
        print FH2 ">$._$num\n$newN$_$newN\n";

$num++;
}

close FH;
close FH2;
}

system ("seqkit locate -i -d -P -f $ARGV[1] $ARGV[2] >out_locate$ARGV[2].tsv");                       # { Seqkit locate used to find nucleotide for N's in 404 genome}

my %merge;
open (FH3,"out_locate$ARGV[2].tsv") or die 'error';
#open (FH3,"out.tsv") or die 'error';
my @all_lines=<FH3>;

for(my $i=1;$i<=$#all_lines;$i=$i+1){
        my @array=split(/\t/,$all_lines[$i]);
        $merge{"$array[2]:$array[1]"}=$i;
    #print "print all_lines $all_lines[$i]\t $array[2]***\n";
}

foreach my $old_k(keys %merge){

my @new_k=split(/:/,$old_k);
my $k=$new_k[0];
my @k_real=split(/_/,$new_k[1]);
#print "$k\n";
        my @loci;
        for( my $j=1;$j<=$#all_lines;$j=$j+1){
                my @array2=split(/\t/,$all_lines[$j]);
                map {s/^\s+|\s+$//g} @array2;
                if ($k eq $array2[2]) {
                #$array2[6]=~ s/\n//g;;
                #=~s/\r|\n//g;
                #print "$k, $array2[2], jitendra $array2[6]\n";   #{$k and $array2[2] are same i.e. pattern NNNNCAGAAACAGAAANNNN, NNNNCAGAAACAGAAANNNN, jitendra CTCTCAGAAACAGAAACTTG}

                push (@loci,$array2[6]);
                }
        }

map {s/^\s+|\s+$//g} @loci;
my @unique_loci = do { my %seen; grep { !$seen{$_}++ } @loci };
next if !@unique_loci;

my $string_loci=join(",",@unique_loci);
#print "$string_loci\n";
my $loci_cnt=scalar(@unique_loci);

#if (@loci) {print "$k_real[0]\t$k\t$string_loci\t$loci_cnt\n";}

my $result="$k_real[0]\t$k\t$string_loci\t$loci_cnt";
    #print "$result";
my %all_identifier;

   if ($loci_cnt==1) {
        push (@all_result, $result);
         $all_identifier{$k_real[0]}=1;
  print "$result\n";
 }


undef @loci;
}
exit;
