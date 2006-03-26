package Inline::Module;
use 5.006001;
use strict;
use warnings;
our $VERSION = '0.10';

use Module::Compile -base;

sub pmc_compile {
    my ($class, $source, $context) = @_;
    my $use = $context->{use};
    die unless defined $use;
    $use =~ /^\s*use\s+Inline::Module\s+([^\s;=]+)\s*(.*)/ or die;
    my ($module, $args) = ($1, $2);
    $module =~ s/^['"](.*)['"]$/$1/;
    $args =~ s/^(=>|,)\s*//;
    my $module_pm = "$module.pm";
    $module_pm =~ s/::/\//g;
    my $module_path = $class->find_module_path($module_pm) or die;
    open my $fh, $module_path
      or die "Can't open $module_path for input:\n$!";
    my $module_contents = do {local $/; <$fh>};
    close $fh;
    my $folded = $class->pmc_fold_blocks($module_contents);
    $folded =~ s/^__(DATA|END)__\r?\n.*//ms;
    $module_contents = $class->pmc_unfold_blocks($folded);
    chomp $module_contents;
    chomp $source;
    return <<"...";
# $context->{use}
BEGIN { \$INC{'$module_pm'} = 'Inline::Module' }
BEGIN { # begin Inline::Module $module
$module_contents
} # end Inline::Module $module
use $module $args
$source
...
}

sub find_module_path {
    my ($class, $module_pm) = @_;
    for my $dir (@INC) {
        my $path = "$dir/$module_pm";
        return $path if -e $path;
    }
    return;
}

1;

=head1 NAME

Inline::Module - Inline Other Modules in Your Modules

=head1 SYNOPSIS

    package Foo;

    use Inline::Module 'Bar';
    use Inline::Module Baz => qw'func1 func2';

=head1 DESCRIPTION

This module takes another module and compiles it inline.

=head1 AUTHOR

Ingy döt Net <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2006. Ingy döt Net. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
