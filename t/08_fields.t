use strict;
use warnings;

use Test::More;
use WWW::Mechanize;
use HTML::TreeBuilder::XPath;
use HTML::Selector::XPath 'selector_to_xpath';
use Finance::Bank::JP::MUFG;
use t::Helper::Page;

subtest q{Form Fields.} => sub {
    my $tree       = HTML::TreeBuilder::XPath->new;
    my $login_page = t::Helper::Page::login();

    $tree->parse($login_page);

    my $xpath  = Finance::Bank::JP::MUFG::_get_xpath('hidden');
    my @nodes  = $tree->findnodes($xpath);
    my $fields = Finance::Bank::JP::MUFG::_create_form_fields(
        'login',
        +{  KEIYAKU_NO => '12345678',
            PASSWORD   => 'inaccurate_password',
        },
        \@nodes
    );

    note( explain($fields) );
    is_deeply(
        $fields,
        {   KEIYAKU_NO   => '12345678',
            PASSWORD     => 'inaccurate_password',
            _FRAMID      => '',
            _LUID        => 'LUID',
            _PAGEID      => 'AA011',
            _SENDTS      => $fields->{_SENDTS},
            _SUBINDEX    => '-1',
            _TARGET      => '',
            _TARGETWINID => '',
            _TRANID      => 'AA011_001',
            _WINID       => 'root'
        }
    );
};

done_testing;
