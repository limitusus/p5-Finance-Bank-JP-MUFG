package Finance::Bank::JP::MUFG;

use strict;
use warnings;
use 5.008_001;
our $VERSION = '0.07';

use WWW::Mechanize;
use HTML::TreeBuilder::XPath;
use HTML::Selector::XPath 'selector_to_xpath';
use List::MoreUtils qw(all any);
use Cwd qw(getcwd);
use Carp        ();
use Time::Piece ();
use Encode qw(encode_utf8 from_to);
use Encode::Alias;

use Finance::Bank::JP::MUFG::Account;
use Finance::Bank::JP::MUFG::Transaction;

define_alias(shift_jis => 'cp932');

my %urls = (
    login => 'https://entry11.bk.mufg.jp/ibg/dfw/APLIN/loginib/login?_TRANID=AA000_001',
);

my %xpaths = (
    account_balances => '/html/body/div/form[2]/div[3]/div[2]/div[3]/table/tbody/tr',
    transaction      => '/html/body/div/form[2]/div[3]/div[2]/div[5]/table/tbody/tr',
    transaction_i    => '/html/body/div/form[2]/div[3]/div[2]/div[6]/table/tbody/tr',
    hidden           => selector_to_xpath('div#container input[type=hidden]'),
    attention   => selector_to_xpath('div#contents div.serviceContents div.msgArea p.attention'),
    attention_i => selector_to_xpath('div#contents div.serviceContents div.infoArea p.attention'),
    unread_info => selector_to_xpath('div#contents form[name=informationShousaiActionForm]'),
);

my %transaction_ids = (
    login            => 'AA011_001',
    top              => 'AW001_028',
    logout           => 'AD001_022',
    account_balances => 'AD001_001',
    search_condition => 'AD001_002',
    transaction      => 'CG016_001',
    download         => 'CG016_002',
    exec_download    => 'CG019_001',
);

sub mech       { shift->{mech} }
sub agent      { shift->{agent} }
sub _logged_in { shift->{_logged_in} }

sub xpath_keys          { sort keys %xpaths }
sub transaction_id_keys { sort keys %transaction_ids }

sub _get_url            { $urls{$_[0]} }
sub _get_xpath          { $xpaths{$_[0]} }
sub _get_transaction_id { $transaction_ids{$_[0]} }

sub new {
    my ($class, %args) = @_;

    unless (all { defined $_ } $args{contract_no}, $args{password}) {
        Carp::croak "Contract number and password are required.";
    }

    my $self = bless {%args}, $class;

    $self->{agent} = 'Mac Mozilla' unless _check_agent($self->{agent});
    $self->{mech} = WWW::Mechanize->new(
        autocheck   => 1,
        stack_depth => 1,
    );
    $self->mech()->agent_alias($self->agent());
    $self->{_logged_in} = 0;

    return $self;
}

sub _check_agent {
    my $agent = shift;
    return 0 unless defined $agent;
    if (any { $_ eq $agent } WWW::Mechanize::known_agent_aliases()) {
        return 1;
    }
    return 0;
}

sub login {
    my $self = shift;
    my $mech = $self->mech();

    $mech->get(_get_url('login'));

    my $top_page = $self->_transition(
        'login',
        +{  KEIYAKU_NO => $self->{contract_no},
            PASSWORD   => $self->{password},
        }
    );

    my ($login_error, $exists_unread_info) = (
        _exists_element($top_page, _get_xpath('attention')),
        _exists_element($top_page, _get_xpath('unread_info')),
    );

    if ($login_error) {
        Carp::croak "Login error.";
    }
    elsif ($exists_unread_info) {
        Carp::croak "Exist unread information in the top page. Please check it.";
    }

    $self->{_logged_in} = 1;

    return $self;
}

sub _exists_element {
    my ($content, $xpath) = @_;
    my $tree = _build_tree($content);
    return $tree->exists($xpath);
}

