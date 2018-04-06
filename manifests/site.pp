node default {

	include ::archive

	$nexus_repo_base = 'http://nexus:8081/repository/locdev-phpproj'
	$prereq_apache_folders = ['/opt', '/opt/SP']
  $install_apache_folder = '/opt/SP/apache'
  $minimal_packages = ['telnet', 'wget', 'bzip2', 'curl']

  package { $minimal_packages :
    ensure => 'present',
  }

  file { '/etc/hosts':
    ensure => 'file',
    source => 'puppet:///extra_files/hosts',
  }

  file { $prereq_apache_folders:
    ensure => 'directory',
  }

  file { $install_apache_folder:
    ensure => 'directory',
    require => File[$prereq_apache_folders],
  }


	archive { '/tmp/httpd/phpenabled_httpd-2.4.29.tar.gz':
		source       => "${nexus_repo_base}/httpd/2.4.29/phpenabled_httpd-2.4.29.tar.gz",
		extract      => true,
		extract_path => '/opt/SP/apache',
		creates      => '/opt/SP/apache/httpd-2.4.29',
		cleanup      => false,
		require => File[$install_apache_folder],
	}

	archive { '/tmp/php/php-7.1.12.tar.gz':
		source       => "${nexus_repo_base}/php/7.1.12/php-7.1.12.tar.gz",
		extract      => true,
		extract_path => '/opt/SP/apache',
		creates      => '/opt/SP/apache/php',
		cleanup      => false,
		require => Archive['/tmp/httpd/phpenabled_httpd-2.4.29.tar.gz'],
	}


	archive { '/tmp/httpd/pdo_rel_1_1.tar.gz':
		source       => "${nexus_repo_base}/pdo/rel_1_1/pdo_rel_1_1.tar.gz",
		extract      => true,
		extract_path => '/opt/SP/apache/httpd-2.4.29/htdocs',
		creates      => '/opt/SP/apache/httpd-2.4.29/htdocs/pdo',
		cleanup      => false,
		require => Archive['/tmp/php/php-7.1.12.tar.gz'],
	}


  file { '/opt/SP/apache/php/lib/php.ini':
    ensure => 'file',
    source => 'puppet:///extra_files/php.ini-sample',
    #notify  => Service['httpd'],
    require => Archive['/tmp/httpd/pdo_rel_1_1.tar.gz'],
  }

  file { '/opt/SP/apache/httpd-2.4.29/htdocs/index.php':
    ensure => 'file',
    source => 'puppet:///extra_files/index.php',
    #notify  => Service['httpd'],
    require => File['/opt/SP/apache/php/lib/php.ini'],
  }

  file { '/opt/SP/apache/httpd-2.4.29/conf/httpd.conf':
    ensure => 'file',
    source => 'puppet:///extra_files/httpd.conf',
    notify  => Service['httpd'],
    require => File['/opt/SP/apache/httpd-2.4.29/htdocs/index.php'],
  }

  service { "httpd":
    ensure  => running,
    hasrestart => true,
    start   => "/opt/SP/apache/httpd-2.4.29/bin/apachectl -k start -f /opt/SP/apache/httpd-2.4.29/conf/httpd.conf",
    stop    => "/opt/SP/apache/httpd-2.4.29/bin/apachectl -k stop -f /opt/SP/apache/httpd-2.4.29/conf/httpd.conf",
    restart => "/opt/SP/apache/httpd-2.4.29/bin/apachectl -k restart -f /opt/SP/apache/httpd-2.4.29/conf/httpd.conf",
    pattern => "/opt/SP/apache/httpd-2.4.29/bin/httpd",
  }

  class { '::mcollective':
		middleware       => true,
		#client            => true,
    middleware_hosts => [ 'puppet.locdev.com' ],
  }


}
