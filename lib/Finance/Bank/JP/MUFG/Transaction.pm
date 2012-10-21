package Finance::Bank::JP::MUFG::Transaction;

use strict;
use warnings;
our $VERSION = '0.02';

BEGIN {
    my @columns = qw/ date abstract description outlay income balance memo /;
    sub columns { @columns }
}

use Class::Accessor::Lite (
    new => 1,
    ro  => [ &columns ],
);

1;
__END__

=head1 NAME

Finance::Bank::JP::MUFG::Transaction - Object of MUFG transaction

=head1 ACCESSORS

You can access with the following accessors.

=over 7

=item * L<date|Time::Piece>

=item * abstract

=item * description

=item * outlay

=item * income

=item * balance

=item * memo

=back

=head1 AUTHOR

perforb E<lt>dev.perfumed.garden@gmail.comE<gt>

=head1 SEE ALSO

L<Finance::Bank::JP::MUFG>

L<Finance::Bank::JP::MUFG::Account>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
