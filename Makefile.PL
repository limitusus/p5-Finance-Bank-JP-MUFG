use inc::Module::Install;
name 'Finance-Bank-JP-MUFG';
all_from 'lib/Finance/Bank/JP/MUFG.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
