node default {
  file { '/etc/hosts':
    ensure => 'file',
    source => 'puppet:///extra_files/hosts',
  }
}
