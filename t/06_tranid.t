use strict;
use warnings;

use Test::More;
use Finance::Bank::JP::MUFG;

subtest q{Transaction ID.} => sub {
    {
        my $tranid = Finance::Bank::JP::MUFG::_get_transaction_id('login');
        is( $tranid, q{AA011_001} );
    }
    {
        my $tranid = Finance::Bank::JP::MUFG::_get_transaction_id('top');
        is( $tranid, q{AW001_028} );
    }
    {
        my $tranid = Finance::Bank::JP::MUFG::_get_transaction_id('logout');
        is( $tranid, q{AD001_022} );
    }
    {
        my $tranid = Finance::Bank::JP::MUFG::_get_transaction_id('account_balances');
        is( $tranid, q{AD001_001} );
    }
    {
        my $tranid = Finance::Bank::JP::MUFG::_get_transaction_id('search_condition');
        is( $tranid, q{AD001_002} );
    }
    {
        my $tranid = Finance::Bank::JP::MUFG::_get_transaction_id('transaction');
        is( $tranid, q{CG016_001} );
    }
    {
        my $tranid = Finance::Bank::JP::MUFG::_get_transaction_id('download');
        is( $tranid, q{CG016_002} );
    }
    {
        my $tranid = Finance::Bank::JP::MUFG::_get_transaction_id('exec_download');
        is( $tranid, q{CG019_001} );
    }
};

done_testing;
