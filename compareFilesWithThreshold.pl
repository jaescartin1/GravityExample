use warnings;
use strict;

@ARGV == 2 or die qq[Usage: perl $0 file1 file2\n];

my $num_file = 1;
my %line;

while ( <> ) {
        chomp;
        my @f = split /\|/;

        if ( $num_file == 1 ) {
                $line{ "@f[0..$#f-1]" } = $f[-1];
                next;
        }

        if ( $num_file == 2 ) {
                if ( exists $line{ "@f[0..$#f-1]" } and abs( $line{ "@f[0..$#f-1]" } - $f[-1] ) > 0.1 ) {
                        printf "> %s\n< %s\n", 
                                join( "|", @f[0..$#f-1], $line{ "@f[0..$#f-1]" } ),
                                join( "|", @f[0..$#f-1], $f[-1] );
                }
        }
} continue {
        ++$num_file if eof;
}

# Usage: $ perl script.pl file1 file2

