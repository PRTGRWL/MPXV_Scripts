
#!/usr/bin/perl -w
use strict;
use warnings;

# @ Preeti Agarwal
# Cite : Preeti Agarwal, Nityendra Shukla, Ajay Bhatia, Sahil Mahfooz*, Jitendra Narayan* **Comparative Genome Analysis Reveals Insights into Driving Forces behind Monkeypox Virus Evolution and Sheds Light on the Active Role of Trinucleotide Motif ATC** 2023
# Contact : prtgrwl8@gmail.com
#USAGE : perl script_2.pl > Result.tsv                                                       

my @abc;
my %all_identifier;
my @all_result;

open (FH,"final") or die 'error';
    while (<FH>){
        chomp;

        @abc= split(/\t/,$_);
        #Store all informations
        if ($abc[3]==1) {
                push (@all_result, $_);
                $all_identifier{$abc[0]}=1;
        }
    }

# process unique file
my $pattern_len1;

foreach my $key (keys %all_identifier){
        #print "$key\n";
        my $pat="N"; my $idf=0; my $str="M";
        foreach (@all_result){
        my @split_val = split(/\t/);
                if ($split_val[0] == $key) {
                my $pat_len = length ($pat);
                my $str_len = length ($split_val[2]);
                        if ($str_len > $pat_len) {
                                $pat = $split_val[2];
                                $idf = $split_val[0];
                                $str = $split_val[1];
                        }
                }
        }
my $flen=length($pat);
print "$idf\t$str\t$pat\t$flen\n";
}
