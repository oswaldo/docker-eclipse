#!/bin/sh
ansible-playbook -i hosts scala-dev.yml --user `whoami` --sudo --ask-pass --extra-vars "sudo_user=`whoami`"
