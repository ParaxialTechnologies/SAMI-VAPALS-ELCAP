#!/usr/bin/env perl

use POSIX qw{ strftime };

sub dequote {
    my $t = shift;
    $t =~ s/^"//;
    $t =~ s/"$//;
    return $t;
}

sub log10 {
    my $n = shift;
    return log($n) / log(10);
}

my $info = {};

for my $fn (@ARGV) {
    die "Can't open $fn; stopped"  if( ! open( F, '<', $fn ) );
    my $headerskip = 0;
    my $fldnum = 0;
    my $subnum = 0;
    my $lineno = 0;
    my $oldfldn;
    while (<F>) {
        ++$lineno;
        chomp;
        my ($subn, $fldn, $title, $dtype, $req,
            $indx, $edit, $val, $def, $cmt) =
            map { dequote( $_ ); } split( /\t/ );
        # print "$lineno > ",
        #     join( ' : ', $subn, $fldn, $title, $dtype, $req,
        #           $indx, $edit, $val, $def, $cmt),
        #     "\n";
        if( ! $headerskip ) {
            $headerskip = 1;
            # print "Skipped header.\n";
            next;
        }
        if (! $fldn) {
            if ($oldfldn) {
                $fldn = $oldfldn;
            } else {
                die "File doesn't start with a field name; stopped";
            }
            ++$subnum;
        } else {
            $info->{'max'}->{$fldnum} = $subnum  if( $fldnum );
            # print "Filing max = $fldnum/$subnum\n"  if( $fldnum );
            ++$fldnum;
            $subnum = 1;
        }
        $req = ($req =~ /^Y/i ? 'Y' : '');
        $indx = ($indx =~ /^Y/i ? 'Y' : '');
        $edit = ($edit =~ /^N/i ? 'N' : '');
        # print "Fld/Subnum now $fldnum/$subnum\n";
        my $cmpnum = sprintf( "%05d.%05d", $fldnum, $subnum );
        if ($subnum != $subn) {
            warn "Sub #s don't match ($subnum != $subn)";
        }
        $info->{$cmpnum} = {
           'fldnum' => $fldnum,
           'subn'   => $subn,
           'subnum' => $subnum,
           'fldn'   => $fldn,
           'title'  => $title,
           'dtype'  => $dtype,
           'req'    => $req,
           'indx'   => $indx,
           'edit'   => $edit,
           'val'    => $val,
           'def'    => $def,
           'cmt'    => $cmt
        };
        $oldfldn = $fldn  if( $fldn );
    }
    close( F );
    for my $cmpnum (sort keys %{$info}) {
        next  if ($cmpnum eq 'max');
        my $i = $info->{$cmpnum};
        my $max = $info->{'max'}->{$i->{'fldnum'}} || 1;
        my $multiline = ($max != 1);
        $cmpnumfmt = sprintf( '%%d.%%0%dd', log10( $max ) + 1 );
        my $def = $i->{'def'};
        my $cmt = $i->{'cmt'};
        if( $def ) {
            if( $cmt ) {
                $def .= " [$cmt]";
            }
        } else {
            if( $cmt ) {
                $def = "[$cmt]";
            }
        }
        if ($multiline) {
            if ($i->{'subnum'} == 1) {
                $info->{$cmpnum}->{'out'} = sprintf(
                    join( " ",
                          ".%d+| %-10s",   # fldn
                          ".%d+| %-57s",   # title
                          ".%d+| %-9s",    # dtype
                          ".%d+| %-4s",    # req
                          ".%d+| %-5s",    # indx
                          ".%d+| %-5s",    # edit
                          "| %6s",         # composite numbering
                          "%s| %5s",       # val
                          "%s| %s\n"       # def/cmt
                    ),
                    $max, $i->{'fldn'},
                    $max, $i->{'title'},
                    $max, $i->{'dtype'},
                    $max, $i->{'req'},
                    $max, $i->{'indx'},
                    $max, $i->{'edit'},
                    sprintf( $cmpnumfmt, $i->{'fldnum'}, $i->{'subnum'} ),
                    ($i->{'val'} eq '-' ? 'v' : ''),
                    $i->{'val'},
                    ($def eq '-' ? 'v' : ''),
                    ($def eq '-' ? '---' : $def)
                );
            } else {
                $info->{$cmpnum}->{'out'} = sprintf(
                    join( " ",
                          "| %6s",         # composite numbering
                          "%s| %5s",       # val
                          "%s| %s\n"         # def/cmt
                    ),
                    sprintf( $cmpnumfmt, $i->{'fldnum'}, $i->{'subnum'} ),
                    ($i->{'val'} eq '-' ? 'v' : ''),
                    $i->{'val'},
                    ($def eq '-' ? 'v' : ''),
                    ($def eq '-' ? '---' : $def)
                );
            }
        } else {
            $info->{$cmpnum}->{'out'} = sprintf(
                join( " ",
                      "| %-10s",   # fldn
                      "| %-57s",   # title
                      "| %-9s",    # dtype
                      "| %-4s",    # req
                      "| %-5s",    # indx
                      "| %-5s",    # edit
                      "| %6s",     # composite numbering
                      "%s| %5s",   # val
                      "%s| %s\n"   # def/cmt
                ),
                $i->{'fldn'},
                $i->{'title'},
                $i->{'dtype'},
                $i->{'req'},
                $i->{'indx'},
                $i->{'edit'},
                sprintf( $cmpnumfmt, $i->{'fldnum'}, $i->{'subnum'} ),
                ($i->{'val'} eq '-' ? 'v' : ''),
                $i->{'val'},
                ($def eq '-' ? 'v' : ''),
                ($def eq '-' ? '---' : $def)
            );
        }            
    }
    my $outfn = $fn;
    $outfn =~ s/.csv$//;
    $outfn .= '.adoc';
    die "Can't open $outfn; stopped"  if( ! open( OUT, '>', $outfn ) );
    my $today = strftime( "%Y-%m-%d", localtime( time ) );
    my $cols = join(
        ',',
        '<.<0m', # fldn
        '<.<0v', # title
        '<.<0v', # dtype
        '^.<0v', # req
        '^.<0v', # indx
        '^.<0v', # edit
        '>.<0v', # composite numbering
        '>.<0m', # val
        '<.<1v'  # def/cmt
    );
    print( OUT <<"EOT" );
:doctitle:    VA-PALS – Projects – Vista Expertise Network
:mastimg:     aboutvista
:mastcaption: Vista consultants
:mastdesc:    Real-time patient information means real care

== VA-PALS — Background form (++sbform++) data dictionary

Last updated $today from the spreadsheet.

[options="compact"]
* The R column indicates whether or not the field is required. The default is
  ``not required.''
* The X column indicates whether or not the field is indexed. The default is
  ``not indexed.''
* The E column indicates whether or not the field is editable. The default is
  ``editable.''
* The # column indicates the field number and subfield number, delimited by the
  decimal point.
* In 16.8, ``e.g.'' should have a comma after it.
* The +sbfcs+ fields (32.*) have an erroneous subfield numbers in the
  spreadsheet (5 and 6 instead of 1 and 2).
* In 135.3, 135.4, 136.4 and 136.5, some spreadsheet shenanigans occurred in
  the descriptions. This is due to automatic date translation because the
  fields weren't specified as strings with an initial quote mark.
* In 148.1, the data type is RDATE; I don't actually know what that is.

Here's the link:elcap-background-form-dd.csv[data dictionary in CSV format],
which you can open in OpenOffice or Excel.

Here's the link:elcap-background-form-ddr.csv[corrected version in CSV
format].

[cols="$cols",options="header",role="small"]
EOT
    print( OUT "|" . ('=' x 78) . "\n" );
    print( OUT sprintf(
                join( " ",
                      "| %-10s",   # fldn
                      "| %-57s",   # title
                      "| %-9s",    # dtype
                      "| %-4s",    # req
                      "| %-5s",    # indx
                      "| %-5s",    # edit
                      "| %6s",     # composite numbering
                      "| %5s",     # val
                      "| %s\n"     # def/cmt
                ),
               'Field name',
               'Title',
               'Data type',
               'R',
               'X',
               'E',
               '#',
               'Value',
               'Definition/Comments'
           ) );
    for my $cmpnum (sort keys %{$info}) {
        print( OUT $info->{$cmpnum}->{'out'} );
    }
    print( OUT "|" . ('=' x 78) . "\n" );
    close( OUT );
}
