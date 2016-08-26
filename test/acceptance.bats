#!/usr/bin/env bats

@test "install is completeable via packer" {
  run packer build acceptance.json
  [ "$status" -eq 0 ] 
}

