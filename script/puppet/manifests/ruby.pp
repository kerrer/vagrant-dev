class { 'rbenv': }
rbenv::plugin { ['rbenv/rbenv-vars', 'rbenv/ruby-build']: latest => true }
rbenv::build { '2.3.0': global => true, env=>['RUBY_BUILD_CACHE_PATH=/job/ruby','RUBY_BUILD_BUILD_PATH=/job/ruby']}
rbenv::gem { 'fluentd': ruby_version => '2.3.0', skip_docs=>true }
