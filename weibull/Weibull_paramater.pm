package Weibull_paramater;
use strict;
use warnings;
use utf8;
use DBI;
use DateTime;
use Teng;
use Teng::Schema::Loader;


sub estimate_paramater {
  my $data_hash = @_;
  my @array;
  for my $data ($data_hash) {
      push @array => $data->{'new_date'};
  }
  my $data_length = @array;
  my $loop = 10000;
  my $epsilon = 1e-7;
  my $error = "true";
  my $a = 1;
  my $m = 1;
  for my $loop_count (0..$loop) {
    my $a_before = $a;
    my $m_before = $m;
    my $sum_temp1 = 0;
    my $sum_temp2 = 0;
    my $sum_temp1_2 = 0;
    for my $data_count (0..$data_length-1) {
      my $temp1 = (($array[$data_count])**($m_before));
      my $temp2 = log($array[$data_count]);
      $sum_temp1 += $temp1;
      $sum_temp2 += $temp2;
      $sum_temp1_2 += ($temp1*$temp2);
    }
    $a = $data_length/$sum_temp1;
    $m = $data_length/($a*$sum_temp1_2-$sum_temp2);
    if(abs($a-$a_before) < $epsilon and abs($m-$m_before) < $epsilon) {
      $error = "false";
      last;
    }
  }
  if($error eq "true"){
    print "収束しませんでした\n";
    return undef;
  }
  my $scale = ((1/$a)**(1/$m));
  my $shape = $m;
  return $scale,$shape;
}

1;
