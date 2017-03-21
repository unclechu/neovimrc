#!/usr/bin/env perl
use v5.10; use strict; use warnings; use autodie qw(:all);
die 'unexpected arguments count' if scalar(@ARGV) != 1;
use Env qw<PWD HOME>;
use IPC::System::Simple qw<runx>;

if ($ARGV[0] eq 'create-symlink') {

  chdir "$HOME/.config/";
  runx 'ln', '-s', '--', "$PWD/", 'nvim';

} elsif ($ARGV[0] eq 'clean') {

  chdir "$HOME/.config/";
  unlink 'nvim' if -l 'nvim';

} else {
  die "unknown argument: '$ARGV[0]'";
}

# vim: et ts=2 sts=2 sw=2 cc=81 tw=80 :
