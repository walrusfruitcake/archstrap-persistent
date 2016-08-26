# Archstrap

Archstrap is a set of scripts I use to automate provisioning (physical) machines with [Arch](https://wiki.archlinux.org)

##Testing##

Acceptance tests for archstrap use [Packer](https://packer.io) with [Vagrant](https://www.vagrantup.com)
to verify that the setup script can run all the way through and produce the desired outcome in a VM.
Currently, Virtualbox must also be installed as the VM provider

The test framework and runner are [BATS](https://github.com/sstephenson/bats); the acceptance test can be run with `bats test/acceptance.bats`
