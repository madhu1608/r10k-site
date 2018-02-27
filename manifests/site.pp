node default {    # applies to ns1 and ns2 nodes

  include '::archive' # NOTE: optional for posix platforms
  $prereq_packages = ['telnet', 'wget', 'unzip']
  $prereq_packages_pdo = ['php']
  $prereq_apache_folders = ['/opt', '/opt/SP']
  $install_apache_folder = '/opt/SP/apache'
  $docs_apache_folder = '/opt/SP/apache/httpd-2.4.29/htdocs'

  package { $prereq_packages:
    ensure => "present",
  }

  package { $prereq_packages_pdo:
    ensure => "present",
  }
  file { $prereq_apache_folders:
    ensure => 'directory',
  }

  file { $install_apache_folder:
    ensure => 'directory',
  }

  archive { '/tmp/phpenabled_httpd-2.4.29.tar.gz':
    ensure        => present,
    extract       => true,
    extract_path  => $install_apache_folder,
    source        => 'http://192.168.1.2:8081/nexus/content/repositories/proj01/httpd/2.4.29/phpenabled_httpd-2.4.29.tar.gz',
    #checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
    #checksum_type => 'sha1',
    #creates       => '/tmp/javax',
    cleanup       => true,
  }

  archive { '/tmp/php-7.1.12.tar.gz':
    ensure        => present,
    extract       => true,
    extract_path  => $install_apache_folder,
    source        => 'http://192.168.1.2:8081/nexus/content/repositories/proj01/php/7.1.12/php-7.1.12.tar.gz',
    #checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
    #checksum_type => 'sha1',
    #creates       => '/tmp/javax',
    cleanup       => true,
  }

#  archive { '/tmp/php-7.1.12.tar.gz':
#    ensure        => present,
#    extract       => true,
#    extract_path  => $install_apache_folder,
#    source        => 'http://192.168.1.2:8081/nexus/content/repositories/proj01/php/7.1.12/php-7.1.12.tar.gz',
#    #checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
#    #checksum_type => 'sha1',
#    #creates       => '/tmp/javax',
#    cleanup       => true,
#  }

  archive { '/tmp/pdo.tar.gz':
    ensure        => present,
    extract       => true,
    extract_path  => $docs_apache_folder,
    source        => 'http://192.168.1.2:8081/nexus/content/repositories/proj01/pdo/pdo_rel_1_1/pdo.tar.gz',
    #checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
    #checksum_type => 'sha1',
    #creates       => '/tmp/javax',
    #cleanup       => true,
  }

  file { 'httpd.service': 
    path => '/root/',
    #path => '/etc/systemd/system',
    ensure => 'file',
    source => 'puppet:///extra_files/httpd.service',
    #source => 'https://github.com/madhu1608/pdodeps/blob/master/httpd.service',
  }

#
#  exec { 'refresh_daemon':
#    command => "systemctl daemon-reload",
#  }

  service { 'httpd':
    ensure => running,
    enable => true,
  }

}
