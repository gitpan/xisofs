#!/usr/local/bin/perl

#----------------------------------------------------------------------
# Edit the lines below to customise
#----------------------------------------------------------------------

# Where the main files are stored
$libDir = "/usr/local/lib/xisofs";

# Where the main binary is sym-linked to
$binDir = "/usr/local/bin";

#----------------------------------------------------------------------
# Nothing below here should need changing
#----------------------------------------------------------------------

($who) = getpwuid($>);

if ($who ne 'root')
{
	print "You need to be 'root' to run this script, not '$who'\n";
	exit 1;
}

print <<EOT;

xisofs v1.2 Installation Script
(c) Copyright 1997 Steve Sherwood

Library Dir    : $libDir
Executable Dir : $binDir

EOT

print "Are you sure you wish to install (y/n) ? ";
$_ = <STDIN>;

unless (/^y/)
{
	print "\nInstallation Aborted\n";
	exit 1;
}

foreach ($libDir,$binDir)
{
	unless (-d $_)
	{
		print "Creating Dir : $_\n";
		system("mkdir -p $_");
	}
}

print "Copying System Files\n";
system("cp -r * $libDir");

print "Sym-Linking\n";
unlink("$binDir/xisofs") if (-e "$binDir/xisofs");
system("ln -s $libDir/xisofs.pl $binDir/xisofs");

print "Updating\n";
open(IO, "+<$libDir/xisofs.pl");
@lines = <IO>;
seek(IO,0,0);
foreach(@lines)
{
	s/xyzzy/$libDir/g;
	print IO $_;
}
close(IO);

print "\nInstallation Complete. type 'xisofs' to start.\n";
exit;
