use inc::Module::Install;
name 'Finance-Bank-JP-MUFG';
all_from 'lib/Finance/Bank/JP/MUFG.pm';

requires 'WWW::Mechanize' => '1.72';
requires 'HTML::TreeBuilder::XPath' => '0.14';
requires 'HTML::Selector::XPath' => '0.15';
requires 'List::MoreUtils';
requires 'Cwd';
requires 'Carp';
requires 'Time::Piece' => '1.20';
requires 'Encode' => '2.47';
requires 'Encode::Alias' => '2.16';
requires 'LWP::Protocol::https' => '6.03';
requires 'Class::Accessor::Lite' => '0.05';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More' => '0.98';
test_requires 'Test::MockObject::Extends' => '1.20120301';
auto_set_repository;
auto_include;
WriteAll;
