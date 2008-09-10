use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WWW::Content::Inventory',
    AUTHOR              => 'ben hengst <NOTBENH@CPAN.org>',
    VERSION_FROM        => 'lib/WWW/Content/Inventory.pm',
    ABSTRACT_FROM       => 'lib/WWW/Content/Inventory.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WWW-Content-Inventory-*' },
);
