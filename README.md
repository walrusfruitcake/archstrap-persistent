

**Testing**

Acceptance tests for archstrap use [Packer](https://packer.io) with [Vagrant](https://www.vagrantup.com)
to verify that the setup script can run all the way through and produce the desired outcome in a VM.
Currently, Virtualbox must also be installed as the VM provider

Run with `packer build test/acceptance.json`
