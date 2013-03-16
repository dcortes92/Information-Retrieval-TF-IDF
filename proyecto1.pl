#!/usr/bin/perl

    use strict;
    use warnings;

    my $dir = "man.es";

    opendir(DIR, $dir) or die $!;

    while (my $file = readdir(DIR)) {

        # We only want files
        next unless (-f "$dir/$file");

        # Use a regular expression to find files ending in .txt
        next unless ($file =~ m/\.txt$/);

        print "$file\n";
    }

    closedir(DIR);
    exit 0;
