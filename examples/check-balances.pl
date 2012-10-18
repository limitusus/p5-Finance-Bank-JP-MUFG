#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);

use Finance::Bank::JP::MUFG;

my $mufg = Finance::Bank::JP::MUFG->new(
    contract_no => 'your_contract_no',
    password    => 'your_direct_password',
)->login;

my @accounts = $mufg->accounts;

for my $account (@accounts) {
    printf "%-s  %-s  %-7s %9s円 %9s円\n",
        $account->branch,
        $account->account_kind,
        $account->account_no,
        commify($account->balance),
        commify($account->withdrawal_limit);

    # >> 恵比寿支店  普通  8888888  222,222円  222,222円
    # >> 恵比寿支店  定期  9999999  333,333円  333,333円
}

$mufg->logout;

sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}
