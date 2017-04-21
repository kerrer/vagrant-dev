# Sets ssh config for all instances
class profiles::ssh::all {   
    include profiles::ssh::keys
     include profiles::ssh::server
     include profiles::ssh::client
}
