package Rex::Module::Development::Ant;

use Rex -base;
use Data::Dumper;

my %ANT_CONF = ();

Rex::Config->register_set_handler("ant" => sub {
	my ($name, $value) = @_;
	$ANT_CONF{$name} = $value;
});


set ant => cwd => "/";
set ant => ANT_OPTS => "-Xmx512M -Xms64M -Dfile.encoding=UTF-8";
set ant => source => "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar";


task setup => sub {
	pkg "ant", ensure    => "latest";
};

task ant => sub {
	my $command = shift;
	my $base_dir = $ANT_CONF{cwd};

	run "ant " . $command,
		cwd => $base_dir,
		env => {
			ANT_OPTS => $ANT_CONF{ANT_OPTS},
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
