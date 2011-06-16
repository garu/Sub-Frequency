package Sub::Frequency;

use strict;
use warnings;

use Carp 'croak';

use parent 'Exporter';

our @EXPORT = qw(
  always normally usually often sometimes maybe rarely seldom never
);
our @EXPORT_OK = @EXPORT;

our $VERSION = '0.03';

my %probabilities = (
    'Sub::Frequency::Always'    => 1.00,
    'Sub::Frequency::Normally'  => 0.75,
    'Sub::Frequency::Sometimes' => 0.50,
    'Sub::Frequency::Rarely'    => 0.25,
    'Sub::Frequency::Never'     => 0.00,
);

sub always(&;@) {
    my ( $code, @rest ) = @_;
    my $name = 'Sub::Frequency::Always';

    if (wantarray) {
        return ( bless( $code, $name ), @rest );
    }
    else {
        _exec( $code, $name, @rest );
    }
}

sub normally(&;@) {
    my ( $code, @rest ) = @_;
    my $name = 'Sub::Frequency::Normally';

    if (wantarray) {
        return ( bless( $code, $name ), @rest );
    }
    else {
        _exec( $code, $name, @rest );
    }
}

sub sometimes(&;@) {
    my ( $code, @rest ) = @_;
    my $name = 'Sub::Frequency::Sometimes';

    if (wantarray) {
        return ( bless( $code, $name ), @rest );
    }
    else {
        _exec( $code, $name, @rest );
    }
}

sub rarely(&;@) {
    my ( $code, @rest ) = @_;
    my $name = 'Sub::Frequency::Rarely';

    if (wantarray) {
        return ( bless( $code, $name ), @rest );
    }
    else {
        _exec( $code, $name, @rest );
    }
}

sub never(&;@) {
    my ( $code, @rest ) = @_;
    my $name = 'Sub::Frequency::Never';

    if (wantarray) {
        return ( bless( $code, $name ), @rest );
    }
    else {
        _exec( $code, $name, @rest );
    }
}

*often   = \&normally;
*usually = \&normally;
*maybe   = \&sometimes;
*seldom  = \&rarely;

sub _exec {
    my ( $code, $name, @rest ) = @_;

    $code->() and return if rand() < $probabilities{$name};

    foreach $code (@rest) {
        $code->() and return if rand() < $probabilities{ ref($code) };
    }
}

sub _coerce {
    my $thing = shift;

    # matches N%, .N% and N.N%
    if ( $thing =~ m/^\s*(\d+|\d*\.\d+)\s*%\s*$/ ) {
        return $1 / 100;
    }
    else {
        croak "'$thing' does not look like a number or a percentage.";
    }
}

42;
__END__

=head1 NAME

Sub::Frequency - Run code blocks according to a given probability

=head1 SYNOPSIS

    use Sub::Frequency;

    always {
        # code here will always run
    };

    usually {
        # code here will run 75% of the time
        # 'normally' also works
    };

    sometimes {
        # code here will run 50% of the time
        # 'maybe' also works
    };

    rarely {
        # code here will run 25% of the time
        # 'seldom' also works
    };

    never {
        # code here will never run
    };

You can also specify your own probability for the code to run:

    with_probability 0.42 => sub {
        ...
    };


=head1 DESCRIPTION

This module provides a small DSL to deal with an event's frequency,
or likelihood of happening.

Potential aplications include games, pseudo-random events and anything
that may or may not run with a given probability.

=head1 EXPORTS

All functions are exported by default using L<Exporter>.

If you need to rename any of the keywords, consider using
L<Sub::Import> to get L<Sub::Exporter>'s flexibility.


=head2 always

Takes a mandatory subroutine and executes it every time.


=head2 usually

=head2 normally

Takes a mandatory subroutine and executes it with a probability of 75%.


=head2 sometimes

=head2 maybe

Takes a mandatory subroutine and executes it with a probability of 50%.


=head2 rarely

=head2 seldom

Takes a mandatory subroutine and executes it with a probability of 25%.


=head2 never

Takes a mandatory subroutine and does nothing.    


=head2 with_probability

Takes a probability and a subroutine, and executes the subroutine
with the given probability.

The probability may be a real number between 0 and 1, or a
percentage, passed as a string:

    with_probability 0.79 => \&foo;

    with_probability '79%' => \&bar;


Also, for greater flexibility, spaces around the number are trimmed,
and we don't care about leading zeros:

    with_probability .04 => \&baz;

    with_probability ' .4  %  ' => \&something;


And you can, of course, replace the C<< => >> with a C<,>:

    with_probability 20, {
        say "Mutley, do something!"
    };


=head1 DIAGNOSTICS

I<< "$foo does not look like a number or a percentage." >>

B<Hint:> Are you using something other than '.' as your floating point
separator?

This coercion error may occur when you try passing a scalar to
with_probability() with something that doesn't look like a number
or a percentage. Like:

    with_probability 'monkey', { say 'some code' };

In the code above, you should replace 'monkey' with a number
between 0 and 1, or a percentage string (such as '15%').


=head1 AUTHORS

Breno G. de Oliveira, C<< <garu at cpan.org> >>

Tiago Peczenyj


=head1 BUGS

Please report any bugs or feature requests to C<bug-sub-frequency at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Sub-Frequency>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Sub::Frequency


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Sub-Frequency>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Sub-Frequency>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Sub-Frequency>

=item * Search CPAN

L<http://search.cpan.org/dist/Sub-Frequency/>

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Breno G. de Oliveira, Tiago Peczenyj.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


