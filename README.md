# RVM 2.0

Ruby enVironment Management in Ruby

## Initialization

In some kind of shell initialization file add:

    source <( bin/rvm2 define function )

## Usage

it works like RVM 1.x:

    rvm2 list
    rvm2 current
    rvm2 use 1.9.3
    rvm2 help

Currently first 'random' ruby is used that matches pattern,
use full name to be sure proper ruby is used.
