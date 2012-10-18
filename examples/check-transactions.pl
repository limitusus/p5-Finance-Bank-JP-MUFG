#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);

use Finance::Bank::JP::MUFG;

my $mufg = Finance::Bank::JP::MUFG->new(
    contract_no => 'your_contract_no',
    password    => 'your_direct_password',
)->login;

my @transactions = $mufg->transactions(
    account_no       => 1,
    transaction_kind => 1,
    period           => 1,
);

for my $transaction (@transactions) {
    printf "%-s  %-s  %-s  %s円  %s円  %s円  %-s\n",
        $transaction->date->ymd('/'),
        $transaction->abstract,
        $transaction->description,
        commify($transaction->outlay),
        commify($transaction->income),
        commify($transaction->balance),
        $transaction->memo;

    # >> 2020/09/01  カ－ド                          10,000円  0円  49,000円  ATM
    # >> 2020/09/01  手数料                             105円  0円  48,895円
    # >> 2020/09/10  口座振替３  ミツイスミトモカ－ド   3,000円  0円  45,895円
}

$mufg->logout;

sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}
