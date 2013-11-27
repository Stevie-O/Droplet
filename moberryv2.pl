use strict;
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = "1";
%IRSSI = (
	authors		=> 'Mosai',
	contact 		=> 'mosai57@gmail.com',
	name		=> 'Moberry',
	description 	=> 'Sends a random phrase to an irc channel when triggered.',
	license		=> 'All Rights Reserved',
	changed 		=> '2013-11-25 21:28 (UTC-8:00)',
);

my $lastnick = "nobody";
my $8ball = int(rand(16));
# colors list
#  0 == white
#  4 == light red
#  8 == yellow
#  9 == light green
# 11 == light cyan
# 12 == light blue
# 13 == light magenta
my @colors = ('0', '4', '8', '9', '11', '12', '13');

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

sub moberry {
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	my $phrase = int(rand(3));

	if ($text =~ m/^!whee/i) {
		$server->command("MSG $target Wheeeee \\*w*/");
		$lastnick = $nick;
	}
	elsif ($text =~ m/!order/i) {
		if($phrase == 1){
			$server->command("MSG $target o7");
		}
		elsif($phrase == 2){
			$server->command("MSG $target No.");
		}
		else{
			$server->command("MSG $target Maybe later.");
		}
		$phrase = int(rand(3));
		$lastnick = $nick; 
	}	
	elsif ($text =~ m/^!MAL/i) {
		$server->command("MSG $target http://myanimelist.net/animelist/Mosai");
		$lastnick = $nick;
	}
	elsif ($text =~ m/^!last/i) {
		$server->command("MSG $target My last command was issued by $lastnick");
	}
	elsif ($text =~ m/^!rbw/i) {
		$server->command("CTCP $target ACTION RAINBOWS!");
	}
	elsif ($text =~ m/^!suggest/i) {
		$server->command("MSG $target Sleep.");
		$lastnick = $nick;
	}
}
	
Irssi::signal_add('event privmsg', 'moberry');
Irssi::command_bind("rsay", "rsay");