class papertrail (
  $ensure           = $::papertrail::params::ensure,
  $manage_rsyslog   = $::papertrail::params::manage_rsyslog,
  $server           = undef,
  $port             = undef,
  $pattern          = '*.*',
  $log_files        = [],
  $exclude_patterns = []
) inherits ::papertrail::params {

  if $manage_rsyslog {
    ::papertrail::client { 'papertrail':
      server  => $server,
      port    => $port,
      pattern => $pattern
    }
  }

  package { $dependencies: ensure => installed }

  exec { 'remote_syslog':
    command => "wget -qO- $remote_syslog_source |tar xz --strip=1 -C /usr/local/bin/ remote_syslog/remote_syslog",
    path    => "/bin/:/usr/bin/:/usr/local/bin/",
    creates => "/usr/local/bin/remote_syslog",
    user    => 'root'
  }

  file { '/usr/local/bin/remote_syslog':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    require => Exec['remote_syslog']
  }

  file { '/etc/init.d/remote_syslog':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    source  => 'puppet:///modules/papertrail/remote_syslog'
  }

  service { 'remote_syslog': ensure => 'running' }

  file { '/etc/log_files.yml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template('papertrail/log_files.yml.erb'),
    notify  => Service['remote_syslog']
  }
}