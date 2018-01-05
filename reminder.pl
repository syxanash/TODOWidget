#!/usr/bin/perl

use strict;
use warnings;

use Readonly;
use IPC::System::Simple qw{ capture };

Readonly my $LIST_LENGTH => 10;
Readonly my $BOX_WIDTH => 50;

my $cmd_output;
my $bin_file = '/usr/local/bin/reminders';

chomp($cmd_output = capture($bin_file . ' show TODO'));

# print top separator line
print ',', '-' x $BOX_WIDTH, ',', "\n";

if ($cmd_output eq q{}) {
    my $msg_header = '| [!] TODO list is empty!';
    print $msg_header, q{ } x ($BOX_WIDTH - length $msg_header), ' |', "\n";
} else {
    my $msg_header = '| [?] TODO list:';
    print $msg_header, q{ } x ($BOX_WIDTH - length $msg_header), ' |', "\n";

    my @lines = split /\n/x, $cmd_output;
    my $is_long = 0;

    foreach my $i (0..$#lines) {
        if ($i >= $LIST_LENGTH) {
            $is_long = 1;
            last;
        }

        # remove the number which represents the number items from the output
        # returned by reminders tool
        if ($lines[$i] =~ m{^\d+\s(.*?)$}ix) {
            my $msg_item = '| - ' . $1;

            # when the length is too long add ellipsis
            if (length($msg_item) > $BOX_WIDTH) {
                my $ellipsis = '...';

                $msg_item = substr $msg_item, 0, -((length $msg_item - $BOX_WIDTH) + length $ellipsis);
                $msg_item .= $ellipsis;
            }

            # print remaining space character until we reach the end of the box
            print $msg_item, q{ } x ($BOX_WIDTH - length $msg_item), ' |', "\n";
        }
    }

    # if number of elements in reminder list are too long warn the user
    # of the remaining number of items
    if ($is_long) {
        my $string_msg = '| ... (' . (scalar(@lines) - $LIST_LENGTH) . ' more)';

        print $string_msg, q{ } x ($BOX_WIDTH - length $string_msg), ' |', "\n";
    }
}

# print bottom separator line
print '`', '-' x $BOX_WIDTH, '`', "\n";