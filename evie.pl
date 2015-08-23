#!/usr/bin/env perl

use Dancer2;
use File::Basename;
use DBI;
use Data::Dumper qw(Dumper);

use utf8;
use Encode qw(decode);
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
  q(집밥) => q(Home Meal Chef Baek),
  q(냉장고) => q(Take Care of My Refrigerator),
  q(개그) => q(Gag Concert),
  q(1박) => q(2 Days & 1 Night),
  q(친구의) => q(Where is My Friend's Home),
  q(너의 목소리가) => q(I See Your Voice),
  q(비정상) => q(Non-Summit),
  q(슈퍼맨이) => q(The Return of Superman),
  q(학교) => q(Off to School),
  q(지니어스) => q(The Genius),
);
my $dbfile = 'titles.db';

get '/match' => sub {
  my $input = params->{f};
  print "got " . $input. "\n" if DEBUG();

  my $result = {};

  # add more from db on demand
  my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","");
  map {
    my $r = $_;
    # sqlite gives me unicode
    $db_show{ decode('utf-8', $r->{'key'}) } = $r->{'title'};
  } @{ $dbh->selectall_arrayref('select key, title from titles',
      { Slice => {} }
    )
  };

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
