#!/usr/bin/perl

use strict;


my $coilFile = "psipred_coil.bed";
my $helixFile = "psipred_helix.bed";
my $extendedFile = "psipred_extended.bed";

open(COIL, ">$coilFile") or die "Cannot open $coilFile for writing: $!";
open(HELIX, ">$helixFile") or die "Cannot open $helixFile for writing: $!";
open(BETA, ">$extendedFile") or die "Cannot open $extendedFile for writing: $!";


foreach my $seqFile (@ARGV) {
    open(FILE, $seqFile) or die "Cannot open file $seqFile for reading: $!";

    my $proteinId = $seqFile;

    $proteinId =~ s/\.ss2$//;

    while(my $line = <FILE>) {
        chomp $line;
        next unless($line);
        next if($line =~ /^#/);

        # remove any leading spaces
        $line =~ s/^\s*//;

        my @a = split(/\s+/, $line);

        # bedgraph uses zero based coordinates
        my $start = $a[0] - 1;
        my $end = $a[0];

        my $coilScore = $a[3] * 10;
        my $coilRoundedScore = sprintf("%.0f", $coilScore);

        my $helixScore = $a[4] * 10;
        my $helixRoundedScore = sprintf("%.0f", $helixScore);

        my $betaScore = $a[5] * 10;
        my $betaRoundedScore = sprintf("%.0f", $betaScore);

        print COIL join("\t", $proteinId, $start, $end, $coilRoundedScore) . "\n";
        print HELIX join("\t", $proteinId, $start, $end, $helixRoundedScore) . "\n";
        print BETA join("\t", $proteinId, $start, $end, $betaRoundedScore) . "\n";
    }

    close FILE;
}


close COIL;
close HELIX;
close BETA;
