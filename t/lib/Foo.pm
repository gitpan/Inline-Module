package Foo;
strict;
our $VERSION = '1.23';

use Inline::Module Upper => 'upcase';

sub foo {
    return upcase(shift);
}

1;
