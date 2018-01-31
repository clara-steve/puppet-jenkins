# == Define: jenkins::cli::exec
#
# A defined type for executing custom helper script commands via the Jenkins
# CLI.
#
define jenkins::cli::exec(
  Optional[String] $unless        = undef,
  Variant[String, Array] $command = $title,
) {

  include ::jenkins
  include ::jenkins::cli_helper
  include ::jenkins::cli::reload

  Class['jenkins::cli_helper']
    -> Jenkins::Cli::Exec[$title]
      -> Anchor['jenkins::end']

  # $command may be either a string or an array due to the use of flatten()
  $run = join(
    delete_undef_values(
      flatten([
        $::jenkins::cli_helper::helper_cmd,
        $command,
        $::jenkins::_cli_auth_arg,
      ])
    ),
    ' '
  )

  if $unless {
    $environment_run = [ "HELPER_CMD=eval ${::jenkins::cli_helper::helper_cmd}" ]
  } else {
    $environment_run = undef
  }

  exec { $title:
    provider    => 'shell',
    command     => $run,
    environment => $environment_run,
    unless      => $unless,
    tries       => $::jenkins::cli_tries,
    try_sleep   => $::jenkins::cli_try_sleep,
    notify      => Class['jenkins::cli::reload'],
  }
}
