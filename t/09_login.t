use strict;
use warnings;

use Test::More;
use Test::MockObject::Extends;
use Finance::Bank::JP::MUFG;

subtest q{Normal login.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '00000001',
        password    => 'inaccurate_password',
    );
    my $mock      = Test::MockObject::Extends->new($mufg);
    my $mock_mech = Test::MockObject::Extends->new(
        WWW::Mechanize->new(
            autocheck => 1,
            ssl_opts  => { verify_hostname => 0 },
        )
    );

    $mock->set_always('_transition', '<html></html>');
    $mock->set_false('_exists_element');
    $mock->set_always('mech', $mock_mech);

    isa_ok($mock->login, 'Finance::Bank::JP::MUFG');
    ok($mock->_logged_in);
};

subtest q{Abnormal login.} => sub {
    eval {
        my $mufg = Finance::Bank::JP::MUFG->new(
            contract_no => '00000001',
            password    => 'inaccurate_password',
        )->login;
    };
    like($@, qr/^Login error./);
};

subtest q{Not logged in.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '00000001',
        password    => 'inaccurate_password',
    );

    eval { $mufg->accounts; };
    like($@, qr/^Not logged in./);

    eval { $mufg->transactions; };
    like($@, qr/^Not logged in./);

    eval { $mufg->download_transactions; };
    like($@, qr/^Not logged in./);
};

subtest q{Logout.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '00000001',
        password    => 'inaccurate_password',
    );
    my $mock = Test::MockObject::Extends->new($mufg);

    $mock->set_always('_transition', '<html></html>');
    $mock->set_false('_exists_element');
    $mock->login;
    $mock->logout;

    ok(!$mock->_logged_in);
};

done_testing;
