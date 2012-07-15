# NAME

Finance::Bank::JP::MUFG - Checks balances and transactions of MUFG-DIRECT account.

# SYNOPSIS

    use Finance::Bank::JP::MUFG;
    use feature qw(say);
   
    my $mufg = Finance::Bank::JP::MUFG->new(
        contract_no => '12345678',
        password    => 'direct_password',
        agent       => 'Windows Mozilla',
    )->login();
   
    my @balances = $mufg->balances();
   
    say $balances[0]->{branch};
    say $balances[0]->{account_kind};
    say $balances[0]->{account_no};
    say $balances[0]->{balance};
    say $balances[0]->{withdrawal_limit};
   
    my @transactions = $mufg->transactions(
        account_no       => 1,
        transaction_kind => 1,
        term             => 3,
        date             => '2012/6/22',
    );
   
    say $transactions[0]->{date}->ymd('/');
    say $transactions[0]->{abstract};
    say $transactions[0]->{description};
    say $transactions[0]->{outlay};
    say $transactions[0]->{income};
    say $transactions[0]->{balance};
    say $transactions[0]->{memo};
   
    my $csv_path = $mufg->download_transactions(
        account_no       => 1,
        transaction_kind => 1,
        term             => 4,
        from             => '2012/6/1',
        to               => '2012/7/10',
        save_dir         => '/tmp',
        to_utf8          => 0,
    );
   
    say $csv_path;
   
    $mufg->logout();

# DESCRIPTION

This module provides methods to access data from MUFG-DIRECT accounts,
including account balances and recent transactions. It also provides
a method to download data in CSV format from a given date or date range.

# CONSTRUCTOR AND STARTUP

## new( %options )

Creates and returns a new Finance::Bank::JP::MUFG object.

    my $mufg = Finance::Bank::JP::MUFG->new( ... );

This constructor has to pass two parameters of the Contract Number and Password.

    contract_no => '12345678',
    password    => 'direct_password',

You can also specify the user agent.

    agent => [alias]

The list of valid aliases is:

* Windows IE 6

* Windows Mozilla

* Mac Safari

* Mac Mozilla(Default value)

* Linux Mozilla

* Linux Konqueror

# METHODS

## $mufg->login()

Runs login process and returns a self object.
Be sure to call after object creation.

## $mufg->balances()

Returns an array of all the account balances.
This array stores hash references of each account,
and you can access with the following keys.

* branch

* account_kind

* account_no

* balance

* withdrawal_limit

## $mufg->transactions( %options )

Specify as follows, passing the hash to the argument.

* account_no => [1|2|3|..N]

Choose which account to retrieve data.
Default value is 1 and which is optional.

* transaction_kind => [1|2|3|4]

Choose transaction kinds.
Default value is 1 and which is optional.

    1 ALL
    2 MONEY RECEIVED
    3 WITHDRAWAL
    4 TRANSFER PAYMENT

* term => [1|2|3|4]

Choose term to retrieve data.
Default value is 1 and which is optional.

    1 From the beginning of one month ago until today
    2 Recent 10 days
    3 Specified date
    4 Specified period

* date => '%Y/%m/%d'

If term's value is 3, specified date is used.
Default value is today and which is optional.

* from => '%Y/%m/%d'

If term's value is 4, specified date is used.
This parameter is required.

* to => '%Y/%m/%d'

If term's value is 4, specified date is used.
Default value is today and which is optional.

Returns an array of transactions.
This array stores hash references of each transaction,
and you can access with the following keys.

* date `Time::Piece`

* abstract

* description

* outlay

* income

* balance

* memo

## $mufg->download_transactions( %options )

Returns a saved path.
Specify as follows, passing the hash to the argument.

* account_no => [1|2|3|..N]

Choose which account to retrieve data.
Default value is 1 and which is optional.

* transaction_kind => [1|2|3|4]

Choose transaction kinds.
Default value is 1 and which is optional.

    1 ALL
    2 MONEY RECEIVED
    3 WITHDRAWAL
    4 TRANSFER PAYMENT

* term => [1|2|3|4]

Choose term to retrieve data.
Default value is 1 and which is optional.

    1 From the beginning of one month ago until today
    2 Recent 10 days
    3 Specified date
    4 Specified period

* date => '%Y/%m/%d'

If term's value is 3, specified date is used.
Default value is today and which is optional.

* from => '%Y/%m/%d'

If term's value is 4, specified date is used.
This parameter is required.

* to => '%Y/%m/%d'

If term's value is 4, specified date is used.
Default value is today and which is optional.

* save_dir => '/path/to/save_dir'

If term's value is 3, specified date is used.

* to_utf8 => [0|1]

Set a flag. If flag is off, CSV's charset is cp932.
Default is off and which is optional.

# AUTHOR

Yusuke Maeda `dev.perfumed.garden[at]gmail.com`

# FINANCE::BANK::JP::MUFG'S GIT REPOSITORY

Finance::Bank::JP::MUFG is hosted at GitHub.

Repository: <https://github.com/perforb/p5-Finance-Bank-JP-MUFG>

# SEE ALSO

* WWW::Mechanize

* HTML::TreeBuilder::XPath

* HTML::Selector::XPath

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
