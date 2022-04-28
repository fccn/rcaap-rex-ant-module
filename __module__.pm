package Rex::Module::Development::Ant;

use Rex -base;
use Data::Dumper;

our $__ant_opts = '-Xmx512M -Xms64M -Dfile.encoding=UTF-8';
our $__ant_cwd = '/';

our $__package_name = {
	debian => "ant",
	ubuntu => "ant",
	centos => "ant",
	mageia => "ant",
};

our $__program_name = {
	debian => "ant",
	ubuntu => "ant",
	centos => "ant",
	mageia => "ant",
};

task setup => sub {
	pkg param_lookup ("package_name", case ( lc(operating_system()), $__package_name )),
		ensure    => "latest";
};


sub ant {
	my $command = shift;

	my $base_dir = param_lookup ("cwd", $__ant_cwd );

	Rex::Logger::info("Running ant $command (this action may take some time)");
	run param_lookup ("package_name", case ( lc(operating_system()), $__program_name ))." $command",
		cwd => $base_dir,
		continuous_read => sub {
			#output to log
			Rex::Logger::info(@_);
		},
		env => {
			ANT_OPTS => param_lookup ("opts", $__ant_opts ),
		};
	die("Error running ant command.") unless ($? == 0);
};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Rex::Module::Development::Ant/;

 task yourtask => sub {
    Rex::Module::Development::Ant::ant("deploy");
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
