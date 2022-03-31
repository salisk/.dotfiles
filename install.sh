#!/bin/bash

# stow the stow configuration
stow -vv -t ~ stow

# based on the os
echo $OSTYPE
if [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
    echo "Running on Mac OSX..."
    stow -vv -R -t ~ nvim
    stow -vv -R -t ~ tmux
    stow -vv -R -t ~ zsh
else 
    echo "Running on Linux..."
fi
