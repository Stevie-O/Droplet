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
	changed 	=> '2013-11-25 21:28 (UTC-8:00)',
);

my $lastnick = "nobody";

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
	elsif ($text =~ m/!MAL/i) {
		$server->command("MSG $target http://myanimelist.net/animelist/Mosai");
		$lastnick = $nick;
	}
	elsif ($text =~ m/!last/i) {
		$server->command("MSG $target My last command was issued by $lastnick");
	}
}


Irssi::signal_add('event privmsg', 'moberry');
