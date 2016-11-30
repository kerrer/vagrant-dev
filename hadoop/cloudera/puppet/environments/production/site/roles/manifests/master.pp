# default server role
class roles::master {
    include profiles::common
    include profiles::ssh::all
    include profiles::cloudera::master
}
