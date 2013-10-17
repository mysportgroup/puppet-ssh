class ssh::client ($package_version = 'present') inherits ssh::params {
  package { 'openssh-client': ensure => $package_version, }
}
