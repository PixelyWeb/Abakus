#!/usr/bin/perl -w
# Abakus 1.0.8
#
# Abakus is a powerful tool which allows you to real-time analyse log files and extracting valuables information.
# Copyright (C) 2012 Rachid El Youssfi (rachid@elyoussfi.com)
#
# This file is part of Abakus.
#
# Abakus is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Abakus is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Abakus.  If not, see <http://www.gnu.org/licenses/>.

package Hook;
use strict;
use warnings;
use Exporter;
use Thread::Queue;
use Time::Local;

our @ISA= qw( Exporter );
our @EXPORT = qw(  );
our @EXPORT_OK = qw( $data_queue );
our $data_queue = Thread::Queue->new();

sub save_callflow_to_json{
	my ($d, $output);
	my %cf = ();
	
	open (CAPTURE, ">>_json_buffer") or die "Error: Can't open the capture file: $!.";
	while ($d = $data_queue->dequeue()) {
		last if $d eq 'quit';
		my @l = split /\n/, $d;
		foreach my $l( @l ){
			if(
			my($date,$source,$xid,$from,$packet,$mac_address) 
			= $l 
			=~ m/([0-9: ,-]+) \[([A-Za-z0-9]+)\] .*xid:([A-Za-z0-9]+) ([A-Za-z]+) ([A-Z \/]+) [fromt]+ ([A-Za-z0-9]+) .*/){
			my $ts = parse_date($date);
			my $_id = generate_random_string(25);
			my $json = '{ "_id" : ObjectId("'.$_id.'"), "timestamp" : "'.$ts.'", '
						.'"date" : "'.$date.'", "source" : "'.$source.'", '
						.'"xid" : "'.$xid.'", "from" : "'.$from.'", "packet" : "'.$packet.'", '
						.'"mac_address" : "'.$mac_address.'" }';
			print CAPTURE "$json\n";
			}
		}
	}
	close CAPTURE;
	return $output;
}

sub generate_random_string
{
	my $length_of_randomstring=shift;# the length of 
			 # the random string to generate

	my @chars=('a'..'z','0'..'9');
	my $random_string;
	foreach (1..$length_of_randomstring) 
	{
		# rand @chars will generate a random 
		# number between 0 and scalar @chars
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}

sub parse_date {
  my($s) = @_;
  my $date_reg = '^\s*(\d{1,4})\W*0{0,1}(\d{1,2})\W*0{0,1}(\d{1,2})\s*\W*0{0,1}(\d{0,2})\W*0{0,1}(\d{0,2})\W*0{0,1}(\d{0,2})';
  my($year, $month, $day, $hour, $minute, $second) = (0, 0, 0, 0, 0, 0);
  if($s =~ m/$date_reg/g) {
	foreach my $a (@_){
		print " regex match : $a \n";
	}
	print "$1 $2 $3 $4 $5 $6 \n";
    $year = $1;  $month = $2;   $day = $3;
    $hour = $4;  $minute = $5;  $second = $6;
    $hour = $hour ? $hour |= 0 : $hour;
	$minute = $minute ? $minute |= 0 : $minute;
	$second = $second ? $second |= 0 : 0;
	
	
    $year = ($year<100 ? ($year<70 ? 2000+$year : 1900+$year) : $year);
	return timelocal($second,$minute,$hour,$day,$month-1,$year);
  }
  return -1;
}

1;
