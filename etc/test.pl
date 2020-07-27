#!/usr/bin/env perl

use 5.010;
use Encode::Locale;
use File::Find;

my @tex;
find(
  {
    wanted => sub {
      push @tex, Encode::decode locale_fs => $File::Find::name if $File::Find::name =~ /\.tex$/;
    },
  },
  ".",
);

say $_ for @tex;