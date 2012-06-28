use strict;
use warnings;

use Test::More;
use HTML::Selector::XPath 'selector_to_xpath';
use Finance::Bank::JP::MUFG;

subtest q{Xpath.} => sub {
    {
        my $xpath = Finance::Bank::JP::MUFG::_get_xpath('balance');
        is( $xpath, '/html/body/div/form[2]/div[3]/div[2]/div[3]/table/tbody/tr' );
    }
    {
        my $xpath = Finance::Bank::JP::MUFG::_get_xpath('transaction');
        is( $xpath, '/html/body/div/form[2]/div[3]/div[2]/div[5]/table/tbody/tr' );
    }
    {
        my $xpath = Finance::Bank::JP::MUFG::_get_xpath('transaction_i');
        is( $xpath, '/html/body/div/form[2]/div[3]/div[2]/div[6]/table/tbody/tr' );
    }
    {
        my $xpath = Finance::Bank::JP::MUFG::_get_xpath('hidden');
        is( $xpath, selector_to_xpath('div#container input[type=hidden]') );
    }
    {
        my $xpath = Finance::Bank::JP::MUFG::_get_xpath('attention');
        is( $xpath, selector_to_xpath('div#contents div.serviceContents div.msgArea p.attention') );
    }
    {
        my $xpath = Finance::Bank::JP::MUFG::_get_xpath('attention_i');
        is( $xpath, selector_to_xpath('div#contents div.serviceContents div.infoArea p.attention') );
    }
    {
        my $xpath = Finance::Bank::JP::MUFG::_get_xpath('unread_info');
        is( $xpath, selector_to_xpath('div#contents form[name=informationShousaiActionForm]') );
    }
};

done_testing;
