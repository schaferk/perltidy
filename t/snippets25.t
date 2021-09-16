# Created with: ./make_t.pl

# Contents:
#1 novalign.def
#2 novalign.novalign

# To locate test #13 you can search for its name or the string '#13'

use strict;
use Test::More;
use Carp;
use Perl::Tidy;
my $rparams;
my $rsources;
my $rtests;

BEGIN {

    ###########################################
    # BEGIN SECTION 1: Parameter combinations #
    ###########################################
    $rparams = {
        'def'      => "",
        'novalign' => "-novalign",
    };

    ############################
    # BEGIN SECTION 2: Sources #
    ############################
    $rsources = {

        'novalign' => <<'----------',
# simple vertical alignment of '=' and '#'
my $lines = 0;    # checksum: #lines
my $bytes = 0;    # checksum: #bytes
my $sum = 0;    # checksum: system V sum
my $patchdata = 0;    # saw patch data
my $pos = 0;    # start of patch data
my $endkit = 0;    # saw end of kit
my $fail = 0;    # failed

----------
    };

    ####################################
    # BEGIN SECTION 3: Expected output #
    ####################################
    $rtests = {

        'novalign.def' => {
            source => "novalign",
            params => "def",
            expect => <<'#1...........',
# simple vertical alignment of '=' and '#'
my $lines     = 0;    # checksum: #lines
my $bytes     = 0;    # checksum: #bytes
my $sum       = 0;    # checksum: system V sum
my $patchdata = 0;    # saw patch data
my $pos       = 0;    # start of patch data
my $endkit    = 0;    # saw end of kit
my $fail      = 0;    # failed

#1...........
        },

        'novalign.novalign' => {
            source => "novalign",
            params => "novalign",
            expect => <<'#2...........',
# simple vertical alignment of '=' and '#'
my $lines = 0;    # checksum: #lines
my $bytes = 0;    # checksum: #bytes
my $sum = 0;    # checksum: system V sum
my $patchdata = 0;    # saw patch data
my $pos = 0;    # start of patch data
my $endkit = 0;    # saw end of kit
my $fail = 0;    # failed

#2...........
        },
    };

    my $ntests = 0 + keys %{$rtests};
    plan tests => $ntests;
}

###############
# EXECUTE TESTS
###############

foreach my $key ( sort keys %{$rtests} ) {
    my $output;
    my $sname  = $rtests->{$key}->{source};
    my $expect = $rtests->{$key}->{expect};
    my $pname  = $rtests->{$key}->{params};
    my $source = $rsources->{$sname};
    my $params = defined($pname) ? $rparams->{$pname} : "";
    my $stderr_string;
    my $errorfile_string;
    my $err = Perl::Tidy::perltidy(
        source      => \$source,
        destination => \$output,
        perltidyrc  => \$params,
        argv        => '',             # for safety; hide any ARGV from perltidy
        stderr      => \$stderr_string,
        errorfile   => \$errorfile_string,    # not used when -se flag is set
    );
    if ( $err || $stderr_string || $errorfile_string ) {
        print STDERR "Error output received for test '$key'\n";
        if ($err) {
            print STDERR "An error flag '$err' was returned\n";
            ok( !$err );
        }
        if ($stderr_string) {
            print STDERR "---------------------\n";
            print STDERR "<<STDERR>>\n$stderr_string\n";
            print STDERR "---------------------\n";
            ok( !$stderr_string );
        }
        if ($errorfile_string) {
            print STDERR "---------------------\n";
            print STDERR "<<.ERR file>>\n$errorfile_string\n";
            print STDERR "---------------------\n";
            ok( !$errorfile_string );
        }
    }
    else {
        if ( !is( $output, $expect, $key ) ) {
            my $leno = length($output);
            my $lene = length($expect);
            if ( $leno == $lene ) {
                print STDERR
"#> Test '$key' gave unexpected output.  Strings differ but both have length $leno\n";
            }
            else {
                print STDERR
"#> Test '$key' gave unexpected output.  String lengths differ: output=$leno, expected=$lene\n";
            }
        }
    }
}