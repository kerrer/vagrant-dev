#!/bin/bash -e

# test suite for oh-my-vagrant patches...
echo running test.sh

# ensure there is no trailing whitespace or other whitespace errors
git diff-tree --check $(git hash-object -t tree /dev/null) HEAD

# ensure entries to authors file are sorted
start=$(($(grep -n '^[[:space:]]*$' AUTHORS | awk -F ':' '{print $1}' | head -1) + 1))
diff <(tail -n +$start AUTHORS | sort) <(tail -n +$start AUTHORS)

# ensure we pass basic ruby-lint checks
if which ruby-lint &>/dev/null; then	# don't fail if not installed
	# TODO i would like to add on:
	# -a undefined_methods -a undefined_variables
	# but valid vagrant causes these to break at the moment.
	# if this is fixed remove all the -a arguments for default use!
	ruby-lint -a argument_amount -a loop_keywords -a pedantics -a shadowing_variables -a unused_variables -a useless_equality_checks vagrant/Vagrantfile
fi
