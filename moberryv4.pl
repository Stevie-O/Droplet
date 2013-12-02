use strict;
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = "1";
%IRSSI = (
	authors		=> 'Mosai',
	contact 	=> 'mosai57@gmail.com',
	name		=> 'Moberry',
	description 	=> 'Sends a random phrase to an irc channel when triggered.',
	license		=> 'All Rights Reserved',
	changed 	=> '2013-12-2 03:46 (UTC-8:00)',
);

my $lastnick = "nobody";

my @button = (
		"eats muffin",
		"explodes",
		"dances ~*w*~",
);

my @order = (
	"o7",
	"Maybe later.",
	"No."
);

my @poke = (
	"pokes",
	"smacks",
	"hugs",
	"bazookas",
);

my @suggest = (
	"Sleep.",
	"Play a video game.",
	"Read a book.",
	"Go do that thing you've been putting off for months.",
	"Give mosai all your mone-wait no.",
	"Iunno, do whatever you want *w*~",
);

sub button{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	
	if($text =~ m/^!button/i){
		$server->command("CTCP $target ACTION presses button");
		my $response = $button[int(rand(scalar(@button)))];
		$server->command("CTCP $target ACTION $response");
	}
	
	if($text =~ m/^!butten/i){
		$server->command("CTCP $target ACTION corrects spelling");
		$server->command("CTCP $target ACTION presses button");
		my $response = $button[int(rand(scalar(@button)))];
		server->command("CTCP $target ACTION $response");
	}
	$lastnick = $nick;
}

sub identify{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	my $version = "4.2";
	
	if ($text =~ m/^!identify/i) {
		$server->command("MSG $target I am Moberry, a female graham cracker IRC Bot. Version $version");
		$server->command("MSG $target My commands are as follows:");
		$server->command("MSG $target !anime, !button, !g, !identify, !last, !order, !poke, !smack, !suggest, !whee");
	}
	$lastnick = $nick;
}
sub last{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	
	if ($text =~ m/^!last/i) {
		$server->command("MSG $target My last command was issued by $lastnick");
	}
	$lastnick = $nick;
}
sub order{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	
	if ($text =~ m/!order/i) {
		my $response = $order[int(rand(scalar(@order)))];
		$server->command("MSG $target $response");
	}
	$lastnick = $nick;
}
sub poke{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	
	if($text =~ m/^!poke/i){
		if($nick eq "bradthebugguy"){
			$server->command("CTCP $target ACTION hugs $nick");
		}
		else{
			my $response = $poke[int(rand(scalar(@poke)))];
			$server->command("CTCP $target ACTION $response $nick");
		}
	} 
	$lastnick = $nick;
}

sub smack{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	
	if($text =~ m/^!smack/i){
		$server->command("CTCP $target ACTION sobs");
		$lastnick = $nick;
	}
}
sub suggest{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	my $phrase = int(rand(3));
	
	if ($text =~ m/^!suggest/i) {
		my $response = $suggest[int(rand(scalar(@suggest)))];
		$server->command("MSG $target $response");
		$lastnick = $nick;
	}
}
sub whee{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	
	if ($text =~ m/^!whee/i) {
		$server->command("MSG $target Wheeeee \\*w*/");
		$lastnick = $nick;
	}
}

Irssi::signal_add('event privmsg', 'button');
Irssi::signal_add('event privmsg', 'identify');
Irssi::signal_add('event privmsg', 'last');
Irssi::signal_add('event privmsg', 'order');
Irssi::signal_add('event privmsg', 'poke');
Irssi::signal_add('event privmsg', 'smack');
Irssi::signal_add('event privmsg', 'suggest');
Irssi::signal_add('event privmsg', 'whee');