sub accounts {
    my $self = shift;
    $self->_check_login;

    my $account_page = $self->_transition('account_balances', +{});
    my $tree         = _build_tree($account_page);
    my @names        = Finance::Bank::JP::MUFG::Account->columns;
    my @rows         = $tree->findnodes(_get_xpath('account_balances'));
    my @accounts     = ();

    for my $row (@rows) {
        my %columns = ();
        my @values  = ();
        my @data    = $row->find_by_tag_name('td');

        for my $datum (@data) {
            my $text = $datum->as_trimmed_text();
            push @values, $text;
        }

        @columns{@names} = @values;

        for my $key (keys %columns) {
            if ($key =~ /balance|withdrawal_limit/) {
                $columns{$key} =~ s/^([\d,]+).*$/$1/;
                $columns{$key} =~ s/,//g;
                $columns{$key} =~ s/\*{1,3}/0/;
            }
            $columns{$key} = encode_utf8($columns{$key});
        }

        push @accounts, Finance::Bank::JP::MUFG::Account->new(%columns);
    }

    return @accounts;
}

sub transactions {
    my ($self, %args) = @_;
    $self->_check_login;
    $self->_transition('search_condition', +{});

    my $search_condition = _build_condition(%args);
    my $page = $self->_transition('transaction', $search_condition);

    if (_exists_element($page, _get_xpath('attention'))) {
        Carp::croak "Invalid search condition.";
    }

    my $exists_info = _exists_element($page, _get_xpath('attention_i'));

    if ($exists_info) {
        Carp::carp "Views the details since the beginning of the month of the previous.";
    }

    my $tree         = _build_tree($page);
    my $xpath        = $exists_info ? _get_xpath('transaction_i') : _get_xpath('transaction');
    my @rows         = $tree->findnodes($xpath);
    my @names        = Finance::Bank::JP::MUFG::Transaction->columns;
    my @transactions = ();

    for my $row (@rows) {
        my %columns = ();
        my @values  = ();
        my @data    = $row->find_by_tag_name('td');

        for my $datum (@data) {
            my $text = $datum->as_trimmed_text();
            push @values, $text;
        }

        @columns{@names} = @values;

        for my $key (keys %columns) {

            # no-break space code point.
            my $nbsp = "\xA0";
            $columns{$key} =~ s/$nbsp//g;
            if ($key =~ /date/) {
                my $t = Time::Piece->strptime($columns{$key}, '%Y年%m月%d日');
                $columns{$key} = $t;
                next;
            }
            if ($key =~ /outlay|income|balance/) {
                $columns{$key} = 0 unless $columns{$key};
                $columns{$key} =~ s/^([\d,]+).*$/$1/;
                $columns{$key} =~ s/,//g;
                next;
            }
            $columns{$key} = encode_utf8($columns{$key});
        }

        push @transactions, Finance::Bank::JP::MUFG::Transaction->new(%columns);
    }

    return @transactions;
}

sub download_transactions {
    my ($self, %args) = @_;
    $self->_check_login;

    my $save_dir = delete $args{save_dir} || getcwd;
    my $to_utf8  = delete $args{to_utf8}  || 0;

    if (not -d $save_dir) {
        Carp::croak "Save dir doesn't exist: $save_dir";
    }
    elsif (not $to_utf8 =~ /^[01]$/) {
        Carp::carp "Set the 0 or 1 in the `to_utf8`.";
    }

    $self->_transition('search_condition', +{});

    my $search_condition = _build_condition(%args);
    my $page = $self->_transition('download', $search_condition);

    if (_exists_element($page, _get_xpath('attention'))) {
        Carp::croak "Invalid search condition.";
    }
    elsif (_exists_element($page, _get_xpath('attention_i'))) {
        Carp::carp "Views the details since the beginning of the month of the previous.";
    }

    $self->_transition('exec_download', +{});
    if ($self->mech()->is_html) {
        Carp::croak "Unexpected content type.";
    }

    my $filename = $self->_get_filename_from_response;

    # Not flagged utf8 content.
    my $content = $self->mech()->content;
    $save_dir .= '/' unless $save_dir =~ m!/$!;
    my $filepath = $save_dir . $filename;

    if (-e $filepath) {
        Carp::croak "Already exists the file.";
    }

    if ($to_utf8 =~ /^[1]$/) {
        from_to($content, 'cp932', 'utf8');
    }

    _save_content($content, $filepath);

    # Back to the before page.
    $self->mech()->back;

    return $filepath;
}

sub _get_filename_from_response {
    my $self     = shift;
    my $response = $self->mech()->response();
    return $response->filename or Carp::croak "Couldn't get file name.";
}

