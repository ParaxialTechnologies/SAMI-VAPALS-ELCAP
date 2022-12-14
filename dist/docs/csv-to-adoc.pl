#!/usr/bin/env perl

use POSIX qw{ strftime };

sub dequote {
    my $t = shift;
    $t =~ s/^"//;
    $t =~ s/"$//;
    return $t;
}

for my $fn (@ARGV) {
    die "Can't open $fn; stopped"  if( ! open( F, '<', $fn ) );
    my $headerlines = 1;
    my @lines;
    my @items;
    while (<F>) {
        chomp;
        @items = map { dequote( $_ ) } split( /\t/ );
        # Postprocessing goes here.
        push( @lines, [ @items ] );
    }
    my $nitems = scalar( @items );
    close( F );
    # Figure out field lengths.
    my @fl;
    for (my $i = 0; $i < $nitems; $i++) {
        my $thislen;
        my $maxlen;
        my @fieldn = map { $_->[$i] } @lines;
        for my $f (@fieldn) {
            $thislen = length( $f );
            $maxlen = $thislen  if ($thislen > $maxlen);
        }
        push( @fl, $maxlen );
    }
    my @format;
    my @cols;
    for my $fl (@fl) {
        push( @cols, sprintf( "<.<%dv", $fl ) );
        push( @format, sprintf( "%%-%ds", $fl ) );
    }
    my $cols = join( ',', @cols );
    my $format = '| ' . join( ' | ', @format ) . "\n";
    print "format = $format";
    my $outfn = $fn;
    $outfn =~ s/.csv$//;
    $outfn .= '.adoc';
    die "Can't open $outfn; stopped"  if( ! open( OUT, '>', $outfn ) );
    my $today = strftime( "%Y-%m-%d", localtime( time ) );
    print( OUT <<"EOT" );
:doctitle:    ($fn)
:mastimg:     aboutvista
:mastcaption: Vista consultants
:mastdesc:    Real-time patient information means real care

== Title

Last updated $today from the spreadsheet.

EOT
    print( OUT qq{[cols="$cols",options="header"]\n} );
    print( OUT "|" . ('=' x 78) . "\n" );
    for my $line (@lines) {
        printf( OUT $format, @{$line} )
    }
    print( OUT "|" . ('=' x 78) . "\n" );
    close( OUT );
}
