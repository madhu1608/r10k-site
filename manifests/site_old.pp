node 'pmater.l.com' {

   include '::archive'

# aa

   archive { '/tmp/jta-1.1.jar':
     ensure        => present,
     extract       => true,
     extract_path  => '/tmp',
     source        => 'http://central.maven.org/maven2/javax/transaction/jta/1.1/jta-1.1.jar',
     checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
     checksum_type => 'sha1',
     creates       => '/tmp/javax',
     cleanup       => true,
     user          => 'vagrant',
     group         => 'vagrant',
   }
}

node 'capi.l.com', 'agent01.l.com' {
  #file {'/tmp/root/beriberi2':
  #  ensure  => present,
  #  mode    => '0644',
  #  content => "Here is my Public IP Address: ${ipaddress_eth0}.\n",
  #}

   #include '::archive'
   #je;;p
   $prereq_packages = ['telnet', 'wget', 'unzip']
   $prereq_apache_folders = ['/opt', '/opt/SP']
   $install_apache_folder = '/opt/SP/apache'


   package { $prereq_packages:
       ensure => "present",
   }

   file { $prereq_apache_folders:
       ensure => 'directory',
   }

   file { $install_apache_folder:
       ensure => 'directory',
   }

        class { '::archive':
                archive { '/home/vargrant/help':
                        source        => 'http://192.168.1.4:8081/nexus/content/repositories/madhu/pdo.tar.gz',
                        extract       => true,
                        extract_path  => $homedir,
                        creates       => "${homedir}/help", #directory inside tgz
                }
        }
}

