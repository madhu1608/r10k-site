node default {
}

$GITSERVER_HOME="http://gitbucket:8082/git/madhu1608"

node 'puppet.locdev.com', 'puppet.locdo.com' {
  
  file { '/etc/hosts':
    ensure => present,
    source => '/vagrant_data/hosts',
  } ->
  
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

node 'tools.locdev.com' 'tools.locdo.com' {

  file { '/etc/hosts':
    ensure => present,
    source => '/vagrant_data/hosts',
  } ->
  
  file { '/opt/SP':
    ensure => 'directory',
  }

  include java
  #include ntp
  #include jenkins2
  #class java ($GITSERVER_HOME) {}
  

}

