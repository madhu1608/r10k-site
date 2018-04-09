node default {

	file { ' /etc/puppetlabs/puppet/fileserver.conf':
  	ensure => link,
  	target => '/etc/puppetlabs/code/environments/production/fileserver.conf',
	}

  #file { '/etc/hosts':
  #  ensure => 'file',
  #  source => 'puppet:///extra_files/hosts',
  #}
}


