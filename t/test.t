use t::TestInlineModule tests => 1;

BEGIN {
    unlink 't/lib/Foo.pmc';
}

use Foo;

run_is pm => 'pmc';

sub clip {
    s/(.*\n){8}//;
}

__DATA__
=== Inline a module
--- pm read_file clip: t/lib/Foo.pmc
--- pmc
package Foo;
strict;
our $VERSION = '1.23';

# use Inline::Module Upper => 'upcase';

BEGIN { $INC{'Upper.pm'} = 'Inline::Module' }
BEGIN { # begin Inline::Module Upper
package Upper;
use strict;
our $VERSION = '3.21';

use base 'Exporter';

our @EXPORT_OK = qw'upcase';

sub upcase {
    uc(shift);
}

1;
} # end Inline::Module Upper
use Upper 'upcase';

sub foo {
    return upcase(shift);
}

1;