sub _build_condition {
    my %args = @_;

    unless (%args) {
        Carp::croak "Not specify search condition.";
    }

    my $account_no       = _default_value(delete $args{account_no},       1, qr/^[1-9]$/);
    my $transaction_kind = _default_value(delete $args{transaction_kind}, 1, qr/^[1-4]$/);
    my $period           = _default_value(delete $args{period},           1, qr/^[1-4]$/);

    return +{
        KOUZA_RADIO  => _convert_value_to_order($account_no),
        SHURUI_RADIO => _convert_value_to_order($transaction_kind),
        KIKAN_RADIO  => _convert_value_to_order($period),
    } if ($period == 1 || $period == 2);

    my $condition = +{};

    if ($period == 3) {

        unless (exists $args{date}) {
            Carp::carp "If the value of period is 3, `date` is required. Changes to today.";
        }

        my $regexp_date = qr!^([\d]{4,4})/(0?[1-9]|1[012])/(0?[1-9]|[12][0-9]|3[01])$!;
        my $date = _default_value(delete $args{date}, Time::Piece->localtime->ymd('/'),
            qr!$regexp_date!);
        my $t = Time::Piece->strptime($date, '%Y/%m/%d');

        $condition = +{
            KOUZA_RADIO    => _convert_value_to_order($account_no),
            SHURUI_RADIO   => _convert_value_to_order($transaction_kind),
            KIKAN_RADIO    => _convert_value_to_order($period),
            HIZUKESHITEI_Y => _convert_year_to_order($t->year),
            HIZUKESHITEI_M => _convert_value_to_order($t->mon),
            HIZUKESHITEI_D => _convert_value_to_order($t->mday),
        };
    }
    elsif ($period == 4) {

        unless (exists $args{from}) {
            Carp::croak "If the value of period is 4, `from` is required.";
        }

        my $t           = Time::Piece->localtime;
        my $from        = delete $args{from};
        my $to          = delete $args{to} || $t->ymd('/');
        my $regexp_date = qr!^([\d]{4,4})/(0?[1-9]|1[012])/(0?[1-9]|[12][0-9]|3[01])$!;

        if (!$from =~ /$regexp_date/ || !$to =~ /$regexp_date/) {
            Carp::croak "Invalid date formart: $from - $to";
        }

        my $t_from = Time::Piece->strptime($from, '%Y/%m/%d');
        my $t_to   = Time::Piece->strptime($to,   '%Y/%m/%d');

        if ($t_from > $t_to) {
            my ($t_from_ymd, $t_to_ymd) = ($t_from->ymd('/'), $t_to->ymd('/'));
            Carp::croak "Needs to change the from_date before the to_date: $t_from_ymd > $t_to_ymd";
        }
        elsif ($t_to > $t) {
            my ($t_to_ymd, $t_ymd) = ($t_to->ymd('/'), $t->ymd('/'));
            Carp::croak "Can't specify a date in the future: $t_to_ymd > $t_ymd";
        }

        $condition = +{
            KOUZA_RADIO        => _convert_value_to_order($account_no),
            SHURUI_RADIO       => _convert_value_to_order($transaction_kind),
            KIKAN_RADIO        => _convert_value_to_order($period),
            KIKANSHITEI_Y_FROM => _convert_year_to_order($t_from->year),
            KIKANSHITEI_M_FROM => _convert_value_to_order($t_from->mon),
            KIKANSHITEI_D_FROM => _convert_value_to_order($t_from->mday),
            KIKANSHITEI_Y_TO   => _convert_year_to_order($t_to->year),
            KIKANSHITEI_M_TO   => _convert_value_to_order($t_to->mon),
            KIKANSHITEI_D_TO   => _convert_value_to_order($t_to->mday),
        };
    }

    return $condition;
}

sub _default_value {
    my ($value, $default, $regexp) = @_;
    return $default unless defined $value;
    if ($value =~ /$regexp/) {
        return $value;
    }
    Carp::carp "Unexpected argment: $value";
    Carp::carp "Changes to default value: $value -> $default";
    return $default;
}

