define papertrail::client (
  $server           = undef,
  $port             = undef,
  $pattern          = '*.*',
  $rsyslog_confd    = $::papertrail::params::rsyslog_confd,
  $rsyslog_service  = $::papertrail::params::rsyslog_service
) {
  include ::papertrail::params

  file { "$rsyslog_confd/50-client.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template('papertrail/rsyslog.conf.erb'),
    notify  => Service[$rsyslog_service]
  }
}