#!/bin/bash

# stow the stow configuration
stow -vv -t ~ stow

# based on the os
echo $OSTYPE
if [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
    echo "Running on Mac OSX..."
else 
    echo "Running on Linux..."
fi
