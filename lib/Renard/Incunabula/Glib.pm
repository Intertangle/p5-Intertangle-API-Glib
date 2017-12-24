use Modern::Perl;
package Renard::Incunabula::Glib;
# ABSTRACT: Helper for using Glib

use strict;
use warnings;

use Glib;

=method Inline

  use Inline C with => qw(Renard::Incunabula::Glib);

Returns the flags needed to configure L<Inline::C> for using the
L<Glib> XS API.

=cut
sub Inline  {
	return unless $_[-1] eq 'C';

	require ExtUtils::Depends;
	my $ref = ExtUtils::Depends::load('Glib');

	my $config = +{ map { uc($_) => $ref->{$_} } qw(inc libs typemaps) };

	# Set CCFLAGSEX to the value of INC directly. This is to get around some
	# shell parsing / quoting bug that causes INC to quote parts that
	# should not be quoted.
	$config->{CCFLAGSEX} = delete $config->{INC};

	$config->{AUTO_INCLUDE} = <<C;
#include <gperl.h>
C

	$config;
}

1;
