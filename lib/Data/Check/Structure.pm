package Data::Check::Structure;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       is_aoa
                       is_aoaos
                       is_aoh
                       is_aohos
                       is_aos
                       is_hoa
                       is_hoaos
                       is_hoh
                       is_hohos
                       is_hos
               );

sub is_aos {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'ARRAY';
    for my $i (0..@$data-1) {
        last if defined($max) && $i >= $max;
        return 0 if ref($data->[$i]);
    }
    1;
}

sub is_aoa {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'ARRAY';
    for my $i (0..@$data-1) {
        last if defined($max) && $i >= $max;
        return 0 unless ref($data->[$i]) eq 'ARRAY';
    }
    1;
}

sub is_aoaos {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'ARRAY';
    my $aos_opts = {max=>$max};
    for my $i (0..@$data-1) {
        last if defined($max) && $i >= $max;
        return 0 unless is_aos($data->[$i], $aos_opts);
    }
    1;
}

sub is_aoh {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'ARRAY';
    for my $i (0..@$data-1) {
        last if defined($max) && $i >= $max;
        return 0 unless ref($data->[$i]) eq 'HASH';
    }
    1;
}

sub is_aohos {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'ARRAY';
    my $hos_opts = {max=>$max};
    for my $i (0..@$data-1) {
        last if defined($max) && $i >= $max;
        return 0 unless is_hos($data->[$i], $hos_opts);
    }
    1;
}

sub is_hos {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'HASH';
    my $i = 0;
    for my $k (keys %$data) {
        last if defined($max) && ++$i >= $max;
        return 0 if ref($data->{$k});
    }
    1;
}

sub is_hoa {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'HASH';
    my $i = 0;
    for my $k (keys %$data) {
        last if defined($max) && ++$i >= $max;
        return 0 unless ref($data->{$k}) eq 'ARRAY';
    }
    1;
}

sub is_hoaos {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'HASH';
    my $i = 0;
    for my $k (keys %$data) {
        last if defined($max) && ++$i >= $max;
        return 0 unless is_aos($data->{$k});
    }
    1;
}

sub is_hoh {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'HASH';
    my $i = 0;
    for my $k (keys %$data) {
        last if defined($max) && ++$i >= $max;
        return 0 unless ref($data->{$k}) eq 'HASH';
    }
    1;
}

sub is_hohos {
    my ($data, $opts) = @_;
    $opts //= {};
    my $max = $opts->{max};

    return 0 unless ref($data) eq 'HASH';
    my $i = 0;
    for my $k (keys %$data) {
        last if defined($max) && ++$i >= $max;
        return 0 unless is_hos($data->{$k});
    }
    1;
}

1;
# ABSTRACT: Check structure of data

=head1 SYNOPSIS


=head1 DESCRIPTION

This small module provides several simple routines to check the structure of
data, e.g. whether data is an array of arrays ("aoa"), array of scalars ("aos"),
and so on.


=head1 FUNCTIONS

None exported by default, but they are exportable.

=head2 is_aos($data[, \%opts]) => bool

Check that data is an array of scalars. Examples:

 is_aos([]);                     # true
 is_aos(['a', 'b']);             # true
 is_aos(['a', []]);              # false
 is_aos([1,2,3, []], {max=>3});  # true

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_aoa($data[, \%opts]) => bool

Check that data is an array of arrays. Examples:

 is_aoa([]);                          # true
 is_aoa([[1], [2]]);                  # true
 is_aoa([[1], 'a']);                  # false
 is_aoa([[1],[],[], 'a'], {max=>3});  # true

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_aoaos($data[, \%opts]) => bool

Check that data is an array of arrays of scalars. Examples:

 is_aoaos([]);                           # true
 is_aoaos([[1], [2]]);                   # true
 is_aoaos([[1], [{}]]);                  # false
 is_aoaos([[1],[],[], [{}]], {max=>3});  # true

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_aoh($data[, \%opts]) => bool

Check that data is an array of hashes. Examples:

 is_aoh([]);                             # true
 is_aoh([{}, {a=>1}]);                   # true
 is_aoh([{}, 'a']);                      # false
 is_aoh([{},{},{a=>1}, 'a'], {max=>3});  # true

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_aohos($data[, \%opts]) => bool

Check that data is an array of hashes of scalars. Examples:

 is_aohos([]);                                 # true
 is_aohos([{a=>1}, {}]);                       # true
 is_aohos([{a=>1}, {b=>[]}]);                  # false
 is_aohos([{a=>1},{},{}, {b=>[]}], {max=>3});  # true

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_hos($data[, \%opts]) => bool

Check that data is a hash of scalars. Examples:

 is_hos({});                                   # true
 is_hos({a=>1, b=>2});                         # true
 is_hos({a=>1, b=>[]});                        # false
 is_hos({a=>1, b=>2, c=>3, d=>[]}, {max=>3});  # true (or false, depending on random hash key ordering)

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_hoa($data[, \%opts]) => bool

Check that data is a hash of arrays. Examples:

 is_hoa({}) );       # true
 is_hoa({a=>[]}) );  # true
 is_hoa({a=>1}) );   # false

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_hoaos($data[, \%opts]) => bool

Check that data is a hash of arrays of scalars. Examples:

 is_hoaos({}) );         # true
 is_hoaos({a=>[]}) );    # true
 is_hoaos({a=>[1]}) );   # true
 is_hoaos({a=>1}) );     # false
 is_hoaos({a=>[{}]}) );  # false

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_hoh($data[, \%opts]) => bool

Check that data is a hash of hashes. Examples:

 is_hoh({}) );       # true
 is_hoh({a=>{}}) );  # true
 is_hoh({a=>1}) );   # false

Known options: C<max> (maximum number of items to check, undef means check all
items).

=head2 is_hohos($data[, \%opts]) => bool

Check that data is a hash of hashes of scalrs. Examples:

 is_hohos({}) );            # true
 is_hohos({a=>{}}) );       # true
 is_hohos({a=>{b=>1}}) );   # true
 is_hohos({a=>1}) );        # false
 is_hohos({a=>{b=>[]}}) );  # false

Known options: C<max> (maximum number of items to check, undef means check all
items).

=cut
