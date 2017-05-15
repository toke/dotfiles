#!/usr/bin/perl -I /home/toke/perl5


use strict;
use warnings;

use DateTime;
use List::MoreUtils qw(any);
use Data::Dumper;
use Net::Netrc;
use Scalar::Util qw(looks_like_number);

use lib '/home/toke/perl5/lib/perl5';
use EWS::Client;

# Simple OWA Calendar exporter
# See https://metacpan.org/pod/EWS::Client::Calendar for more Inforamtion

our $owa_server = 'owa.extranet.1and1.org';
## Credentials have to be set in ~/.netrc

## Which Appointments should be ignored
our $ignore = {
  subjects => ["Mittagspause", "Blocker"],
  statuses => [],                              # Free, Busy, OOF, Tentative
  sensitivity => [],  # Normal, Personal, Private, Confidential
};

our $notify = [43, 10, 5, -5];

our $debug = 0;

################################################################################
my $delta;
if (looks_like_number($ARGV[0])) {
  $delta = int($ARGV[0]);
} else {
  $delta = 0;
}
our $export_range = { start => {days => $delta}, end => {days => $delta+1}};

{
  my $owa =  Net::Netrc->lookup($owa_server);
  die ("No credentials for machine \"$owa_server\" found in .netrc") unless $owa;

  my $ews = EWS::Client->new({
      server      => $owa_server,
      username    => $owa->login,
      password    => $owa->password,
      use_negotiated_auth => 1
  });

  # Retrieve EWS-Calendar entries for specified timeframe
  my $entries = $ews->calendar->retrieve({
      start => DateTime->today->add($export_range->{start}),
      end   => DateTime->today->add($export_range->{end}),
  });

  print "I retrieved ". $entries->count ." items\n" if $debug;

  ## Iterate over all Items
  while ($entries->has_next) {
      my %target;
      my $entry = $entries->next();
      print Dumper($entry) if $debug;

      $target{subject} = $entry->Subject;
      $target{subject} =~ s/^\s+|\s+$//g; # trim spaces
      $target{subject} =~ s/^(WG|AW)://g;

      next if $entry->IsCancelled;
      next if $entry->IsAllDayEvent;
      next if (any {$target{subject} eq $_} @{$ignore->{subjects}});
      next if (any {$entry->Status eq $_} @{$ignore->{statuses}});
      next if (any {$entry->Sensitivity eq $_} @{$ignore->{sensitivity}});

      my $min_to_start = $entry->Start->subtract_datetime(DateTime->now)->in_units('minutes');
 

      if ($min_to_start <= $notify->[0] && $min_to_start >= $notify->[3]) {
          print "${min_to_start}min $target{subject}\n";
          print "${min_to_start}m\n";
         
          if ($min_to_start <= $notify->[0] && $min_to_start >= $notify->[1]) {
              print "\n";
          } elsif ($min_to_start <= $notify->[1] && $min_to_start >= $notify->[2]) {
              print "#00ffff\n";
          } elsif ($min_to_start <= $notify->[2] && $min_to_start > $notify->[3]) {
              print "#ff0000\n";
          }
      }
  }
}

1;
