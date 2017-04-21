class { 'nodejs':
  repo_url_suffix => 'node_5.x',
}
->
package {['less','less-plugin-clean-css']:
  ensure   => 'present',
  provider => 'npm',
}
