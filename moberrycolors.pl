use strict;
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = "1";
%IRSSI = (
	authors		=> 'Mosai',
	contact 	=> 'mosai57@gmail.com',
	name		=> 'Colors',
	description 	=> 'Changes text to rainbow colors.',
	license		=> 'All Rights Reserved',
	changed 	=> '2013-12-2 03:46 (UTC-8:00)',
);

# colors list
#  0 == white
#  4 == light red
#  8 == yellow
#  9 == light green
# 11 == light cyan
# 12 == light blue
# 13 == light magenta
my @colors = ('0', '4', '8', '9', '11', '12', '13');

# str make_colors($string)
# returns random-coloured string
sub make_colors {
	my ($string) = @_;
	my $newstr = "";
	my $last = 255;
	my $color = 0;

	for (my $c = 0; $c < length($string); $c++) {
		my $char = substr($string, $c, 1);
		if ($char eq ' ') {
			$newstr .= $char;
			next;
		}
		while (($color = int(rand(scalar(@colors)))) == $last) {};
		$last = $color;
		$newstr .= "\003";
		$newstr .= sprintf("%02d", $colors[$color]);
		$newstr .= (($char eq ",") ? ",," : $char);
	}

	return $newstr;
}

sub rsay {
	my ($text, $server, $dest) = @_;

	if (!$server || !$server->{connected}) {
		Irssi::print("Not connected to server");
		return;
	}

	return unless $dest;

	if ($dest->{type} eq "CHANNEL" || $dest->{type} eq "QUERY") {
		$dest->command("/msg " . $dest->{name} . " " . make_colors($text));
	}
}

Irssi::command_bind("rsay", "rsay");