#!/bin/bash

# Manage RedhHat environment
if [ -f /etc/redhat-release ] ; then
  sudo yum update
  sudo yum upgrade -y
  sudo yum install -y python
fi
