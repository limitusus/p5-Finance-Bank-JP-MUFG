use inc::Module::Install;
name 'Finance-Bank-JP-MUFG';
all_from 'lib/Finance/Bank/JP/MUFG.pm';

requires 'WWW::Mechanize';
requires 'HTML::TreeBuilder::XPath';
requires 'HTML::Selector::XPath';
requires 'List::MoreUtils';
requires 'Cwd';
requires 'Carp';
requires 'Time::Piece';
requires 'Encode';
requires 'Encode::Alias';
requires 'LWP::Protocol::https';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