sub _convert_year_to_order {
    my $year         = shift;
    my $t            = Time::Piece->localtime;
    my $current_year = $t->year;
    my %year_map     = (
        $current_year - 2 => 0,
        $current_year - 1 => 1,
        $current_year     => 2,
    );
    my $order = $year_map{_default_value($year, $t->year, qr/^[\d]{4,4}$/)};

    unless (defined $order) {
        Carp::carp "Unexpected year's value. Changes to current year.";
        $order = 2;
    }

    return $order;
}

sub _convert_value_to_order {
    my $value = shift;
    return --$value;
}

sub _save_content {
    my ($content, $filepath) = @_;
    open(my $fh, '>', $filepath) or Carp::croak "Unable to create $filepath: $!";
    binmode $fh;
    print {$fh} $content or Carp::croak "Unable to write to $filepath: $!";
    close $fh or Carp::croak "Unable to close $filepath: $!";
    return;
}

sub _transition {
    my ($self, $transaction_key, $fields) = @_;

    $fields ||= +{};
    Carp::croak "Trnsaction Key is required." unless defined $transaction_key;
    Carp::croak "Trnsaction Key is invalid."  unless _check_transaction_key($transaction_key);
    Carp::croak "Not a HASH reference."       unless (ref $fields eq 'HASH');

    my $mech  = $self->mech();
    my $tree  = _build_tree($mech->content);
    my @nodes = $tree->findnodes(_get_xpath('hidden'));

    $fields = _create_form_fields($transaction_key, $fields, \@nodes);
    $mech->submit_form(
        form_name => 'MainForm',
        fields    => $fields,
    );

    if ($mech->content =~ /IW052/) {
        Carp::croak "Login session has expired.";
    }

    return $mech->content;
}

sub _build_tree {
    my $html = shift;
    my $tree = HTML::TreeBuilder::XPath->new;
    $tree->parse($html);
    $tree->eof;
    return $tree;
}

sub _check_transaction_key {
    my $transaction_key = shift;
    return 0 unless defined $transaction_key;
    if (any { $_ eq $transaction_key } transaction_id_keys()) {
        return 1;
    }
    return 0;
}

sub _create_form_fields {
    my ($transaction_key, $fields, $hidden_tags) = @_;
    $fields ||= +{};
    map { $fields->{$_->attr('name')} = $_->attr('value') } @{$hidden_tags};
    $fields->{_TRANID} = _get_transaction_id($transaction_key);
    return $fields;
}

sub _check_login {
    my $self = shift;
    Carp::croak "Not logged in." unless $self->_logged_in();
    return 1;
}

sub logout {
    my $self = shift;
    $self->_transition('logout', +{});
    $self->{_logged_in} = 0;
    return;
}

1;
__END__

=head1 NAME

Finance::Bank::JP::MUFG - Checks account balances and transactions of MUFG-DIRECT account.

=head1 SYNOPSIS

  use Finance::Bank::JP::MUFG;

  my $mufg = Finance::Bank::JP::MUFG->new(
      contract_no => 'your_contract_no',
      password    => 'your_direct_password',
  )->login;

  my @accounts = $mufg->accounts;

  for my $account (@accounts) {
      printf "%-s  %-s  %-7s %9syen %9syen\n",
          $account->branch,
          $account->account_kind,
          $account->account_no,
          commify($account->balance),
          commify($account->withdrawal_limit);
  }

  my @transactions = $mufg->transactions(
      account_no       => 1,
      transaction_kind => 1,
      period           => 1,
  );

  for my $transaction (@transactions) {
      printf "%-s  %-s  %-s  %syen  %syen  %syen  %-s\n",
          $transaction->date->ymd('/'),
          $transaction->abstract,
          $transaction->description,
          commify($transaction->outlay),
          commify($transaction->income),
          commify($transaction->balance),
          $transaction->memo;
  }

  my $csv_path = $mufg->download_transactions(
      account_no       => 1,
      transaction_kind => 1,
      period           => 4,
      from             => '2012/9/1',
      to               => '2012/10/12',
      save_dir         => '/tmp',
      to_utf8          => 0,
  );

  say $csv_path;

  $mufg->logout;

=head1 DESCRIPTION

This module provides methods to access data from MUFG-DIRECT accounts,
including account balances and recent transactions. It also provides
a method to download data in CSV format from a given date or date range.

=head1 CONSTRUCTOR AND STARTUP

=head2 new( %options )

