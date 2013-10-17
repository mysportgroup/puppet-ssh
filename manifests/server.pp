class ssh::server (
  $port              = '22',
  $allowed_users     = [],
  $x11_forwarding    = 'yes',
  $password_authentication      = 'yes',
  $subsystem_sftp    = '/usr/lib/openssh/sftp-server',
  $permit_root_login = 'yes',
  $host_keys         = $ssh::params::host_keys,
  $authorized_keys_command      = undef,
  $authorized_keys_command_user = undef,
  $allowed_groups    = [],
  $package_version   = 'present') inherits ssh::params {
  package { 'openssh-server': ensure => $package_version, }

  file { '/etc/ssh/sshd_config':
    content => template('ssh/sshd_config.erb'),
    before => Package['openssh-server'],
    owner   => root,
    group   => root,
    mode    => '0644'
  }

  service { 'ssh':
    ensure    => running,
    name      => $ssh::params::service_name,
    enable    => true,
    hasstatus => true,
    subscribe => [Package['openssh-server'], File['/etc/ssh/sshd_config']],
    require   => File['/etc/ssh/sshd_config'],
  }

  if $permit_root_login == 'true' {
    notify { "You permit root login: use it with caution.": }
  }
}
