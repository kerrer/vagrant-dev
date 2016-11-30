# default server role
class roles::hadoop {
    include profiles::common
    include profiles::hadoop::install
    

  Class['profiles::common']  -> Class['profiles::hadoop::install']
}
