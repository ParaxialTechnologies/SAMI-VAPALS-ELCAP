#!/usr/bin/env perl

use POSIX qw{ strftime };

sub dequote {
    my $t = shift;
    $t =~ s/^"//;
    $t =~ s/"$//;
    return $t;
}

sub fixtimezone {
    my ($thingy, $name) = @_;
    if( $thingy eq 'Eastern Standard Time' ) {
        $thingy = 'ET (--5/--4)';
    } elsif( $thingy eq 'Central Standard Time' ) {
        $thingy = 'CT (--6/--5)';
    } elsif( $thingy eq 'Mountain Standard Time' ) {
        if( $name =~ /AZ/ ) {
            $thingy = 'MT (--7/--7)';
        } else {
            $thingy = 'MT (--7/--6)';
        }
    } elsif( $thingy eq 'Pacific Standard Time' ) {
        $thingy = 'PT (--8/--7)';
    } elsif( $thingy eq 'Alaskan Standard Time' ) {
        $thingy = 'AKT (--9/--8)';
    } elsif( $thingy eq 'Hawaiian Standard Time' ) {
        $thingy = 'HT (--9/--8)';
    } elsif( $thingy eq 'Taipei Standard Time' ) {
        # Incorrect; Philippines have had their own time zone since 1899.
        # Also, "Taipei" is political dynamite.
        $thingy = 'PHT (+8/+8)';
    } elsif( $thingy eq 'TimeZone' ) {
    } else {
        $thingy .= " (UNKNOWN)";
    }
    return $thingy;
}

sub postprocess {
    my @items = @_;
    # clean up.
    @items = map {
        s/^\s+//;
        s/\s+$//;
        s/FY\d\d//g;
        s/Mountian/Mountain/g;
        $_; } @items;
    # Remove crap from full name.
    $items[2] =~ s/\s*\(CACHE 5\.0\)//;
    # Fix time zones to useful values.
    $items[5] = fixtimezone( $items[5], $items[2] );
    # Combine DistrictName and DistrictNumber
    if( $items[9] eq 'DistrictName' ) {
        $items[9] = 'District';
    } else {
        $items[9] .= " ($items[10])";
    }
    splice( @items, 10, 1 ); # Drop the DistrictNumber.
    splice( @items, 7, 2 ); # Drop the FY16 District info.
    splice( @items, 4, 1 ); # Drop the Active column.
    return @items;
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
        @items = postprocess( @items );
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

Last updated $today from the spreadsheet. Note that everything is current
through FY2017, except for Region (which seems to be current to FY2015). Some
information has been corrected and edited on the fly.

EOT
    print( OUT qq{[cols="$cols",options="header",role="small"]\n} );
    print( OUT "|" . ('=' x 78) . "\n" );
    for my $line (@lines) {
        printf( OUT $format, @{$line} )
    }
    print( OUT "|" . ('=' x 78) . "\n" );
    close( OUT );
}
