#!/usr/bin/perl

#
# Perl Weekly Challenge - 077
#
# Task #2: Lonely X
#
# https://perlweeklychallenge.org/blog/perl-weekly-challenge-077/
#

use strict;
use warnings;
use Test::More;
use Test::Deep;

my $example_1 = [ ['O', 'O', 'X'],
                  ['X', 'O', 'O'],
                  ['X', 'O', 'O'],
                ];

my $example_2 = [ ['O', 'O', 'X', 'O'],
                  ['X', 'O', 'O', 'O'],
                  ['X', 'O', 'O', 'X'],
                  ['O', 'X', 'O', 'O'],
                ];

is_deeply([find_lonely_x($example_1)], [[1, 3]],        "example 1");
is_deeply([find_lonely_x($example_2)], [[1, 3], [3,4]], "example 2");

done_testing;

#
#
# METHODS

sub find_lonely_x {
    my ($matrix) = @_;

    my $rows = $#$matrix;
    my $cols = $#{$matrix->[0]};

    my @lonely_x = ();
    foreach my $row (0..$rows) {
        foreach my $col (0..$cols) {
            next unless $matrix->[$row][$col] eq 'X';

            my @neighbours = ();
            # top
            push @neighbours, $matrix->[$row-1][$col] if $row > 0;

            # bottom
            push @neighbours, $matrix->[$row+1][$col] if $row < $rows;

            # left
            push @neighbours, $matrix->[$row][$col-1]   if $col > 0;
            # diagonal top left
            push @neighbours, $matrix->[$row-1][$col-1] if $row > 0     && $col > 0;
            # diagonal bottom left
            push @neighbours, $matrix->[$row+1][$col-1] if $row < $rows && $col > 0;

            # right
            push @neighbours, $matrix->[$row][$col+1]   if $col < $cols;
            # diagonal top right
            push @neighbours, $matrix->[$row-1][$col+1] if $row > 0     && $col < $cols;
            # diagonal bottom right
            push @neighbours, $matrix->[$row+1][$col+1] if $row < $rows && $col < $cols;

            push @lonely_x, [$row+1, $col+1]
                unless (grep /X/, @neighbours);
        }
    }

    return 0 if @lonely_x == 0;
    return @lonely_x;
}

sub p {
    my (@data) = @_;

    print "0\n" and return unless ref($data[0]);
    foreach (@data) {
        print sprintf("%s\n", join ", ", @$_);
    }
}

sub get_matrix {
    my ($rows, $cols) = @_;

    my $min    = 0;
    my $max    = 9;
    my $array  = [ 'X', 'O', 'X', 'X', 'X', 'O', 'O', 'O', 'X', 'O' ];
    my $matrix = [];

    foreach my $r (0..$rows) {
        foreach my $c (0..$cols) {
            $matrix->[$r][$c] = $array->[int($min + rand($max - $min))];
        }
    }

    display($matrix);
    return $matrix;
}

sub display {
    my ($matrix) = @_;

    print "Matrix:\n";
    foreach my $r (0..$#$matrix) {
        print sprintf("[ %s ]\n", join ', ', @{$matrix->[$r]});
    }
    print "\n";
}
