use strict;
use warnings;

use Test::More;
use Finance::Bank::JP::MUFG;

subtest q{Lack the contract number.} => sub {
    eval {
        my $mufg = Finance::Bank::JP::MUFG->new(
            contract_no => undef,
            password    => 'inaccurate_password',
        );
    };
    like( $@, qr/^Contract number and password are required./ );
};

subtest q{Lack the password.} => sub {
    eval {
        my $mufg = Finance::Bank::JP::MUFG->new(
            contract_no => '12345678',
            password    => undef,
        );
    };
    like( $@, qr/^Contract number and password are required./ );
};

subtest q{Lack the both parameters.} => sub {
    eval { my $mufg = Finance::Bank::JP::MUFG->new(); };
    like( $@, qr/^Contract number and password are required./ );
};

subtest q{Normal test.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'inaccurate_password',
    );
    is( $mufg->{contract_no}, '12345678' );
    is( $mufg->{password},    'inaccurate_password' );
};

done_testing;
