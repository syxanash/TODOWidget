#!/usr/bin/perl

use strict;
use warnings;

use Readonly;
use IPC::System::Simple qw{ capture };

our $VERSION = 0.01;

Readonly my $LIST_LENGTH        => 10;
Readonly my $BOX_WIDTH          => 50;
Readonly my $LIST_NAME          => 'TODO';
Readonly my $SEPARATOR_LINE     => '-';
Readonly my $VERTICAL_SEPARATOR => '|';

my $cmd_output;
my $bin_file = '/usr/local/bin/reminders';

# check if reminder application contains list name

chomp( $cmd_output = capture( $bin_file . ' show-lists' ) );

if ( $cmd_output !~ m{$LIST_NAME}ix ) {
    print $LIST_NAME, ' doesn\'t exist, create a new list in Reminder app called ', $LIST_NAME,
        " or modify this script!\n";
    exit;
}

# execute the reminders tool and store the output in a variable
chomp( $cmd_output = capture( $bin_file . ' show "' . $LIST_NAME . '"' ) );

# print top separator line
print ',', $SEPARATOR_LINE x $BOX_WIDTH, ',', "\n";

if ( $cmd_output eq q{} ) {
    my $msg_header = $VERTICAL_SEPARATOR . ' [!] ' . $LIST_NAME . ' list is empty!';
    print $msg_header, q{ } x ( $BOX_WIDTH - length $msg_header ), q{ },
      $VERTICAL_SEPARATOR, "\n";
}
else {
    my $msg_header = $VERTICAL_SEPARATOR . ' [?] ' . $LIST_NAME . ' list:';
    print $msg_header, q{ } x ( $BOX_WIDTH - length $msg_header ), q{ },
      $VERTICAL_SEPARATOR, "\n";

    my @lines = split /\n/x, $cmd_output;
    my $is_long = 0;

    foreach my $i ( 0 .. $#lines ) {
        if ( $i >= $LIST_LENGTH ) {
            $is_long = 1;
            last;
        }

        # remove the number which represents the number items from the output
        # returned by reminders tool
        if ( $lines[$i] =~ m{^\d+\:\s(.*?)$}ix ) {
            my $msg_item = $VERTICAL_SEPARATOR . ' - ' . $1;

            # when the length is too long add ellipsis
            if ( length($msg_item) > $BOX_WIDTH ) {
                my $ellipsis = '...';

                $msg_item = substr $msg_item, 0,
                  -( ( length($msg_item) - $BOX_WIDTH ) + length($ellipsis) );
                $msg_item .= $ellipsis;
            }

            # print remaining space character until we reach the end of the box
            print $msg_item, q{ } x ( $BOX_WIDTH - length $msg_item ), q{ },
              $VERTICAL_SEPARATOR, "\n";
        }
    }

    # if number of elements in reminder list are too long warn the user
    # of the remaining number of items
    if ($is_long) {
        my $string_msg =
            $VERTICAL_SEPARATOR
          . ' ... ('
          . ( scalar(@lines) - $LIST_LENGTH )
          . ' more)';

        print $string_msg, q{ } x ( $BOX_WIDTH - length $string_msg ), q{ },
          $VERTICAL_SEPARATOR, "\n";
    }
}

# print bottom separator line
print '`', $SEPARATOR_LINE x $BOX_WIDTH, '´', "\n";
