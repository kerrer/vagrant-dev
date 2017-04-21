# Config common to all nodes
class profiles::mysql {
   $override_options = {
    'section' => {
      
     }
   }

  class { '::mysql::server':
    root_password           => 'mmmm',
    remove_default_accounts => true,
    override_options        => $override_options
  }

}
