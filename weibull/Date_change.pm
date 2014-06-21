package Data_change;
use strict;
use warnings;
use utf8;
use DBI;
use DateTime;
use Teng;
use Teng::Schema::Loader;

#時間変換のファンクション
sub change {
  my $data_hash = @_;
  my $dt2;
  my $dt1 = DateTime -> new(
    year => 2011,
    month => 12,
    day => 1,
  );
  foreach($data_hash) {
    if(/(\S+)-(\S+)-(\S+)/){
      #print "years $1, month $2, day $3\n";
      $dt2 = DateTime -> new(
        year => $1,
        month => $2,
        day => $3,
      );
    }
    my $duration = $dt2 - $dt1;
    my @units = $duration->in_units( qw(years months days) );
    my $date_clu = $units[0]*365+$units[1]*30+$units[2];
    $data_hash = +{ new_date => $date_clu };
  }
  return $data_hash
}