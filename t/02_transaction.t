use strict;
use warnings;
use Test::More;
use Time::Piece ();
use Finance::Bank::JP::MUFG::Transaction;

my %columns = (
    date        => Time::Piece->strptime('2012年6月22日', '%Y年%m月%d日'),
    abstract    => '振込ＩＢ１',
    description => 'テスト　タロウ',
    outlay      => 2000,
    income      => 0,
    balance     => 14998000,
    memo        => '',
);

subtest 'Test constructor' => sub {
    my $transaction = Finance::Bank::JP::MUFG::Transaction->new(%columns);
    ok $transaction,     'constructor';
    isa_ok $transaction, 'Finance::Bank::JP::MUFG::Transaction';
};

subtest 'Test accessors' => sub {
    my @accessors   = Finance::Bank::JP::MUFG::Transaction->columns;
    my $transaction = Finance::Bank::JP::MUFG::Transaction->new(%columns);

    for my $accessor (@accessors) {
        can_ok $transaction, $accessor;
    }

    for my $accessor (@accessors) {
        my $got      = $transaction->$accessor;
        my $expexted = $columns{$accessor};
        if (ref $got) {
            is_deeply $got, $expexted;
        }
        else {
            is $got, $expexted;
        }
    }
};

done_testing;
