node {
  stage('puppet master: r10k deploy') {
    sh 'ssh -q -i /home/vagrant/vagrant_parent_key.pem puppet \'sudo /usr/local/bin/r10k deploy environment production -p -c /etc/r10k/r10k.yaml\''
  }
  stage('puppet master: puppet agent -t') {
    sh 'ssh -q -i /home/vagrant/vagrant_parent_key.pem puppet \'sudo /opt/puppetlabs/puppet/bin/puppet agent --test --verbose\''
  }
  stage('tools server: puppet agent -t') {
    sh 'ssh -q -i /home/vagrant/vagrant_parent_key.pem tools \'sudo /opt/puppetlabs/puppet/bin/puppet agent --test --verbose\''
  }
}
