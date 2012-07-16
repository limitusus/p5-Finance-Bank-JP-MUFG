use strict;
use warnings;

use Test::More;
use Test::MockObject::Extends;
use Test::Warn;
use Time::Piece ();
use Time::Seconds;
use Encode qw(encode from_to);

use Finance::Bank::JP::MUFG;
use t::Helper::Page;

subtest q{Scrapes the balances.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '00000001',
        password    => 'inaccurate_password',
    );
    my $mock = Test::MockObject::Extends->new($mufg);
    my $html = t::Helper::Page::balances();

    $mock->set_true('_logged_in');
    $mock->set_always( '_transition', $html );

    my @balances = $mock->balances();

    is( $balances[0]->{branch},           '恵比寿支店' );
    is( $balances[0]->{account_kind},     '普通' );
    is( $balances[0]->{account_no},       '8888888' );
    is( $balances[0]->{balance},          15000000 );
    is( $balances[0]->{withdrawal_limit}, 500000 );

    is( $balances[1]->{branch},           '恵比寿支店' );
    is( $balances[1]->{account_kind},     '定期' );
    is( $balances[1]->{account_no},       '9999999' );
    is( $balances[1]->{balance},          0 );
    is( $balances[1]->{withdrawal_limit}, 0 );
};

subtest q{Scrapes the transactions.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '00000001',
        password    => 'inaccurate_password',
    );
    my $mock = Test::MockObject::Extends->new($mufg);
    my $html = t::Helper::Page::transactions();

    $mock->set_true('_logged_in');
    $mock->set_always( '_transition', $html );

    my @transactions = $mock->transactions();
    my $t = Time::Piece->strptime( '2012年6月22日', '%Y年%m月%d日' );

    is_deeply( $transactions[0]->{date}, $t );
    is( $transactions[0]->{abstract},    '振込ＩＢ１' );
    is( $transactions[0]->{description}, 'テスト　タロウ' );
    is( $transactions[0]->{outlay},      2000 );
    is( $transactions[0]->{income},      0 );
    is( $transactions[0]->{balance},     14998000 );
    is( $transactions[0]->{memo},        '' );

    is_deeply( $transactions[1]->{date}, $t );
    is( $transactions[1]->{abstract},    'カ－ド' );
    is( $transactions[1]->{description}, '' );
    is( $transactions[1]->{outlay},      8000 );
    is( $transactions[1]->{income},      0 );
    is( $transactions[1]->{balance},     14990000 );
    is( $transactions[1]->{memo},        '' );

    is_deeply( $transactions[2]->{date}, $t );
    is( $transactions[2]->{abstract},    '手数料' );
    is( $transactions[2]->{description}, '' );
    is( $transactions[2]->{outlay},      105 );
    is( $transactions[2]->{income},      0 );
    is( $transactions[2]->{balance},     14989895 );
    is( $transactions[2]->{memo},        '' );
};

subtest q{Downloads the transactions with save path.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '00000001',
        password    => 'inaccurate_password',
    );
    my $html      = t::Helper::Page::download();
    my $csv       = encode( 'cp932', t::Helper::Page::csv() );
    my $mock      = Test::MockObject::Extends->new($mufg);
    my $mock_mech = Test::MockObject::Extends->new( WWW::Mechanize->new( autocheck => 1, ) );

    $mock_mech->set_false('is_html');
    $mock_mech->set_always( 'back',    undef );
    $mock_mech->set_always( 'content', $csv );

    $mock->set_true('_logged_in');
    $mock->set_always( '_transition',                 $html );
    $mock->set_always( '_get_filename_from_response', '1673544_20120708215653.csv' );
    $mock->set_always( 'mech',                        $mock_mech );

    my $filepath = $mock->download_transactions( save_dir => 't/' );

    ok( -f $filepath );

    open( my $fh, '<', $filepath ) or croak("Unable to open $filepath: $!");
    my @lines = readline $fh;
    close $fh or croak("Unable to close $filepath: $!");
    unlink $filepath or croak("Unable to unlink $filepath: $!");

    my $file = join '', @lines;

    is( $file, $csv );
};

subtest q{Downloads the transactions with the default save path and to_utf8.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '00000001',
        password    => 'inaccurate_password',
    );
    my $html      = t::Helper::Page::download();
    my $csv       = encode( 'cp932', t::Helper::Page::csv() );
    my $mock      = Test::MockObject::Extends->new($mufg);
    my $mock_mech = Test::MockObject::Extends->new( WWW::Mechanize->new( autocheck => 1, ) );

    $mock_mech->set_false('is_html');
    $mock_mech->set_always( 'back',    undef );
    $mock_mech->set_always( 'content', $csv );

    $mock->set_true('_logged_in');
    $mock->set_always( '_transition',                 $html );
    $mock->set_always( '_get_filename_from_response', '1673544_20120708215653.csv' );
    $mock->set_always( 'mech',                        $mock_mech );

    my $filepath = $mock->download_transactions( to_utf8 => 1 );

    ok( -f $filepath );

    open( my $fh, '<', $filepath ) or croak("Unable to open $filepath: $!");
    my @lines = readline $fh;
    close $fh or croak("Unable to close $filepath: $!");
    unlink $filepath or croak("Unable to unlink $filepath: $!");

    my $file = join '', @lines;
    from_to( $csv, 'cp932', 'utf8' );

    is( $file, $csv );
};

