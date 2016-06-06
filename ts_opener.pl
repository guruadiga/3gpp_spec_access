#!C:\strawberry\perl\bin\perl

# Author : Guru Adiga @ Adiga Software
# This scripts opens the latest version of a TS (arg_1) of a Release (optional arg_2). Default release is Rel-9.
# If no TS is found then the TS opens the most appropriate directory in which the user can manualy choose a TS.
# Gold mining @ 

use strict;

my ($ts, $rel) = @ARGV;

$rel = 9 if !$rel;

my $dirname = "C:\\Data\\K-Base\\spec";

opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
my @files = sort by_year grep {/(\d+)$/} readdir $dh ;
closedir $dh;

sub by_year
{
    my $aa;
    my $bb;

    $a =~ /(\d+)$/;
    $aa = $1;
    $b =~ /(\d+)$/;
    $bb = $1;

    return $aa <=> $bb;
}


sub by_ver
{
    my $aa;
    my $bb;

    $a =~ /v(\d+)/;
    $aa = $1;
    $b =~ /v(\d+)/;
    $bb = $1;

    return $aa <=> $bb;
}


$dirname .= "\\$files[$#files]\\etsi_ts";

opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
@files = grep {/(\d+)$/} readdir $dh ;
closedir $dh;

foreach (@files)
{
    /^(\d+)_(\d+)$/;

    if( ("1$ts" >= $1) && ("1$ts" <= $2) )
    {
        $dirname .= "\\$_";
        last;
    }
}

opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
@files = grep {/^ts_/} readdir $dh ;
closedir $dh;

my @funnel3 = sort by_ver grep {/v0?$rel/} grep {/ts_1$ts.+pdf/} @files;

$dirname .= "\\".$funnel3[$#funnel3];

system "explorer $dirname";
