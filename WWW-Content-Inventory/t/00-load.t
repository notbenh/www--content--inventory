#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'WWW::Content::Inventory' );
}

diag( "Testing WWW::Content::Inventory $WWW::Content::Inventory::VERSION, Perl $], $^X" );