subtest q{Downloads the transactions with the invalid arguments.} => sub {
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '00000001',
        password    => 'inaccurate_password',
    );
    my $html      = t::Helper::Page::download();
    my $csv       = encode( 'cp932', t::Helper::Page::csv() );
    my $mock      = Test::MockObject::Extends->new($mufg);
    my $mock_mech = Test::MockObject::Extends->new( WWW::Mechanize->new( autocheck => 1, ) );

    $mock_mech->set_false('is_html');
    $mock_mech->set_always( 'back',    undef );
    $mock_mech->set_always( 'content', $csv );

    $mock->set_true('_logged_in');
    $mock->set_always( '_transition',                 $html );
    $mock->set_always( '_get_filename_from_response', '1673544_20120708215653.csv' );
    $mock->set_always( 'mech',                        $mock_mech );

    eval {
        my $filepath = $mock->download_transactions(
            save_dir => 't/unknown/',
            to_utf8  => 'invalid value',
        );
    };

    like( $@, qr/^Save dir doesn't exist./ );
};

subtest q{Converts to order.} => sub {
    is( Finance::Bank::JP::MUFG::_convert_value_to_order(1), 0 );
    is( Finance::Bank::JP::MUFG::_convert_value_to_order(2), 1 );
    is( Finance::Bank::JP::MUFG::_convert_value_to_order(3), 2 );
    is( Finance::Bank::JP::MUFG::_convert_value_to_order(4), 3 );

    my $current_year = Time::Piece->localtime->year;
    is( Finance::Bank::JP::MUFG::_convert_year_to_order( $current_year - 2 ), 0 );
    is( Finance::Bank::JP::MUFG::_convert_year_to_order( $current_year - 1 ), 1 );
    is( Finance::Bank::JP::MUFG::_convert_year_to_order($current_year),       2 );
};

subtest q{Tests the _build_condition() with the default condition.} => sub {
    {
        my %args      = ();
        my $condition = Finance::Bank::JP::MUFG::_build_condition(%args);
        is_deeply(
            $condition,
            +{  KOUZA_RADIO  => 0,
                SHURUI_RADIO => 0,
                KIKAN_RADIO  => 0,
            }
        );
    }

    {
        my $condition = Finance::Bank::JP::MUFG::_build_condition( account_no => '2', );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO  => 1,
                SHURUI_RADIO => 0,
                KIKAN_RADIO  => 0,
            }
        );
    }

    warnings_like {
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 'inaccurate value',
            transaction_kind => 'inaccurate value',
            period           => 'inaccurate value',
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO  => 0,
                SHURUI_RADIO => 0,
                KIKAN_RADIO  => 0,
            }
        );
    }
    [   { carped => qr/^Unexpected argment. Changes to default value./ },
        { carped => qr/^Unexpected argment. Changes to default value./ },
        { carped => qr/^Unexpected argment. Changes to default value./ },
    ];
};

subtest q{Tests the _build_condition() with the changed kind and period.} => sub {
    {
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 1,
            transaction_kind => 1,
            period           => 1,
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO  => 0,
                SHURUI_RADIO => 0,
                KIKAN_RADIO  => 0,
            }
        );
    }
    {
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 2,
            transaction_kind => 2,
            period           => 2,
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO  => 1,
                SHURUI_RADIO => 1,
                KIKAN_RADIO  => 1,
            }
        );
    }
    {
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 3,
            transaction_kind => 3,
            period           => 2,
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO  => 2,
                SHURUI_RADIO => 2,
                KIKAN_RADIO  => 1,
            }
        );
    }
    {
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 4,
            transaction_kind => 4,
            period           => 2,
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO  => 3,
                SHURUI_RADIO => 3,
                KIKAN_RADIO  => 1,
            }
        );
    }
};

