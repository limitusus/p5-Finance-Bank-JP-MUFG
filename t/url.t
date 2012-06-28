use strict;
use warnings;

use Test::More;
use Finance::Bank::JP::MUFG;

subtest q{Login URL.} => sub {
    my $url = Finance::Bank::JP::MUFG::_get_url('login');
    is( $url, q{https://entry11.bk.mufg.jp/ibg/dfw/APLIN/loginib/login?_TRANID=AA000_001} );
};

done_testing;
