node default {
}

node 'puppet.locdev.com' {
	file { '/etc/puppetlabs/puppet/autosign.conf':
  	ensure => link,
  	target => '/etc/puppetlabs/code/environments/production/autosign.conf',
	}

	file { '/etc/puppetlabs/puppet/fileserver.conf':
  	ensure => link,
  	target => '/etc/puppetlabs/code/environments/production/fileserver.conf',
	}

  file { '/opt/SP':
    ensure => 'directory',
  }

  #file { '/etc/hosts':
  #  ensure => 'file',
  #  source => 'puppet:///extra_files/hosts',
  #}
}

node /^agent\d+\.locdev\.com$/ {
  file { '/opt/SP':
    ensure => 'directory',
  }

  #file { '/etc/hosts':
  #  ensure => 'file',
  #  source => 'puppet:///extra_files/hosts',
  #}
}

node 'tools.locdev.com' {
  file { '/opt/SP':
    ensure => 'directory',
  }

  #file { '/etc/hosts':
  #  ensure => 'file',
  #  source => 'puppet:///extra_files/hosts',
  #}
}

