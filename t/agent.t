use strict;
use warnings;

use Test::More;
use Finance::Bank::JP::MUFG;

subtest q{Default Agent.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'inaccurate_password',
    );
    is( $mufg->agent(), 'Mac Mozilla' );
};

subtest q{Windows IE 6.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'inaccurate_password',
        agent       => 'Windows IE 6',
    );
    is( $mufg->agent(), 'Windows IE 6' );
};

subtest q{Windows Mozilla.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'inaccurate_password',
        agent       => 'Windows Mozilla',
    );
    is( $mufg->agent(), 'Windows Mozilla' );
};

subtest q{Mac Safari.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'inaccurate_password',
        agent       => 'Mac Safari',
    );
    is( $mufg->agent(), 'Mac Safari' );
};

subtest q{Mac Mozilla.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'inaccurate_password',
        agent       => 'Mac Mozilla',
    );
    is( $mufg->agent(), 'Mac Mozilla' );
};

subtest q{Linux Mozilla.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'inaccurate_password',
        agent       => 'Linux Mozilla',
    );
    is( $mufg->agent(), 'Linux Mozilla' );
};

subtest q{Linux Konqueror.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'inaccurate_password',
        agent       => 'Linux Konqueror',
    );

    is( $mufg->agent(), 'Linux Konqueror' );
};

done_testing;
