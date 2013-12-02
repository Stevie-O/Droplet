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

sub button{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	my $phrase = int(rand(3));
	
	if($text =~ m/^!button/i){
		$server->command("CTCP $target ACTION presses button");
		if($phrase == 0){
			$server->command("CTCP $target ACTION eats muffin");
		}
		elsif($phrase == 1){
			$server->command("CTCP $target ACTION explodes");
		}
		elsif($phrase == 2){
			$server->command("CTCP $target ACTION dances ~*w*~");
		}
	}
	
	if($text =~ m/^!butten/i){
		$server->command("CTCP $target ACTION corrects spelling");
		$server->command("CTCP $target ACTION presses button");
		if($phrase == 0){
			$server->command("CTCP $target ACTION eats muffin");
		}
		elsif($phrase == 1){
			$server->command("CTCP $target ACTION explodes");
		}
		elsif($phrase == 2){
			$server->command("CTCP $target ACTION dances ~*w*~");
		}
	}
	$phrase = int(rand(3));
	$lastnick = $nick;
}

sub identify{
	my($server, $data, $nick, $mask, $target) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	my $version = "4.0";
	
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
	my $phrase = int(rand(3));
	
	if ($text =~ m/!order/i) {
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
			if ($phrase == 0){
				$server->command("CTCP $target ACTION pokes $nick");
			}
			elsif($phrase == 1){
				$server->command("CTCP $target ACTION smacks $nick");
			}
			elsif($phrase == 2){
				$server->command("CTCP $target ACTION hugs $nick");
			}
			$phrase = int(rand(3));
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
	
	if ($text =~ m/^!suggest/i) {
		if ($phrase == 0){
			$server->command("MSG $target Sleep.");
		}
		elsif($phrase == 1) {
			$server->command("MSG $target Play a video game.");
		}
		elsif($phrase == 2) {
			$server->command("MSG $target I dont know, do whatever you want man *3*~");
		}
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

Irssi::signal_add('event privmsg', 'moberry');