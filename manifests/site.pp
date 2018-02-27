node default { 

  include '::archive'
  $prereq_packages = ['telnet', 'wget', 'unzip']
  $prereq_apache_folders = ['/opt', '/opt/SP']
  $install_apache_folder = ['/opt/SP/apache', '/opt/SP/apache/httpd-2.4.29']
  $docs_apache_folder = '/opt/SP/apache/httpd-2.4.29/htdocs'
  $httpd_service_abspath = '/etc/systemd/system/httpd.service'

  package { $prereq_packages:
    ensure => "present",
  }

  file { $prereq_apache_folders:
    ensure => 'directory',
  }

  file { $install_apache_folder:
    ensure => 'directory',
    require => File[$prereq_apache_folders],
  }

  archive { '/tmp/phpenabled_httpd-2.4.29.tar.gz':
    ensure        => present,
    extract       => true,
    extract_path  => $install_apache_folder,
    source        => 'http://192.168.43.9:8081/nexus/content/repositories/proj01/httpd/2.4.29/phpenabled_httpd-2.4.29.tar.gz',
    cleanup       => true,
    require => File[$install_apache_folder],
  }

  file { $httpd_service_abspath: 
    ensure => 'file',
    source => 'puppet:///extra_files/httpd.service',
    require => Archive['/tmp/phpenabled_httpd-2.4.29.tar.gz'],
  }

  archive { '/tmp/php-7.1.12.tar.gz':
    ensure        => present,
    extract       => true,
    extract_path  => $install_apache_folder,
    source        => 'http://192.168.43.9:8081/nexus/content/repositories/proj01/php/7.1.12/php-7.1.12.tar.gz',
    cleanup       => true,
  }

  archive { '/tmp/pdo.tar.gz':
    ensure        => present,
    extract       => true,
    extract_path  => $docs_apache_folder,
    source        => 'http://192.168.43.9:8081/nexus/content/repositories/proj01/pdo/pdo_rel_1_1/pdo.tar.gz',
  }

  file { '/opt/SP/apache/httpd-2.4.29/conf/httpd.conf':
    ensure => 'file',
    source => 'puppet:///extra_files/httpd.conf',
    notify  => Service['httpd'],
    require => Archive['/tmp/php-7.1.12.tar.gz', '/tmp/pdo.tar.gz'], File[$httpd_service_abspath]
  }

  service { "httpd":
    ensure  => running,
    hasrestart => true,
    start   => "/opt/SP/apache/httpd-2.4.29/bin/apachectl -k start -f /opt/SP/apache/httpd-2.4.29/conf/httpd.conf",
    stop    => "/opt/SP/apache/httpd-2.4.29/bin/apachectl -k stop -f /opt/SP/apache/httpd-2.4.29/conf/httpd.conf",
    restart => "/opt/SP/apache/httpd-2.4.29/bin/apachectl -k graceful -f /opt/SP/apache/httpd-2.4.29/conf/httpd.conf",
    pattern => "/opt/SP/apache/httpd-2.4.29/bin/httpd",
  }

}
