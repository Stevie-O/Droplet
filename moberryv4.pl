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

sub button;
sub butten;
sub identify;
sub last;
sub order;
sub poke;
sub smack;
sub suggest;
sub whee;
sub help;

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

my %dispatch = (
	'button' => { func => \&button, args => '', desc => 'Mystery button' },
	'butten' => { func => \&butten, hidden => 1 },
	'identify' => { func => \&identify, args => '', desc => 'Display version and supported commands' },
	'last' => { func => \&last, nolast => 1, args => '', help => 'Show the last user to perform a command (other than !last)' },
	'order' => { func => \&order, args => '', help => '' },
	'poke' => { func => \&poke, args => '', help => '' },
	'suggest' => { func => \&suggest, args => '', help => 'Suggest a course of action' },
	'whee' => { func => \&whee, args => '', help => '' },
	'help' => { func => \&help, args => ' <command>', help => 'You\'ll never figure out what this command does!' },
	'lastpi' => { func => sub{}, args => '', help => 'Computes and displays the last digit of pi (asynchronous)' },
	'workdammit' => { func => \&workdammit, args => '', help => 'Perform ancient invocation ritual' },
	);
	
sub dispatch {
	my($server, $data, $nick, $mask) = @_;
	my($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	my %info;
	return unless $target =~ /^#/; # channels only
	$info{directed} = 1 if $text =~ s/^\Q$server->{nick}\E[:,]\s*//;
	if ($text =~ /^!(\w+)/) {
		my $command = $dispatch{$1};
		$info{keyword} = $1;
		$info{command} = $command;
		if ($command) {
			$command->{func}->(\%info, $server, $data, $nick, $mask, $target, $text);
			$lastnick = $nick unless $command->{nolast};
		}
	}
}

sub help {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;
	my (undef, $helpfor) = split ' ', $text;
	$helpfor ||= 'help';
	$helpfor =~ s/^!//; # behave intelligently if they do !help !command
	my $command = $dispatch{$helpfor};
	unless ($command) {
		$server->say($target, "I don't have a !$helpfor command.") if $info->{directed};
		return;
	}
	if ($command->{hidden}) {
		$server->say($target, "Who told you I had a !$helpfor command?");
		return;
	}
	my $help = $command->{help} || 'Do... something.';
	$server->say($target, "Usage: !$helpfor$command->{args}: $help");
}

sub workdammit {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;
	$server->say($target, "No.");
}

sub button {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;
	$server->me($target, "presses button");
	my $response = $button[int(rand(scalar(@button)))];
	$server->me($target, $response);
}

sub butten {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;
	$server->me($target, "corrects spelling");
	goto &button;
}

sub identify {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;
	my $version = "4.2";
	
	my @commands = sort grep { !$dispatch{$_}{hidden} } keys %dispatch;
	$server->say($target, "I am $server->{nick}, a female graham cracker IRC Bot. Version $version. Commands (activate with !command): ", join(' ', @commands));
}

sub last {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;
	
	$server->say($target, "My last command was issued by $lastnick");
}

sub order {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;

	my $response = $order[int(rand(scalar(@order)))];
	$server->say($target,  $response);
}

sub poke {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;

	my $response;
	if($nick =~ /^bradthe/i){
		$response = 'hugs';
	} else {
		$response = $poke[int(rand(scalar(@poke)))];
	}
	$server->me($target, "$response $nick");
}

sub smack {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;

	$server->me($target, "sobs");
}

sub suggest {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;

	my $response = $suggest[int(rand(scalar(@suggest)))];
	$server->say($target,  $response);
}

sub whee {
	my ($info, $server, $data, $nick, $mask, $target, $text) = @_;

	$server->say($target, "Wheeeee \\*w*/");
}

Irssi::signal_add('event privmsg', \&dispatch);

# add some nifty custom commands to make this stuff more legible
{ package Irssi::Server;
  sub me { $_[0]->command("CTCP $_[1] ACTION " . join('', @_[2..$#_])); }
  sub say { $_[0]->command("MSG $_[1] " . join('', @_[2..$#_])); }
}

