#!/usr/bin/perl

use strict;
use warnings;

use IPC::System::Simple qw{ capture };

my $cmd_output;
my $bin_file = '/usr/local/bin/reminders';
my $max_list = 10;
my $max_width = 45;

chomp($cmd_output = capture($bin_file . " show TODO"));

# print top separator line
print ',', '-' x $max_width, ',', "\n";

if ($cmd_output eq '') {
    my $msg_header = '| [!] TODO list is empty!';
    print $msg_header, ' ' x ($max_width - length($msg_header)), ' |', "\n";
} else {
    my $msg_header = '| [?] TODO list:';
    print $msg_header, ' ' x ($max_width - length($msg_header)), ' |', "\n";
    
    my @lines = split /\n/, $cmd_output;
    my $is_long = 0;

    foreach my $i (0..$#lines) {
        if ($i >= $max_list) {
            $is_long = 1;
            last;
        }

        # remove the number which represents the number items from the output
        # returned by reminders tool
        if ($lines[$i] =~ m{^\d+\s(.*?)$}i) {
            my $msg_item = '| - ' . $1;

            # when the length is too long add ellipsis
            if (length($msg_item) > $max_width) {
                $msg_item = substr $msg_item, 0, -((length($msg_item) - $max_width) + 3);
                $msg_item .= '...'
            }

            # print remaining space character until we reach the end of the box
            print $msg_item, ' ' x ($max_width - length($msg_item)), ' |', "\n";
        }
    }

    # if number of elements in reminder list are too long warn the user
    # of the remaining number of items
    if ($is_long) {
        my $string_msg = '| ... (' . (scalar(@lines) - $max_list) . ' more)';

        print $string_msg, ' ' x ($max_width - length($string_msg)), '|', "\n";
    }
}

# print bottom separator line
print '`', '-' x $max_width, '`', "\n";