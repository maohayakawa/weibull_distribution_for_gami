#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use DBI;
use DateTime;
use Teng;
use Teng::Schema::Loader;

#####  MyModule  ########
use Weibull_paramater;
use Date_change;
###########################

# MySQLの設定
my $dsn    = 'dbi:mysql:recruit';
my $user   = 'root';
my $passwd = '';

my $dbh = DBI ->connect($dsn, $user, $passwd, {
  'musql_enable_utf8' => 1,
});

my $teng = Teng::Schema::Loader->load(
  'dbh'       => $dbh,
  'namespace' => 'Weibull_distribution::DB',
);

my $bunri = 2; #(1-文系 2-理系)
my $gakushu = 2; #(1-博士 2-修士 3-学部 4-短大 5-専門学校 6-高専)
my $row = $teng->search(
  'all_retire_students',
  {bunri => $bunri, gakusgu => $gakushu}
);

my $data_hash = Data_change::change($row);
my ($scale,$shape) = weibull_paramater($data_hash);

print "scale=$scale ,, shape = $shape\n";

