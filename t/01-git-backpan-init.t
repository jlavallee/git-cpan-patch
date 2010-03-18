#!perl

use strict;
use warnings;

use Test::More tests => 3;

use autodie qw/:all/;
use File::Temp qw(tempdir);

use Git::CPAN::Patch::Import;

my $distribution = 'Acme-Pony';

my $tempdir = tempdir( CLEANUP => 1 );

#diag("using temp directory $tempdir");

chdir $tempdir;

ok( Git::CPAN::Patch::Import::import_from_backpan(
        $distribution,
        { #mkdir => $distribution,
          init_repo => 1,
        }
    )
);


# this should fail because we're already in a git repo
eval { 
    Git::CPAN::Patch::Import::import_from_backpan(
        $distribution,
        { init_repo => 1,
        }
    )
};

like($@, qr/^Aborting: git repository already present/);


# this time it should pass, because we're forcing it
ok( Git::CPAN::Patch::Import::import_from_backpan(
        $distribution,
        { init_repo => 1,
          force     => 1,
        }
    )
);
