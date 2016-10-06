#!/usr/bin/perl

use strict;
use List::Util 'shuffle';

# This script responds to the following calls
# [?count=:n]
#    {
#     "donuts": [
#         "http://url-to-donut-pic.jpg",
#         "http://url-to-donut-pic.jpg",
#         "http://url-to-donut-pic.jpg",
#         "http://url-to-donut-pic.jpg",
#         "http://url-to-donut-pic.jpg" ]
#    }
#
# random
# { "donut" : "http://url-to-donut-pic.jpg" }

# I think for now I'll host the images.  yolo.

use CGI;
my $q = CGI->new;
my %params = $q->Vars;

my $baseurl = "http://perlhack.com/donutme";
my @images = map { local $_ = $_; s/^\./$baseurl/; $_ } <./img/*>;
my @shuffled = shuffle(@images);
my $n_images = $#images;

print $q->header('application/json');
my $json_response =  '{ "error": "Invalid Argument" }';

if (defined $params{count}) {
  if ($params{count} =~ m/^([\d]+)$/) {
    my $count = $1;

    if ($count == 1) {
      $json_response = get_one_rando();
    } else {
      $count = ($count > $n_images) ? $n_images : $count;
      my $resp_str = '{ "donuts": [ ';
      for (my $i=0; $i<$count; $i++){
        $resp_str .= '"' . $shuffled[$i] . '"';
        $resp_str .= ", " unless $i == ($count - 1);
      }
      $resp_str .= ' ] }';
      $json_response = $resp_str;
    }
  }
} elsif (defined $params{keywords} && $params{keywords} eq 'random') {
  $json_response = get_one_rando();
}

sub get_one_rando {
  my $pre = '{ "donut": "';
  my $rn = int(rand($n_images));
  my $url = $images[$rn];
  my $post = '" }';
  return $pre . $url . $post;
}

print $json_response;
