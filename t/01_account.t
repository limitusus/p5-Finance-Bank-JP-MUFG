use strict;
use warnings;
use Test::More;
use Finance::Bank::JP::MUFG::Account;

my %columns = (
    branch           => '恵比寿支店',
    account_kind     => '普通',
    account_no       => '8888888',
    balance          => 15000000,
    withdrawal_limit => 500000,
);

subtest 'Test constructor' => sub {
    my $account = Finance::Bank::JP::MUFG::Account->new(%columns);
    ok $account,     'constructor';
    isa_ok $account, 'Finance::Bank::JP::MUFG::Account';
};

subtest 'Test columns' => sub {
    my @columns = Finance::Bank::JP::MUFG::Account->columns;
    is_deeply \@columns, [qw/ branch account_kind account_no balance withdrawal_limit /];
};

subtest 'Test accessors' => sub {
    my @accessors = Finance::Bank::JP::MUFG::Account->columns;
    my $account = Finance::Bank::JP::MUFG::Account->new(%columns);

    for my $accessor (@accessors) {
        can_ok $account, $accessor;
    }

    for my $accessor (@accessors) {
        my $got      = $account->$accessor;
        my $expexted = $columns{$accessor};
        is $got, $expexted;
    }
};

done_testing;
