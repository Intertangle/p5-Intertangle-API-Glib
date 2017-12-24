use Modern::Perl;
package Renard::Incunabula::Glib;
# ABSTRACT: Helper for using Glib

use strict;
use warnings;

use Glib;
use List::MoreUtils qw(zip);

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

	# Add the Glib.pm dynamic library to access the `gperl` symbols. This
	# is usually handled automatically by simply loading Glib.pm via
	# DynaLoader, but on Windows, it must be explicitly linked.
	if( $^O eq 'MSWin32') {
		my %dl_module_to_so = zip( @DynaLoader::dl_modules, @DynaLoader::dl_shared_objects );
		$config->{MYEXTLIB} = $dl_module_to_so{Glib};
	}

	$config->{AUTO_INCLUDE} = <<C;
#include <gperl.h>
C

	$config;
}

1;
