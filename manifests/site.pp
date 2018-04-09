node default {

	file { '/root/linkfile':
  	ensure => link,
  	target => '/root/mainfile',
	}

  #file { '/etc/hosts':
  #  ensure => 'file',
  #  source => 'puppet:///extra_files/hosts',
  #}
}
