#!/usr/bin/perl

use strict;

use Bio::SeqIO;
use Getopt::Long;

my ($file, $maxSequenceLength);

&GetOptions(
    "inputFile=s"               => \$file,
    "maxSequenceLength=i"       => \$maxSequenceLength
    );


open(SIZES, ">protein.sizes") or die "Cannot open file protein.sizes for writing: $!";

my $FILE_TYPE = "fasta";

my $seqio = Bio::SeqIO->new(-file => $file, -format => $FILE_TYPE);

while (my $seq = $seqio->next_seq) {
    my $id = $seq->id();
    my $sequence = $seq->seq();

    next if(length($sequence) > $maxSequenceLength);

    open(OUT, ">${id}.seq") or die "Cannot open file ${id}.seq for writing: $!";
    print OUT $sequence;
    close OUT;

    print SIZES $id, "\t", length($sequence), "\n";
}

$seqio->close();

close SIZES;


1;
