use strict;
use warnings;

use Test::More;
use WWW::Mechanize;
use HTML::TreeBuilder::XPath;
use HTML::Selector::XPath 'selector_to_xpath';
use Finance::Bank::JP::MUFG;

subtest q{Form Fields.} => sub {
    my $mech = WWW::Mechanize->new( autocheck => 1, );
    my $url = Finance::Bank::JP::MUFG::_get_url('login');

    $mech->get($url);

    my $tree       = HTML::TreeBuilder::XPath->new;
    my $login_page = $mech->content;

    $tree->parse($login_page);

    my $xpath  = selector_to_xpath('div#container input[type=hidden]');
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