Creates and returns a new Finance::Bank::JP::MUFG object.

  my $mufg = Finance::Bank::JP::MUFG->new( ... );

This constructor has to pass two parameters of the Contract Number and Password.

  contract_no => 'your_contract_no',
  password    => 'your_direct_password',

You can also specify the user agent.

  agent => [alias]

The list of valid aliases is:

=over 6

=item * Windows IE 6

=item * Windows Mozilla

=item * Mac Safari

=item * Mac Mozilla(Default value)

=item * Linux Mozilla

=item * Linux Konqueror

=back

=head1 METHODS

=head2 $mufg->login()

Runs login process and returns a self object.
Be sure to call after object creation.

=head2 $mufg->accounts()

Returns an array of all the account balances.
This array stores L<Finance::Bank::JP::MUFG::Account> objects,
and you can access with the following accessors.

=over 5

=item * branch

=item * account_kind

=item * account_no

=item * balance

=item * withdrawal_limit

=back

=head2 $mufg->transactions( %options )

Specify as follows, passing the hash to the argument.

=over 6

=item * C<< account_no => [1|2|3|..N] >>

Choose which account to retrieve data.
Default value is 1 and which is optional.

=item * C<< transaction_kind => [1|2|3|4] >>

Choose transaction kinds.
Default value is 1 and which is optional.

  1 ALL
  2 MONEY RECEIVED
  3 WITHDRAWAL
  4 TRANSFER PAYMENT

=item * C<< period => [1|2|3|4] >>

Choose period to retrieve data.
Default value is 1 and which is optional.

  1 From the beginning of one month ago until today
  2 Recent 10 days
  3 Specified date
  4 Specified period

=item * C<< date => '%Y/%m/%d' >>

If period's value is 3, specified date is used.
Default value is today and which is optional.

=item * C<< from => '%Y/%m/%d' >>

If period's value is 4, specified date is used.
This parameter is required.

=item * C<< to => '%Y/%m/%d' >>

If period's value is 4, specified date is used.
Default value is today and which is optional.

=back

Returns an array of transactions.
This array stores L<Finance::Bank::JP::MUFG::Transaction> objects,
and you can access with the following accessors.

=over 7

=item * L<date|Time::Piece>

=item * abstract

=item * description

=item * outlay

=item * income

=item * balance

=item * memo

=back

=head2 $mufg->download_transactions( %options )

Returns a saved path.
Specify as follows, passing the hash to the argument.

=over 8

=item * C<< account_no => [1|2|3|..N] >>

Choose which account to retrieve data.
Default value is 1 and which is optional.

=item * C<< transaction_kind => [1|2|3|4] >>

Choose transaction kinds.
Default value is 1 and which is optional.

  1 ALL
  2 MONEY RECEIVED
  3 WITHDRAWAL
  4 TRANSFER PAYMENT

=item * C<< period => [1|2|3|4] >>

Choose period to retrieve data.
Default value is 1 and which is optional.

  1 From the beginning of one month ago until today
  2 Recent 10 days
  3 Specified date
  4 Specified period

=item * C<< date => '%Y/%m/%d' >>

If period's value is 3, specified date is used.
Default value is today and which is optional.

=item * C<< from => '%Y/%m/%d' >>

If period's value is 4, specified date is used.
This parameter is required.

=item * C<< to => '%Y/%m/%d' >>

If period's value is 4, specified date is used.
Default value is today and which is optional.

=item * C<< save_dir => '/path/to/save_dir' >>

Set the save directory.

=item * C<< to_utf8 => [0|1] >>

Set a flag. If flag is off, CSV's charset is cp932.
Default is off and which is optional.

=back

=head1 AUTHOR

Yusuke Maeda E<lt>dev.perfumed.garden@gmail.comE<gt>

=head1 FINANCE::BANK::JP::MUFG'S GIT REPOSITORY

Finance::Bank::JP::MUFG is hosted at GitHub.

Repository: https://github.com/perforb/p5-Finance-Bank-JP-MUFG

=head1 SEE ALSO

L<MUFG-DIRECT|http://direct.bk.mufg.jp/>

L<WWW::Mechanize>

L<HTML::TreeBuilder::XPath>

L<HTML::Selector::XPath>

L<Finance::Bank::JP::MUFG::Account>

L<Finance::Bank::JP::MUFG::Transaction>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
