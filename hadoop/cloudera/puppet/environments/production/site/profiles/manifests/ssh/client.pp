# Sets ssh config for all instances
class profiles::ssh::client {
    class { 'ssh::server':
   	storeconfigs_enabled => false,
   	options => {
		'PasswordAuthentication' => 'no',
        	'PubkeyAuthentication'   => 'yes',
      		'PermitRootLogin'        => 'yes'
   	},
   }
}
