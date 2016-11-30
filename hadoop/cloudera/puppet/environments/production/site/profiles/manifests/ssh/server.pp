# Sets ssh config for all instances
class profiles::ssh::server {   
    class { 'ssh::client':
      storeconfigs_enabled => false,
      options => {
        'Host *' => {
          'SendEnv'  => 'LANG LC_*',
          'HashKnownHosts' => 'yes',
          'GSSAPIAuthentication' => 'yes',
          'GSSAPIDelegateCredentials' => 'no',
          'StrictHostKeyChecking' => 'no',
        },
      },
    }
}
