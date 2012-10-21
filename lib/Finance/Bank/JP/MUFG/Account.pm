package Finance::Bank::JP::MUFG::Account;

use strict;
use warnings;
our $VERSION = '0.02';

BEGIN {
    my @columns = qw/ branch account_kind account_no balance withdrawal_limit /;
    sub columns { @columns }
}

use Class::Accessor::Lite (
    new => 1,
    ro  => [ &columns ],
);

1;
__END__

=head1 NAME

Finance::Bank::JP::MUFG::Account - Object of MUFG account balance

=head1 ACCESSORS

You can access with the following accessors.

=over 5

=item * branch

=item * account_kind

=item * account_no

=item * balance

=item * withdrawal_limit

=back

=head1 AUTHOR

perforb E<lt>dev.perfumed.garden@gmail.comE<gt>

=head1 SEE ALSO

L<Finance::Bank::JP::MUFG>

L<Finance::Bank::JP::MUFG::Transaction>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
