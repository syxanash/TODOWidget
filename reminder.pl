#!/usr/bin/perl

use strict;
use warnings;

use IPC::System::Simple qw{ capture };

my $todo_result;
my $bin_file = '/usr/local/bin/reminders';
my $max_list = 10;
my $max_width = 50;

chomp($todo_result = capture($bin_file . " show TODO"));

print ',', '-' x $max_width, ',', "\n";

if ($todo_result eq '') {
    my $msg_header = '| [!] TODO list is empty!';
    print $msg_header, ' ' x ($max_width - length($msg_header)), ' |', "\n";
} else {
    my $msg_header = '| [?] TODO list:';
    print $msg_header, ' ' x ($max_width - length($msg_header)), ' |', "\n";
    
    my @lines = split /\n/, $todo_result;
    my $is_long = 0;

    foreach my $i (0..$#lines) {
        if ($i >= $max_list) {
            $is_long = 1;
            last;
        }

        if ($lines[$i] =~ m{^\d+\s(.*?)$}i) {
            my $msg_item = '| - ' . $1;

            if (length($msg_item) > $max_width) {
                $msg_item = substr $msg_item, 0, -((length($msg_item) - $max_width) + 7);
                $msg_item .= '(...)'
            }

            print $msg_item, ' ' x ($max_width - length($msg_item)), ' |', "\n";
        }
    }

    if ($is_long) {
        my $string_msg = '| ... (' . (scalar(@lines) - $max_list) . ' more)';

        print $string_msg, ' ' x ($max_width - length($string_msg)), '|', "\n";
    }
}

print '`', '-' x $max_width, '`', "\n";