subtest q{Tests the _build_condition() to set the period's value to 3.} => sub {
    warning_like {
        my $t         = Time::Piece->localtime;
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 3,
            transaction_kind => 4,
            period           => 3,
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO    => Finance::Bank::JP::MUFG::_convert_value_to_order(3),
                SHURUI_RADIO   => Finance::Bank::JP::MUFG::_convert_value_to_order(4),
                KIKAN_RADIO    => Finance::Bank::JP::MUFG::_convert_value_to_order(3),
                HIZUKESHITEI_Y => Finance::Bank::JP::MUFG::_convert_year_to_order( $t->year ),
                HIZUKESHITEI_M => Finance::Bank::JP::MUFG::_convert_value_to_order( $t->mon ),
                HIZUKESHITEI_D => Finance::Bank::JP::MUFG::_convert_value_to_order( $t->mday ),
            }
        );
    }
    { carped => qr/^If the value of period is 3, date is required. Changes to today./ };

    warning_like {
        my $t         = Time::Piece->localtime;
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 4,
            transaction_kind => 3,
            period           => 3,
            date             => '3012/13/32'
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO    => Finance::Bank::JP::MUFG::_convert_value_to_order(4),
                SHURUI_RADIO   => Finance::Bank::JP::MUFG::_convert_value_to_order(3),
                KIKAN_RADIO    => Finance::Bank::JP::MUFG::_convert_value_to_order(3),
                HIZUKESHITEI_Y => Finance::Bank::JP::MUFG::_convert_year_to_order( $t->year ),
                HIZUKESHITEI_M => Finance::Bank::JP::MUFG::_convert_value_to_order( $t->mon ),
                HIZUKESHITEI_D => Finance::Bank::JP::MUFG::_convert_value_to_order( $t->mday ),
            }
        );
    }
    { carped => qr/^Unexpected argment. Changes to default value./ };

    {
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 1,
            transaction_kind => 1,
            period           => 3,
            date             => '2012/7/09',
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO    => Finance::Bank::JP::MUFG::_convert_value_to_order(1),
                SHURUI_RADIO   => Finance::Bank::JP::MUFG::_convert_value_to_order(1),
                KIKAN_RADIO    => Finance::Bank::JP::MUFG::_convert_value_to_order(3),
                HIZUKESHITEI_Y => Finance::Bank::JP::MUFG::_convert_year_to_order('2012'),
                HIZUKESHITEI_M => Finance::Bank::JP::MUFG::_convert_value_to_order('7'),
                HIZUKESHITEI_D => Finance::Bank::JP::MUFG::_convert_value_to_order('09'),
            }
        );
    }

    warning_like {
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 1,
            transaction_kind => 1,
            period           => 3,
            date             => '2124/12/31',
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO    => Finance::Bank::JP::MUFG::_convert_value_to_order(1),
                SHURUI_RADIO   => Finance::Bank::JP::MUFG::_convert_value_to_order(1),
                KIKAN_RADIO    => Finance::Bank::JP::MUFG::_convert_value_to_order(3),
                HIZUKESHITEI_Y => Finance::Bank::JP::MUFG::_convert_year_to_order('2124'),
                HIZUKESHITEI_M => Finance::Bank::JP::MUFG::_convert_value_to_order('12'),
                HIZUKESHITEI_D => Finance::Bank::JP::MUFG::_convert_value_to_order('31'),
            }
        );
    }
    [   { carped => qr/^Unexpected year's value. Changes to current year./ },
        { carped => qr/^Unexpected year's value. Changes to current year./ },
    ];
};

subtest q{Tests the _build_condition() to set the period's value to 4.} => sub {
    {
        my $to_t      = Time::Piece->localtime;
        my $from_t    = $to_t - ONE_MONTH;
        my $condition = Finance::Bank::JP::MUFG::_build_condition(
            account_no       => 1,
            transaction_kind => 1,
            period           => 4,
            from             => $from_t->ymd('/'),
            to               => $to_t->ymd('/'),
        );
        is_deeply(
            $condition,
            +{  KOUZA_RADIO  => Finance::Bank::JP::MUFG::_convert_value_to_order(1),
                SHURUI_RADIO => Finance::Bank::JP::MUFG::_convert_value_to_order(1),
                KIKAN_RADIO  => Finance::Bank::JP::MUFG::_convert_value_to_order(4),
                KIKANSHITEI_Y_FROM =>
                    Finance::Bank::JP::MUFG::_convert_year_to_order( $from_t->year ),
                KIKANSHITEI_M_FROM =>
                    Finance::Bank::JP::MUFG::_convert_value_to_order( $from_t->mon ),
                KIKANSHITEI_D_FROM =>
                    Finance::Bank::JP::MUFG::_convert_value_to_order( $from_t->mday ),
                KIKANSHITEI_Y_TO => Finance::Bank::JP::MUFG::_convert_year_to_order( $to_t->year ),
                KIKANSHITEI_M_TO => Finance::Bank::JP::MUFG::_convert_value_to_order( $to_t->mon ),
                KIKANSHITEI_D_TO => Finance::Bank::JP::MUFG::_convert_value_to_order( $to_t->mday ),
            }
        );
    }
};

done_testing;
