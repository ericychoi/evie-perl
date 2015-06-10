#!/usr/bin/env perl

use Dancer2;
use File::Basename;
use Data::Dumper qw(Dumper);

use utf8;
use strict;
use warnings;

use constant DEBUG => 0;

set serializer => 'JSON';

# need to return show, season, file in JSON
my %db_show = (
  q(무한도전) => q(Infinite Challenge),
  q(진짜 사나이) => q(Real Men),
  q(진짜사나이) => q(Real Men),
  q(런닝맨) => q(Running Man),
);

get '/match' => sub {
  my $input = params->{f};
  print "got " . $input. "\n" if DEBUG();

  my $result = {};

  for my $show (keys %db_show) {
    print "matching $show with $input\n" if DEBUG();
    if ($input =~ /$show/u) {
      print "match found\n" if DEBUG();
      $result->{show} = $db_show{$show};
      last;
    }
  }
  unless ($result->{show}) {
    status 'not_found';
    return { error => "match not found for $input" };
  }

  my $ext = 'mp4'; # default
  $input =~ /\.(\w+)$/;
  $ext = $1;

  my $date = 'XXXX-XX-XX';
  if ($input =~ /(\d{2})(\d{2})(\d{2})/) { # 150610
    $result->{season} = "20$1";
    $date = $result->{season}."-$2-$3";
  }
  elsif ($input =~ /(\d{4}-\d{2}-\d{2})/) { # 2015-06-10
    $date = $1;
  }

  $result->{file} = $result->{show}." - $date.$ext";
  print "returning ".Dumper($result)."\n" if DEBUG();

  return $result;
};

dance;