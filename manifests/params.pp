class papertrail::params {
  $ensure                 = 'installed'
  $manage_rsyslog         = true
  $remote_syslog_version  = "v0.13"
  $remote_syslog_source   = "https://github.com/papertrail/remote_syslog2/releases/download/$remote_syslog_version/remote_syslog_linux_amd64.tar.gz"
  $dependencies           = [ 'curl' ]

  case $::osfamily {
    'Debian': {
      $rsyslog_confd    = '/etc/rsyslog.d'
      $rsyslog_service  = 'rsyslog'
    }
    'RedHat': {
      $rsyslog_confd    = '/etc/rsyslog.d'
      $rsyslog_service  = 'rsyslog'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }
}