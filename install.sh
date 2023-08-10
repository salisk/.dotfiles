#!/bin/bash

# show script directory
current_dir=$(dirname "$BASH_SOURCE")
echo "Running in $current_dir"

# based on the os
echo $OSTYPE
if [[ "$OSTYPE" == "darwin"* ]]; then
	# Mac OSX
	echo "Running on Mac OSX..."
	if ! which ansible >/dev/null; then
		echo "Installing ansible..."
		sudo pip3 install ansible
	fi

	echo "Running ansible..."
	PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}" ansible-playbook -K $current_dir/ansible/osx.yml
else
	echo "Running on Linux..."

	echo "Running ansible..."
	ansible-playbook -K $current_dir/ansible/debian.yml

	# stow the stow configuration
	stow -vv -t ~ $current_dir/stow
fi
