package Upper;
use strict;
our $VERSION = '3.21';

use base 'Exporter';

our @EXPORT_OK = qw'upcase';

sub upcase {
    uc(shift);
}

1;
__END__

=head1 NAME

Upper - Up Up and Away

=cut
