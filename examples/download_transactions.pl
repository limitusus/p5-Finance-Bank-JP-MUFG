#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);

use Finance::Bank::JP::MUFG;

my $mufg = Finance::Bank::JP::MUFG->new(
    contract_no => 'your_contract_no',
    password    => 'your_direct_password',
)->login;

my $csv_path = $mufg->download_transactions(
    account_no       => 1,
    transaction_kind => 1,
    period           => 4,
    from             => '2012/9/1',
    to               => '2012/10/12',
    save_dir         => '/tmp',
    to_utf8          => 0,
);

say $csv_path;    # >> /tmp/1673544_20121018225048.csv

$mufg->logout;
